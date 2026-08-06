///scr_DrawMinimap()
///Draws the always-on minimap panel: a black-bordered box with a 90%
///opacity fill, showing the world immediately around the player, centred
///on them. Call from a Draw GUI event.
///
///This is the same idea as scr_minimap (the Tab map), but centred on the
///player and clipped to a panel instead of laying the whole 25000x25000
///room out at once. It reuses that map's colour scheme deliberately, so
///the two read as the same map at different zooms: pale blocks are
///buildings, mid-grey is pavement, and roads are simply the dark gaps
///left between them rather than anything drawn.
///
///COST: the with() loops below walk every instance of each type. That's
///only affordable because scr_CullDistantScenery has deactivated
///everything far from the player, and with() skips deactivated
///instances - so in practice these loops only ever touch what's nearby.
///Turning culling off with "/cull" makes this panel walk all ~6,800
///instances every frame instead.
///
///Consequently global.minimapRange must stay inside global.cullRange, or
///the panel's corners show empty ground that has merely been deactivated.
///The diagonal is what matters: minimapRange * 1.42 must be <= cullRange.

if global.minimapEnabled == false
{
    exit;
}

if global.hideAllGameElements == true
{
    exit;
}

var _size = global.minimapSize;
var _pad = global.minimapPad;
var _border = 3;

global.mmBoxX1 = _pad;
global.mmBoxY1 = _pad;
global.mmBoxX2 = _pad + _size;
global.mmBoxY2 = _pad + _size;

global.mmCentreGuiX = global.mmBoxX1 + _size / 2;
global.mmCentreGuiY = global.mmBoxY1 + _size / 2;

global.mmCentreWorldX = global.playerX;
global.mmCentreWorldY = global.playerY;

// World units per panel pixel
global.mmScale = (global.minimapRange * 2) / _size;

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Border first, as a solid black frame just outside the fill
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(global.mmBoxX1 - _border, global.mmBoxY1 - _border,
               global.mmBoxX2 + _border, global.mmBoxY2 + _border, false);

// Panel fill
draw_set_alpha(0.9);
draw_rectangle(global.mmBoxX1, global.mmBoxY1, global.mmBoxX2, global.mmBoxY2, false);
draw_set_alpha(1);

// ---- Ground
with (obj_water_anim_buruwasu)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_aqua, false);
}

with (obj_canal_buruwasu)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_maroon, false);
}

with (obj_grass_buruwasu)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_green, false);
}

with (obj_grass_old)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_olive, false);
}

with (obj_construction_dirt)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_maroon, false);
}

with (obj_alleyway_floor)
{
    scr_MinimapMark(x, y, sprite_width / 2, make_colour_rgb(50, 50, 50), false);
}

// ---- Pavement
with (obj_side_walk_buruwasu)
{
    scr_MinimapMark(x, y, sprite_width / 2, make_colour_rgb(150, 150, 150), false);
}

with (obj_sidewalk_mall_buruwasu)
{
    scr_MinimapMark(x, y, sprite_width / 2, make_colour_rgb(150, 150, 150), false);
}

// ---- Parking
with (obj_parking_lot_vert)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_yellow, true);
}

with (obj_parking_lot_horiz)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_yellow, true);
}

with (obj_parking_lot_empty)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_yellow, true);
}

// ---- Highway stands out from ordinary road
with (obj_roadh_highway)
{
    scr_MinimapMark(x, y, sprite_width / 2, make_colour_rgb(90, 60, 60), false);
}

// ---- Buildings
with (obj_house_block001)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_white, false);
}

with (obj_house_block002)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_white, false);
}

with (obj_house_high_rise)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_white, false);
}

with (obj_house_red_block001)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_white, false);
}

with (obj_house_blue_block001)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_white, false);
}

with (obj_house_green_block001)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_white, false);
}

with (obj_house_violet_block001)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_white, false);
}

with (obj_shopping_mall_block_exterior)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_white, false);
}

with (obj_garage001)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_white, false);
}

// ---- Shops, worth picking out from ordinary buildings
with (obj_shop_computer_shop)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_lime, false);
}

with (obj_shop_shine_of_light)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_lime, false);
}

with (obj_block_shop_sushi_bar001)
{
    scr_MinimapMark(x, y, sprite_width / 2, c_lime, false);
}

// ---- Points of interest
with (obj_gun_shop_corona_shine_of_light)
{
    scr_MinimapMark(x, y, 40, c_purple, false);
}

with (obj_taxi_corona)
{
    scr_MinimapMark(x, y, 40, c_orange, false);
}

// ---- The player sits at the centre by definition, with a stub showing
// which way the camera is facing
var _heading = obj_control.bearing;
var _len = 14;

draw_set_color(c_red);
draw_line_width(global.mmCentreGuiX, global.mmCentreGuiY,
                global.mmCentreGuiX + lengthdir_x(_len, _heading),
                global.mmCentreGuiY + lengthdir_y(_len, _heading), 2);

draw_set_color(make_colour_rgb(0, 255, 255));
draw_circle(global.mmCentreGuiX, global.mmCentreGuiY, 4, false);

draw_set_color(c_white);
draw_set_alpha(1);
