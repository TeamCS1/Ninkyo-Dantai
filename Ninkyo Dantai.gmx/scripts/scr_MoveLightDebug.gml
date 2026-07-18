if keyboard_check_released(ord('O'))
{
    lightX -= 16;
}

if keyboard_check_released(ord('P'))
{
    lightX += 16;   
}

if keyboard_check_released(ord('K'))
{
    lightY -= 16;
}

if keyboard_check_released(ord('L'))
{
    lightY += 16;
}

if keyboard_check_released(ord('N'))
{
    lightZ -= 16;
}

if keyboard_check_released(ord('M'))
{
    lightZ += 16;
}

d3d_light_define_point(light,(lightX + lightXOffset),(lightY + lightYOffset),(lightZ + lightZOffset),lightRange,c_yellow); 
d3d_light_enable(light, true); 

draw_set_font(ft_map_editor_buruwasu);
draw_set_color(c_blue);
draw_text(200,200,string(lightX));
draw_text(200,230,string(lightY));
draw_text(200,260,string(lightZ));
draw_text(200,300,string(lightXOffset));
draw_text(200,330,string(lightYOffset));
draw_text(200,360,string(lightZOffset));
draw_set_color(c_white);



