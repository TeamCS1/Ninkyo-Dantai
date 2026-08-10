/// @param x
/// @param y
/// @param string
/// @param font
/// @param color
/// @param gradient
/// @param halign
/// @param valign
/// @param border_thickness
/// @param border_color
/// @param alpha

// Set Variables
draw_set_font(argument3);
draw_set_color(argument9);
switch argument6 {
case -1: {draw_set_halign(fa_left)}; break;
case 0: {draw_set_halign(fa_center)}; break;
case 1: {draw_set_halign(fa_right)}; break;
}
switch argument7 {
case 1: {draw_set_valign(fa_top)}; break;
case 0: {draw_set_valign(fa_middle)}; break;
case -1: {draw_set_valign(fa_bottom)}; break;
}

// Draw Border
switch argument8 {
case 1:
draw_text(argument0+1,argument1,argument2);
draw_text(argument0,argument1+1,argument2);
draw_text(argument0+1,argument1+1,argument2);
draw_text(argument0+1,argument1-1,argument2);
draw_text(argument0-1,argument1+1,argument2);
draw_text(argument0-1,argument1,argument2);
draw_text(argument0,argument1-1,argument2);
draw_text(argument0-1,argument1-1,argument2);
break;
case 2:
draw_set_alpha(draw_get_alpha()/2)
draw_text(argument0-2,argument1-2,argument2);
draw_text(argument0-2,argument1-1,argument2);
draw_text(argument0-2,argument1,argument2);
draw_text(argument0-2,argument1+1,argument2);
draw_text(argument0-2,argument1+2,argument2);

draw_text(argument0-1,argument1-2,argument2);
draw_text(argument0-1,argument1+2,argument2);

draw_text(argument0,argument1-2,argument2);
draw_text(argument0,argument1+2,argument2);

draw_text(argument0+1,argument1-2,argument2);
draw_text(argument0+1,argument1+2,argument2);

draw_text(argument0+2,argument1-2,argument2);
draw_text(argument0+2,argument1-1,argument2);
draw_text(argument0+2,argument1,argument2);
draw_text(argument0+2,argument1+1,argument2);
draw_text(argument0+2,argument1+2,argument2);

draw_set_alpha(draw_get_alpha()*2)
draw_text(argument0,argument1-1,argument2);
draw_text(argument0,argument1,argument2);
draw_text(argument0,argument1+1,argument2);
draw_text(argument0+1,argument1-1,argument2);
draw_text(argument0+1,argument1,argument2);
draw_text(argument0+1,argument1+1,argument2);
draw_text(argument0-1,argument1-1,argument2);
draw_text(argument0-1,argument1,argument2);
draw_text(argument0-1,argument1+1,argument2);
break;
}

// Draw Text
draw_text_color(argument0,argument1,argument2,argument4,argument4,argument5,argument5,argument10)

// Reset Variables
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
