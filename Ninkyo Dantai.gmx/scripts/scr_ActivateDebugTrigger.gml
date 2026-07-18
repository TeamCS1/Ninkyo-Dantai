//open debug commands menu
openPopup = true;
    
if openPopup == true
{
    global.freezePlayer = true;
    global.debugActive = true;
    scr_call_input(10, 130, obj_buruwasu_debug_console, 512,obj_input);
    //global.debugModeEnablerBuruwasu = get_string("Console:", "/");
}




