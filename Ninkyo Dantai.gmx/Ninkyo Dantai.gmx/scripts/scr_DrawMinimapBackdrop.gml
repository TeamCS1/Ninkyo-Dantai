///scr_DrawMinimapBackdrop()
///Draws what sits UNDER the minimap contents: a soft drop shadow to lift
///the panel off the world behind it, then the semi-opaque fill.
///
///Split from scr_DrawMinimapFrame because the two halves have to bracket
///the map contents - fill underneath, frame on top - or the blips draw
///over the border and chew its inside edge.
///
///Reads the panel bounds scr_DrawMinimap set up for this frame.

var _x1 = global.mmBoxX1;
var _y1 = global.mmBoxY1;
var _x2 = global.mmBoxX2;
var _y2 = global.mmBoxY2;

// Soft shadow: a few rectangles stepping outward at falling alpha. Cheap
// approximation of a blur, and it's what stops the panel looking like it
// was pasted on - against a bright pavement the hard edge is obvious.
draw_set_color(c_black);

var _glow = 6;
var _i = _glow;

while (_i > 0)
{
    draw_set_alpha(0.05 + (0.14 * (1 - _i / _glow)));
    draw_rectangle(_x1 - _i, _y1 - _i, _x2 + _i, _y2 + _i, false);
    _i--;
}

// Panel fill
draw_set_alpha(0.9);
draw_set_color(make_colour_rgb(8, 12, 16));
draw_rectangle(_x1, _y1, _x2, _y2, false);

draw_set_alpha(1);
