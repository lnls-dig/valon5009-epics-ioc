TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = valon5009
# valon5009.dbd will be created and installed
DBD += valon5009.dbd

# valon5009.dbd will be made up from these files:
valon5009_DBD += base.dbd

# Include dbd files from all support applications:
#valon5009_DBD += xxx.dbd

# Add all the support libraries needed by this IOC
#valon5009_LIBS += xxx

# valon5009_registerRecordDeviceDriver.cpp derives from valon5009.dbd
valon5009_SRCS += valon5009_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
valon5009_SRCS_DEFAULT += valon5009Main.cpp
valon5009_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#valon5009_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
valon5009_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

valon5009_DBD += asyn.dbd
valon5009_DBD += drvAsynSerialPort.dbd
valon5009_DBD += stream.dbd
valon5009_DBD += calcSupport.dbd
valon5009_DBD += asSupport.dbd

valon5009_LIBS += asyn
valon5009_LIBS += stream
valon5009_LIBS += calc
valon5009_LIBS += autosave
