# valon5009-epics-ioc

### Overall

Repository containing the EPICS IOC support for the Valon 5009 Frequency Synthesizer.

### Building

In order to build the IOC, from the top level directory, run:

```sh
$ make clean uninstall install
```
### Running

In order to run the IOC, from the top level directory, run:

```sh
$ cd iocBoot/iocValon5009 &&
$ ./runValon5009.sh -p "PORT"
```

where `PORT` is the local serial port to which the device is connected. The options
that you can specify (after `./runValon5009.sh`) are:

- `-t TELNET_PORT`: telnet port to use for connecting to procServ
- `-p `PORT`: serial port to connect to device (required)
- `-P PREFIX1`: the value of the EPICS `$(P)` macro used to prefix the PV names
- `-R PREFIX2`: the value of the EPICS `$(R)` macro used to prefix the PV names

In some situations it is desired to run the process using procServ,
which enables the IOC to be controlled by the system. In order to
run the IOC with procServ, instead of the previous command, run:

```sh
$ procServ -n "VALON" -f -i ^C^D 20000 ./runValon5009.sh -p "/dev/ttyS0" -P "Test:" -R "Valon5009:"
```

where the options are as previously described.
