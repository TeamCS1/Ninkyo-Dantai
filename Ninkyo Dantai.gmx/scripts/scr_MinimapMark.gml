///scr_MinimapMark(world_x, world_y, world_half_size, colour, outline_only)
///Draws one blip on the always-on minimap, converting a world position
///into the minimap panel and clipping it to the panel's edges.
///
///Reads the transform scr_DrawMinimap set up for this frame
///(global.mm*), so it must only be called from inside that script.
///
///Clipping is done by clamping each blip to the panel bounds rather than
///with a surface: it keeps the panel free of surface lifetime handling,
///and a blip half outside the edge still draws the half that's inside.

var _wx = argument0;
var _wy = argument1;
var _half = argument2;
var _colour = argument3;
var _outline = argument4;

var _x1 = global.mmCentreGuiX + (_wx - _half - global.mmCentreWorldX) / global.mmScale;
var _y1 = global.mmCentreGuiY + (_wy - _half - global.mmCentreWorldY) / global.mmScale;
var _x2 = global.mmCentreGuiX + (_wx + _half - global.mmCentreWorldX) / global.mmScale;
var _y2 = global.mmCentreGuiY + (_wy + _half - global.mmCentreWorldY) / global.mmScale;

// Entirely off the panel - nothing to draw
if (_x2 < global.mmBoxX1) or (_x1 > global.mmBoxX2)
{
    exit;
}

if (_y2 < global.mmBoxY1) or (_y1 > global.mmBoxY2)
{
    exit;
}

_x1 = clamp(_x1, global.mmBoxX1, global.mmBoxX2);
_x2 = clamp(_x2, global.mmBoxX1, global.mmBoxX2);
_y1 = clamp(_y1, global.mmBoxY1, global.mmBoxY2);
_y2 = clamp(_y2, global.mmBoxY1, global.mmBoxY2);

draw_set_color(_colour);
draw_rectangle(_x1, _y1, _x2, _y2, _outline);
