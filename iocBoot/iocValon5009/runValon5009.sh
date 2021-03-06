#!/bin/sh

set -e
set +u

# Source environment
. ./checkEnv.sh

# Parse command-line options
. ./parseCMDOpts.sh "$@"

# Check last command return status
if [ $? -ne 0 ]; then
	echo "Could not parse command-line options" >&2
	exit 1
fi

if [ -z "${DEVICE_TYPE}" ]; then
    echo "Device not set. Please use -d option or set \$DEVICE_TYPE environment variable" >&2
    exit 3
fi

if [ "${DEVICE_TYPE}" = "UserPortEth" ] && [ -z "${IPADDR}" ]; then
    echo "IP address not set. Please use -i option or set \$IPADDR environment variable" >&2
    exit 4
fi

if [ "${DEVICE_TYPE}" = "USBSerial" ] && [ -z "${SERIALPORT}" ]; then
    echo "Serial Port not set. Please use -is option or set \$SERIALPORT environment variable" >&2
    exit 5
fi

if [ -z "$EPICS_CA_MAX_ARRAY_BYTES" ]; then
    export EPICS_CA_MAX_ARRAY_BYTES="50000000"
fi

cd "$IOC_BOOT_DIR"

# FIXME. redundancy on this variable. This is also defined
# at the st.cmd file
STREAM_PROTO_DIR="../../valon5009App/Db"
STREAM_IN_FILE="valon5009.proto.in"
STREAM_OUT_FILE="valon5009.proto"
STREAM_PROTO_IN_FILE="${STREAM_PROTO_DIR}/${STREAM_IN_FILE}"
STREAM_PROTO_OUT_FILE="${STREAM_PROTO_DIR}/${STREAM_OUT_FILE}"

ST_CMD_FILE=
# Select the appropriate ST_CMD file and
# Generate .proto from .proto.in depending on $DEVICE_TYPE
case ${DEVICE_TYPE} in
    USBSerial)
        ST_CMD_FILE=stValon5009USBSerial.cmd
        sed -e 's/<TERMINATOR>/\\r\\n/g' -e 's/<REPLY_TIMEOUT>/2000/g' ${STREAM_PROTO_IN_FILE} > ${STREAM_PROTO_OUT_FILE}
        ;;

    UserPortEth)
        ST_CMD_FILE=stValon5009UserPortEth.cmd
        sed -e 's/<TERMINATOR>/\\r\\n/g' -e 's/<REPLY_TIMEOUT>/2000/g' ${STREAM_PROTO_IN_FILE} > ${STREAM_PROTO_OUT_FILE}
        ;;
    *)
        echo "Invalid Device type: "${DEVICE_TYPE} >&2
        exit 1
        ;;
esac

echo "Using st.cmd file: "${ST_CMD_FILE}

set +e

IPADDR="$IPADDR" IPPORT="$IPPORT" SERIALPORT="$SERIALPORT" P="$P" R="$R" "$IOC_BIN" ${ST_CMD_FILE}
