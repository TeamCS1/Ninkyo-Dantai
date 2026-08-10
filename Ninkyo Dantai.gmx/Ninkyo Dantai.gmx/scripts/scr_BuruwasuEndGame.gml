with obj_waypoint_controller_buruwasu
{
    instance_destroy()
}

with obj_gui_buruwasu
{
    instance_destroy()
}


with obj_control
{
    instance_destroy()
}
        
with obj_player_buruwasu
{
    instance_destroy()
}

draw_set_alpha_test(false);    
draw_set_color(c_white);
draw_set_alpha(1);
d3d_set_fog(false,c_white,0,0);
d3d_end();

room_goto(rm_new_minigames_menu)
game_restart();
room_goto(rm_new_minigames_menu)
room_restart();
draw_texture_flush();
room_restart();
display_reset(0,1);
game_end();
