///scr_MainMenuSelect()
///Acts on whatever the main menu currently has highlighted. This is the
///"Enter" action, factored out so the keyboard and the gamepad both run
///exactly the same code rather than two copies that can drift apart.
///
///Called from obj_main_menu_controller_buruwasu's KeyReleased vk_enter
///event, and from its Step event when global.gamepadNavConfirm is set.
///
///MUST be called from obj_main_menu_controller_buruwasu - it reads that
///object's menuChoice / hasStartedLoading / loadingString / progress and
///sets its alarm[0], all of which resolve against the calling instance.

if menuChoice == 0 && hasStartedLoading == false
{
    hasStartedLoading = true;
    window_set_cursor(cr_hourglass);
    loadingString = "Creating Game Data..."
    progress = 0;
    alarm[0] = room_speed * 0.5;
}

//load game
else if menuChoice == 1 && hasStartedLoading == false
{
    //load function
    if file_exists("savedata.ini")
    {
        scr_load();

        hasStartedLoading = true;
        window_set_cursor(cr_hourglass);
        loadingString = "Loading Game Data..."
        progress = 0;
        alarm[0] = room_speed * 0.5;
    }

}

else if menuChoice == 2
{
    if !instance_exists(obj_main_menu_options)
    {
        instance_create(x,y,obj_main_menu_options);
    }
}

else if menuChoice == 3 // character profiles
{
    game_end();
}

else if menuChoice == 4 // dlc
{
    game_end();
}

else if menuChoice == 5 // credits
{
    room_goto(rm_buruwasu_credits);
}

else if menuChoice == 6 // quit
{
    game_end();
}
