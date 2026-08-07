///scr_MinimapMarkRect(world_x1, world_y1, world_x2, world_y2, colour, outline_only)
///Draws one world-space rectangle on the minimap, converting it into the
///panel and clipping it to the panel's edges.
///
///This is the primitive the other mark scripts are built from -
///scr_MinimapMark takes a centre and a half-size, this takes the corners
///directly, which is what a checkerboard cell needs.
///
///Reads the transform scr_DrawMinimap set up for this frame
///(global.mm*), so it must only be called from inside that script.

var _wx1 = argument0;
var _wy1 = argument1;
var _wx2 = argument2;
var _wy2 = argument3;
var _colour = argument4;
var _outline = argument5;

var _x1 = global.mmCentreGuiX + (_wx1 - global.mmCentreWorldX) / global.mmScale;
var _y1 = global.mmCentreGuiY + (_wy1 - global.mmCentreWorldY) / global.mmScale;
var _x2 = global.mmCentreGuiX + (_wx2 - global.mmCentreWorldX) / global.mmScale;
var _y2 = global.mmCentreGuiY + (_wy2 - global.mmCentreWorldY) / global.mmScale;

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
