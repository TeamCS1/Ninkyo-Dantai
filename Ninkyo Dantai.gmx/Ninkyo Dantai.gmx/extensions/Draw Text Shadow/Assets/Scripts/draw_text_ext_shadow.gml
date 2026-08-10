///draw_text_ext_shadow(x, y, string, sep, w, shadow length, shadow direction, shadow color, shadow alpha);
//@tehwave

/*  Argument            Description

0   x                   The x coordinate of the drawn string. 
1   y                   The y coordinate of the drawn string. 
2   string              The string to draw. 
3   sep                 The distance in pixels between lines of text. 
4   w                   The maximum width in pixels of the string before a line break.
    
5   shadow length       The distance in pixels between text and shadow.
6   shadow direction    The angle of the shadow.
7   shadow color        The color of the shadow.
8   shadow alpha        The alpha of the shadow.
*/

//init & assign vars
var xx = argument0, yy = argument1, str = argument2, sh_len = argument5,
    sh_dir = argument6, prev_alpha = draw_get_alpha(), prev_col = draw_get_color()
    sep = argument3, w = argument4;
    
//draw text shadow
draw_set_color(argument7);
draw_set_alpha(argument8);
draw_text_ext(xx+lengthdir_x(sh_len,sh_dir),yy+lengthdir_y(sh_len,sh_dir),str, sep, w);

//draw text
draw_set_color(prev_col);
draw_set_alpha(prev_alpha);
draw_text_ext(xx, yy, str, sep, w);

