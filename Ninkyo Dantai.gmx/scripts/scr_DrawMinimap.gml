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

// Shadow and fill go under the contents; the frame goes over them at the
// end of this script, so the border edge stays clean
scr_DrawMinimapBackdrop();

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

// Alleyways get a checkerboard rather than a flat block, so they read as
// a different surface to the open road at a glance. The two colours and
// the cell size are the whole look - change them here.
var _alleyBrown = make_colour_rgb(138, 112, 84);
var _alleyGrey = make_colour_rgb(92, 92, 98);
var _alleyCell = 128;   // world pixels; tiles are 256, so this is a 2x2 check

with (obj_alleyway_floor)
{
    scr_MinimapMarkChecker(x, y, sprite_width / 2, _alleyCell, _alleyBrown, _alleyGrey);
}

// ---- Pavement
//
// EVERY sidewalk variant has to be listed here, not just the Buruwasu one.
// The city-specific variants are separate objects rather than one object
// with a texture switch, so a new city's pavement is invisible on this
// panel until its type is added below. That is what happened to Ichihara
// (88 snow tiles against 73 ordinary ones, so half its pavement vanished)
// and to Yokyohama, which lost all 91 of its own.
with (obj_side_walk_buruwasu)
{
    scr_MinimapMark(x, y, sprite_width / 2, make_colour_rgb(150, 150, 150), false);
}

with (obj_sidewalk_yokyohama)
{
    scr_MinimapMark(x, y, sprite_width / 2, make_colour_rgb(150, 150, 150), false);
}

// Ichihara's snow pavement gets a cold tint rather than the ordinary grey,
// so a snowed-in street reads as different ground at a glance. Deliberately
// not near-white: buildings are already pure white on this panel, and a
// pale snow would blur into them.
with (obj_side_walk_snow_buruwasu)
{
    scr_MinimapMark(x, y, sprite_width / 2, make_colour_rgb(176, 198, 219), false);
}

// Mall floor is checkered black and white, which separates it from the
// ordinary pavement it used to share a grey with.
//
// The dark squares are a lifted black rather than pure: the panel fill
// behind them is already rgb(8,12,16), so true black would vanish into it
// and the pattern would read as scattered white squares rather than a
// checkerboard. Drop it to c_black if you want that instead.
var _mallWhite = c_white;
var _mallBlack = make_colour_rgb(28, 28, 32);
var _mallCell = 128;    // world pixels; tiles are 256, same 2x2 as the alleyways

with (obj_sidewalk_mall_buruwasu)
{
    scr_MinimapMarkChecker(x, y, sprite_width / 2, _mallCell, _mallWhite, _mallBlack);
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

// ---- Highway stands out from ordinary road.
// BOTH halves. These are a horizontal and a vertical object, and only the
// horizontal one used to be listed, so Yokyohama's highway was drawn on
// its east-west runs and vanished on its north-south ones.
var _highway = make_colour_rgb(90, 60, 60);

with (obj_roadh_highway)
{
    scr_MinimapMark(x, y, sprite_width / 2, _highway, false);
}

with (obj_roadv_highway)
{
    scr_MinimapMark(x, y, sprite_width / 2, _highway, false);
}

// ---- Mall and interior floors, same checkerboard as the mall pavement
// outside so the surface reads as continuous through the entrance.
with (obj_block_modern_mall_floor1)
{
    scr_MinimapMarkChecker(x, y, sprite_width / 2, _mallCell, _mallWhite, _mallBlack);
}

// ---- Interior walls. Used by the mall, Chicken Licken and Shinji's home
// alike, so this is "interior structure" generally, not a mall-only colour.
//
// A slate blue rather than the white used for exterior buildings: the
// floor beneath it is a white-and-near-black check, so white walls would
// disappear into the pale squares and near-black ones into the dark.
with (obj_modern_mall_interior_block)
{
    scr_MinimapMark(x, y, sprite_width / 2, make_colour_rgb(96, 112, 150), false);
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

// ---- The player sits at the centre by definition. Drawn as an arrowhead
// rather than a dot so the marker carries the facing as well as the
// position - which is why there's no separate heading line any more.
//
// Built from three points around the centre: a tip along the heading, and
// two back corners swept 140 degrees either side of it. Widening that
// angle gives a squatter arrow, narrowing it a longer dart.
var _mmCX = global.mmCentreGuiX;
var _mmCY = global.mmCentreGuiY;

// Which way to point the arrow.
//
// NOT obj_control.bearing, which is the obvious choice and the wrong one:
// it's set to 90 in obj_control's Create and then only ever written by
// scr_VehicleStep, so on foot it never moves off north and the arrow sits
// frozen. The player's own direction is what actually tracks where you're
// facing. In a vehicle the player instance is dragged along without its
// direction being updated, so there we do want bearing - because that's
// exactly what the vehicle has just written to it.
var _heading = 90;

if global.inVehicle == true
{
    _heading = obj_control.bearing;
}
else
{
    if instance_exists(obj_player_buruwasu)
    {
        _heading = obj_player_buruwasu.direction;
    }
}

// NaN never equals itself. lengthdir of a NaN angle yields NaN
// coordinates, which draw as nothing at all rather than failing loudly.
if _heading != _heading
{
    _heading = 90;
}

// Size comes from global.minimapArrowSize so it can be tuned without
// touching this script; the rest of the shape scales off it.
var _tipLen = global.minimapArrowSize;      // centre to the point
var _backLen = global.minimapArrowSize * 0.7; // centre to each back corner
var _backAngle = 145;   // sweep of the back corners either side of the tip
var _outline = max(2, global.minimapArrowSize * 0.1); // dark copy's overhang

draw_set_alpha(1);

// A dark copy a little larger first, so the marker stays legible whether
// it's sitting on a black road or a white building. See the script for
// why these don't just call draw_triangle directly.
scr_DrawMinimapArrow(_mmCX, _mmCY, _heading,
                     _tipLen + _outline, _backLen + _outline, _backAngle,
                     c_black);

scr_DrawMinimapArrow(_mmCX, _mmCY, _heading,
                     _tipLen, _backLen, _backAngle,
                     make_colour_rgb(0, 255, 255));

// Frame last, so nothing above has drawn over its inside edge
scr_DrawMinimapFrame();

draw_set_color(c_white);
draw_set_alpha(1);
