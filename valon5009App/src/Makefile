TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

# Build an IOC support library
LIBRARY_IOC += valon5009Support

# Link locally-provided code into the support library,
# rather than directly into the IOC application.
# This is required for Windows DLL builds.
valon5009Support_SRCS += dbSubValon.c

valon5009Support_LIBS += $(EPICS_BASE_IOC_LIBS)

# Build the IOC application
PROD_IOC = valon5009
# valon5009.dbd will be created and installed
DBD += valon5009.dbd

# valon5009.dbd will be made up from these files:
valon5009_DBD += base.dbd

# Include dbd files from all support applications:
#valon5009_DBD += xxx.dbd
valon5009_DBD += dbSubValon.dbd

# Add all the support libraries needed by this IOC
#valon5009_LIBS += xxx

# valon5009_registerRecordDeviceDriver.cpp derives from valon5009.dbd
valon5009_SRCS += valon5009_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
valon5009_SRCS_DEFAULT += valon5009Main.cpp
valon5009_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#valon5009_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Link in the code from our support library
valon5009_LIBS += valon5009Support
valon5009_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

valon5009_DBD += asyn.dbd
valon5009_DBD += drvAsynSerialPort.dbd
valon5009_DBD += drvAsynIPPort.dbd
valon5009_DBD += stream.dbd
valon5009_DBD += calcSupport.dbd
valon5009_DBD += asSupport.dbd

valon5009_LIBS += asyn
valon5009_LIBS += stream
valon5009_LIBS += calc
valon5009_LIBS += autosave
