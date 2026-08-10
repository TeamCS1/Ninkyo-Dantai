///scr_DrawCurvedRect(x1, y1, x2, y2, radius)
///Fills one rounded rectangle in the CURRENT draw colour. Call from a
///Draw or Draw GUI event.
///
///Built from draw_rectangle and draw_circle rather than draw_roundrect
///for two reasons. First, those two are shapes this project already knows
///survive its standing d3d_set_culling(1) - GameMaker winds their
///geometry itself, where a hand-specified primitive gets silently
///discarded (see the draw_triangle note in CLAUDE.md, which cost several
///iterations on the minimap arrow). Second, draw_roundrect gives no
///control over the corner radius, and the _ext variants that do are not
///guaranteed across 1.4 builds.
///
///DRAWS OPAQUE ON PURPOSE. The shapes below overlap each other, so at an
///alpha below 1 the overlaps would blend twice and show as darker seams
///through the middle and corners. Avoiding that needs arcs rather than
///whole circles, which is exactly the hand-wound geometry the culling
///state eats. Everything using this draws over a solid backdrop anyway,
///so opacity costs nothing.
///
///Radius is clamped to half the shorter side, so a radius larger than the
///box gives a capsule rather than inside-out corners.

var _x1 = min(argument0, argument2);
var _y1 = min(argument1, argument3);
var _x2 = max(argument0, argument2);
var _y2 = max(argument1, argument3);
var _r = argument4;

var _maxR = min(_x2 - _x1, _y2 - _y1) * 0.5;

if _r > _maxR
{
    _r = _maxR;
}

// Degenerate box, or a radius too small to be worth the extra shapes
if (_x2 - _x1 < 1) || (_y2 - _y1 < 1)
{
    exit;
}

if _r < 1
{
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    exit;
}

// Middle band full height, then the two side bands inset vertically, then
// a circle filling each corner.
draw_rectangle(_x1 + _r, _y1, _x2 - _r, _y2, false);
draw_rectangle(_x1, _y1 + _r, _x1 + _r, _y2 - _r, false);
draw_rectangle(_x2 - _r, _y1 + _r, _x2, _y2 - _r, false);

draw_circle(_x1 + _r, _y1 + _r, _r, false);
draw_circle(_x2 - _r, _y1 + _r, _r, false);
draw_circle(_x1 + _r, _y2 - _r, _r, false);
draw_circle(_x2 - _r, _y2 - _r, _r, false);
