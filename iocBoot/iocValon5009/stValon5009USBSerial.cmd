< envPaths
epicsEnvSet("TOP", "../..")
< valon5009.config

####################################################

epicsEnvSet("STREAM_PROTOCOL_PATH", "$(TOP)/valon5009App/Db")

## Register all support components
dbLoadDatabase("$(TOP)/dbd/valon5009.dbd",0,0)
valon5009_registerRecordDeviceDriver pdbbase

# Create the asyn port for serial communication
drvAsynSerialPortConfigure("$(PORT)","${SERIALPORT}", 0, 0, 0)
asynSetOption("$(PORT)", 0, "baud", "9600")

## Load record instances
dbLoadRecords("${TOP}/db/valon5009.db", "P=$(P), R=$(R), PORT=$(PORT)")

< save_restore.cmd

iocInit

## Start any sequence programs
# No sequencer program

# Create manual trigger for Autosave
create_monitor_set("auto_settings_valon5009.req", 5, "P=${P}, R=${R}")
set_savefile_name("auto_settings_valon5009.req", "auto_settings_${P}${R}.sav")
