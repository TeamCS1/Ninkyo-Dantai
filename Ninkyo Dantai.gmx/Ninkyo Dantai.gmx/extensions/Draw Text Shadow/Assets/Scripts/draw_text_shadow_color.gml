///draw_text_shadow_color(x, y, string, shadow length, shadow direction, shadow c1, shadow c2, shadow c3, shadow c4, shadow alpha);
// @tehwave

/*  Argument            Description

0   x                   The x coordinate of the drawn string. 
1   y                   The y coordinate of the drawn string. 
2   string              The string to draw.

3   shadow length       The distance in pixels between text and shadow.      
4   shadow direction    The angle of the shadow.
5   shadow c1           The color for the top left of the shadow.
6   shadow c2           The color for the top right of the shadow.
7   shadow c3           The color for the bottom right of the shadow.
8   shadow c4           The color for the bottom left of the shadow.        
9   shadow alpha        The alpha of the shadow.
*/

//init & assign vars
var xx = argument0, yy = argument1, str = argument2, sh_len = argument3,
    sh_dir = argument4;
    
//draw text shadow
draw_text_color(xx+lengthdir_x(sh_len,sh_dir),yy+lengthdir_y(sh_len,sh_dir), str, argument3, argument4, argument5, argument6, argument9);

//draw text
draw_text(xx, yy, str);