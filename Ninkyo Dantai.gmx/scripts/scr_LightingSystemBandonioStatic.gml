///scr_LightingSystemBandonioStatic(r,g,b,size)

var lightColorR = argument[0];
var lightColorG = argument[1];
var lightColorB = argument[2];
var lightSize = argument[3];

if global.isSoloBandonio == 1
{
    if surface_exists(global.light)
    {
        ///draw the light
        size = lightSize; // change this value to make the light larger
    
        //switch drawing mode to draw on the light surface
        draw_set_blend_mode(bm_subtract);
        surface_set_target(global.light);
    
        //change c_white to another color for colored lights!
        draw_ellipse_color(x-size/2-view_xview[2],y-size/2-view_yview[2],x+size/2-view_xview[2]
        ,y+size/2-view_yview[2],make_colour_rgb(lightColorR,lightColorG,lightColorB),c_black,false);
    
        //put the drawing mode back to normal
        surface_reset_target();
        draw_set_blend_mode(bm_normal);
    }
}

else if global.isSoloBandonio == 2
{
    if surface_exists(global.light0)
    {
        ///draw the light
        size = lightSize; // change this value to make the light larger
    
        //switch drawing mode to draw on the light surface
        draw_set_blend_mode(bm_subtract);
        surface_set_target(global.light0);
    
        //change c_white to another color for colored lights!
        draw_ellipse_color(x-size/2-view_xview[0],y-size/2-view_yview[0],x+size/2-view_xview[0]
        ,y+size/2-view_yview[0],make_colour_rgb(lightColorR,lightColorG,lightColorB),c_black,false);
    
        //put the drawing mode back to normal
        surface_reset_target();
        draw_set_blend_mode(bm_normal);
    }
    
    if surface_exists(global.light1)
    {
        ///draw the light
        size = lightSize; // change this value to make the light larger
    
        //switch drawing mode to draw on the light surface
        draw_set_blend_mode(bm_subtract);
        surface_set_target(global.light1);
    
        //change c_white to another color for colored lights!
        draw_ellipse_color(x-size/2-view_xview[1],y-size/2-view_yview[1],x+size/2-view_xview[1]
        ,y+size/2-view_yview[1],make_colour_rgb(lightColorR,lightColorG,lightColorB),c_black,false);
    
        //put the drawing mode back to normal
        surface_reset_target();
        draw_set_blend_mode(bm_normal);
    }
}
