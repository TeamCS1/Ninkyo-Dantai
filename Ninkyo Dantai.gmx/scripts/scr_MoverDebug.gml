if keyboard_check(vk_left)
{
    x -= 1;
}

if keyboard_check(vk_right)
{
    x += 1;
}

if keyboard_check(vk_up)
{
    y -= 1;
}

if keyboard_check(vk_down)
{
    y += 1;
}

draw_self();
draw_set_color(c_white);
draw_set_font(ft_first_time_startup);
draw_text(x,y,string(x) + " | " + string(y));
show_debug_message(string(y))
