///scr_DrawCollisionBoxModel(colour,modelBottomZ,modelTopZ)
//Function programmed by Tabeer Mohammed v2 (c)
//Now adapts to sprite scaling
colour = argument0;
modelBottomZ = argument1;
modelTopZ = argument2;

//draws collision box for model
draw_set_alpha(0.5);
draw_set_color(colour);
//d3d_transform_add_rotation_z(zDirection - 270);
//old way:
d3d_draw_block(x, y, modelBottomZ, x + sprite_get_width(sprite_index) * image_xscale, y + sprite_get_height(sprite_index) * image_yscale, modelTopZ, -1, 1, 1);




draw_set_alpha(1.0);
draw_set_color(c_white);
d3d_transform_set_identity();
