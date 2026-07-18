//This script exists as there are two places where this gets called.

if !instance_exists(obj_save_trigger_SBB)
{
    instance_create(obj_pause_menu_options_general_button.x + 30,obj_pause_menu_options_general_button.y + 71,obj_save_trigger_SBB)
}

if !instance_exists(obj_load_trigger_SBB)
{
    instance_create(obj_pause_menu_options_general_button.x + 30,obj_pause_menu_options_general_button.y + 109,obj_load_trigger_SBB)
}
