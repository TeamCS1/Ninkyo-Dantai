///scr_DrawCurvedPanel(x1, y1, x2, y2, radius, border)
///Draws the curved text panel used by the fast-travel loading screen: a
///dark interior with the edge lifting to white, so the border around the
///text reads brighter than the middle. Call from a Draw GUI event.
///
///This replaces a 1920x1080 spr_curved_rectangle that was drawn over the
///whole screen. Drawing it in code means the panel can be sized to the
///text it is wrapping - each city description is a different length - and
///it costs no texture page.
///
///"border" is how far in from the edge the bright rim fades to the
///interior colour, in pixels. The fade is stepped rather than blended: a
///stack of progressively smaller opaque rounded rects, each a little
///darker than the last. That is deliberate - the underlying
///scr_DrawCurvedRect cannot draw semi-transparently without seams, so
///stacking opaque rings is what gives a smooth gradient here.

var _x1 = argument0;
var _y1 = argument1;
var _x2 = argument2;
var _y2 = argument3;
var _r = argument4;
var _border = argument5;

var _edgeColour = make_colour_rgb(255, 255, 255);
var _coreColour = make_colour_rgb(14, 14, 18);

// Enough rings that the banding isn't visible at this size, few enough
// that it stays cheap. Each ring is 7 primitives.
var _steps = 12;

var _i, _t, _inset;

draw_set_alpha(1);

for (_i = 0; _i <= _steps; _i += 1)
{
    _t = _i / _steps;
    _inset = _border * _t;

    draw_set_colour(merge_colour(_edgeColour, _coreColour, _t));

    scr_DrawCurvedRect(_x1 + _inset, _y1 + _inset,
                       _x2 - _inset, _y2 - _inset,
                       _r - _inset);
}

// Leave the draw state where the rest of the project expects to find it,
// rather than whatever the last ring happened to set.
draw_set_colour(c_white);
draw_set_alpha(1);
