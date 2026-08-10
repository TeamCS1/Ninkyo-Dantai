var _x, _y, _s;
_x = argument0;
_y = argument1;
_s = argument2;

//draws the rectangle of minimap
draw_set_color(c_black);
draw_set_alpha(0.5);
draw_rectangle(_x, _y, _x + room_width / _s, _y + room_height / _s, false);
draw_set_alpha(1.0);

//List each object here...

with(obj_water_anim_buruwasu)
{
    draw_set_color(c_aqua);
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 1)
}


with(obj_canal_buruwasu)
{
    draw_set_color(c_maroon);
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 1)
}


with(obj_roadv)
{
    draw_set_color(c_black);
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)
}

with(obj_roadh)
{
    draw_set_color(c_black)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)
}

with(obj_roadm)
{
    draw_set_color(c_black)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)

}

with(obj_t_junction_left)
{
    draw_set_color(c_black)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)

}

with(obj_t_junction_right)
{
    draw_set_color(c_black)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)

}

//BOTH highway halves - horizontal and vertical are separate objects, and
//listing only one drew Yokyohama's highway on its east-west runs while it
//vanished on the north-south ones.
with(obj_roadh_highway)
{
    draw_set_color(c_maroon)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), false)

}

with(obj_roadv_highway)
{
    draw_set_color(c_maroon)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), false)

}

with(obj_road_horiz_construction)
{
    draw_set_color(c_black)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)

}

with(obj_grass_old)
{
    draw_set_color(c_olive)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), true)

}

with(obj_sidewalk_mall_buruwasu)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)

}

//Mall and interior floor, matching the mall pavement above so the surface
//reads as continuous through the entrance.
with(obj_block_modern_mall_floor1)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)

}

//Interior walls, drawn after the floor so they sit on top of it. Slate
//blue rather than the white used for exterior buildings, or they would
//disappear into the pale floor they stand on. Matches scr_DrawMinimap.
with(obj_modern_mall_interior_block)
{
    draw_set_color(make_colour_rgb(96,112,150))
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)

}

with(obj_parking_lot_vert)
{
    draw_set_color(c_yellow)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), true)

}

with(obj_parking_lot_horiz)
{
    draw_set_color(c_yellow)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), true)

}

with(obj_parking_lot_empty)
{
    draw_set_color(c_yellow)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 1)

}

//Every sidewalk variant needs its own with() here - the city-specific
//pavements are separate objects, so one missing type means that city's
//pavement is simply absent from this map. scr_DrawMinimap carries the
//same list; keep the two in step or the panel and this map disagree.
with(obj_side_walk_buruwasu)
{
    draw_set_color(make_colour_rgb(200,200,200))
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)

}

with(obj_sidewalk_yokyohama)
{
    draw_set_color(make_colour_rgb(200,200,200))
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)

}

//Cold tint for Ichihara's snow pavement, matching scr_DrawMinimap
with(obj_side_walk_snow_buruwasu)
{
    draw_set_color(make_colour_rgb(176,198,219))
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)

}

with(obj_alleyway_floor)
{
    draw_set_color(make_colour_rgb(50,50,50))
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)

}

with(obj_grass_buruwasu)
{
    draw_set_color(c_green)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), true)

}

with(obj_house_block001)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), true)

}

with(obj_house_block002)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 0)

}

with(obj_house_high_rise)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), true)
}

with(obj_house_red_block001)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), true)

}

with(obj_house_blue_block001)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), true)

}

with(obj_house_green_block001)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), true)

}

with(obj_house_violet_block001)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), true)

}

with(obj_construction_dirt)
{
    draw_set_color(c_maroon)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), true)

}

with(obj_shopping_mall_block_exterior)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 1)

}

with(obj_shop_computer_shop)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 1)

}

with(obj_shop_shine_of_light)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 1)

}

with(obj_garage001)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 1)

}

with(obj_block_shop_sushi_bar001)
{
    draw_set_color(c_white)
    draw_rectangle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s), _x + x / _s + sprite_width / (2 * _s), _y + y / _s + sprite_width / (2 * _s), 1)

}

with(obj_gun_shop_corona_shine_of_light)
{
    draw_set_color(c_purple)
    draw_circle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s),irandom_range(2,4),false);

}

with(obj_taxi_corona)
{
    draw_set_color(c_orange)
    draw_circle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s),3,false);

}

//Player marker. Always drawn from the player instance, never from the
//vehicle: scr_VehicleStep parks obj_player_buruwasu on top of whatever
//you're driving every step, so its position is already the vehicle's.
//That covers all ten vehicles, and any added later, without a branch per
//type - which is what this used to have, and it only ever listed obj_car
//and obj_police_car, so the other eight left the map with no marker at
//all while you drove them.
with(obj_player_buruwasu)
{
    if global.inVehicle == true
    {
        draw_set_color(c_green)
    }
    else
    {
        draw_set_color(make_colour_rgb(0,255,255))  //cyan
    }

    draw_circle(_x + x / _s - sprite_width / (2 * _s), _y + y / _s - sprite_width / (2 * _s),3,false);
}

//[MAP X] + x / [MAP SCALE]
//[MAP Y] + y / [MAP SCALE]
