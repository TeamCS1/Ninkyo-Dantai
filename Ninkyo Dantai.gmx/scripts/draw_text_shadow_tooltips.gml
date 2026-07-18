/// draw_text_shadow(x, y, string, font, shadow_size, shadow_colour, text_colour1,text_colour2,text_alpha,shadow_alpha);
var _string, _font, _shadow_size, _shadow_colour, _text_colour1,_text_colour2,_text_alpha,_shadow_alpha;
_x = 20
_y = 1000
_string = argument[0];
_font = argument[1];
_shadow_size = argument[2];
_shadow_colour = argument[3];
_text_colour1 = argument[4];
_text_colour2 = argument[5];
_text_alpha = argument[6];
_shadow_alpha = argument[7];

draw_set_font(_font);

//draws shadow
draw_text_colour((_x + _shadow_size), (_y + _shadow_size), string(_string),_shadow_colour,_shadow_colour,_shadow_colour,_shadow_colour,_shadow_alpha);
//draws text
draw_text_colour(_x,_y,string(_string),_text_colour1,_text_colour2,_text_colour1,_text_colour2,_text_alpha);
