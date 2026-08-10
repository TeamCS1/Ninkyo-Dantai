/// draw_text_shadow(x, y, string, font, shadow_size, shadow_colour, text_colour1,text_colour2,text_alpha,shadow_alpha);
var _x, _y, _string, _font, _shadow_size, _shadow_colour, _text_colour1,_text_colour2,_text_alpha,_shadow_alpha;
_x = argument[0];
_y = argument[1];
_string = argument[2];
_font = argument[3];
_shadow_size = argument[4];
_shadow_colour = argument[5];
_text_colour1 = argument[6];
_text_colour2 = argument[7];
_text_alpha = argument[8];
_shadow_alpha = argument[9];

draw_set_font(_font);

//draws shadow
draw_text_colour((_x + _shadow_size), (_y + _shadow_size), string(_string),_shadow_colour,_shadow_colour,_shadow_colour,_shadow_colour,_shadow_alpha);
//draws text
draw_text_colour(_x,_y,string(_string),_text_colour1,_text_colour2,_text_colour1,_text_colour2,_text_alpha);
