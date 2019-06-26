importPackage(Packages.org.csstudio.opibuilder.scriptUtil);

var flagName = "advanced";

// initialize advanced flag
if(widget.getVar(flagName) == null){
    widget.setVar(flagName, false);
}

// switch between common and advanced OPI modes 
if (widget.getVar(flagName) == false) {
    display.getWidget("Linking_Container_0").setPropertyValue(
	    "opi_file", "valon5009_channel_advanced.opi");
    display.getWidget("Linking_Container_1").setPropertyValue(
	    "opi_file", "valon5009_channel_advanced.opi");
    display.getWidget("Linking_Container_2").setPropertyValue(
	    "opi_file", "valon5009_refsource_advanced.opi");
    display.getWidget("action_button_0").setPropertyValue(
	    "text", "Hide Advanced");
	    widget.setVar(flagName, true);
}
else {
    display.getWidget("Linking_Container_0").setPropertyValue(
	    "opi_file", "valon5009_channel_common.opi");
    display.getWidget("Linking_Container_1").setPropertyValue(
	    "opi_file", "valon5009_channel_common.opi");
    display.getWidget("Linking_Container_2").setPropertyValue(
	    "opi_file", "");
    display.getWidget("action_button_0").setPropertyValue(
	    "text", "Advanced");
    widget.setVar(flagName, false);
}