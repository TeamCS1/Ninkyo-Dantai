///scr_DrawMinimapArrow(centre_x, centre_y, heading, tip_len, back_len, back_angle, colour)
///Draws one filled arrowhead on the minimap, pointing along heading.
///
///WHY THIS ISN'T JUST A draw_triangle CALL:
///
///This project runs with backface culling on - d3d_set_culling(1) is the
///standing state, which is why objects that need it off (obj_bed,
///obj_cabinet) turn it off and explicitly set it back to 1 afterwards.
///Culling throws away any triangle whose vertices are wound the wrong way
///round, completely and silently.
///
///GameMaker generates the geometry for draw_circle and draw_rectangle
///itself, with a winding that survives that. A hand-specified
///draw_triangle does not get that courtesy: ours was wound backwards and
///was being discarded, which is exactly why the circle marker drew, the
///arrow didn't, and changing its size changed nothing.
///
///So: culling off for the duration, restored to 1 after - the same
///pattern obj_bed already uses - and the triangle drawn in both windings
///so it survives even if the culling state isn't what we think. The
///second winding is cheap insurance and can go once this is confirmed
///working.

var _cx = argument0;
var _cy = argument1;
var _heading = argument2;
var _tipLen = argument3;
var _backLen = argument4;
var _backAngle = argument5;
var _colour = argument6;

var _tipX = _cx + lengthdir_x(_tipLen, _heading);
var _tipY = _cy + lengthdir_y(_tipLen, _heading);

var _leftX = _cx + lengthdir_x(_backLen, _heading + _backAngle);
var _leftY = _cy + lengthdir_y(_backLen, _heading + _backAngle);

var _rightX = _cx + lengthdir_x(_backLen, _heading - _backAngle);
var _rightY = _cy + lengthdir_y(_backLen, _heading - _backAngle);

d3d_set_culling(false);

draw_set_color(_colour);
draw_triangle(_tipX, _tipY, _leftX, _leftY, _rightX, _rightY, false);
draw_triangle(_tipX, _tipY, _rightX, _rightY, _leftX, _leftY, false);

d3d_set_culling(true);
