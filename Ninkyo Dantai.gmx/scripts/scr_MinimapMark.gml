///scr_MinimapMark(world_x, world_y, world_half_size, colour, outline_only)
///Draws one blip on the always-on minimap from a centre point and a half
///size, which is what the with() loops in scr_DrawMinimap have to hand
///(a position and sprite_width / 2).
///
///The conversion and clipping live in scr_MinimapMarkRect so that this
///and scr_MinimapMarkChecker can't drift apart.

var _wx = argument0;
var _wy = argument1;
var _half = argument2;
var _colour = argument3;
var _outline = argument4;

scr_MinimapMarkRect(_wx - _half, _wy - _half,
                    _wx + _half, _wy + _half,
                    _colour, _outline);
