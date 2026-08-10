///scr_DrawMinimapFrame()
///Draws the minimap's border, on TOP of the map contents so the edge
///stays crisp and the blips clipped to the panel don't eat into it.
///
///Three layers, which is what makes it read as designed rather than as a
///rectangle someone forgot to style:
///  - a dark frame, separating the panel from the world behind it
///  - a thin teal inner line, picking up the same accent the main menu
///    and scr_glow_text already use, so the HUD looks like one kit
///  - brighter corner brackets, which is the bit that actually reads as
///    deliberate at a glance
///
///Tweak the constants below to restyle it; nothing else depends on them.

var _x1 = global.mmBoxX1;
var _y1 = global.mmBoxY1;
var _x2 = global.mmBoxX2;
var _y2 = global.mmBoxY2;

// The light blue the main menu uses for its glow - reusing it deliberately
var _accent = make_colour_rgb(107, 200, 218);
var _frameDark = make_colour_rgb(10, 12, 14);

var _frameWidth = 3;
var _bracketLength = 22;
var _bracketWidth = 3;

// ---- Dark frame, drawn as four bars so the panel interior stays clear
draw_set_alpha(1);
draw_set_color(_frameDark);

draw_rectangle(_x1 - _frameWidth, _y1 - _frameWidth, _x2 + _frameWidth, _y1, false);
draw_rectangle(_x1 - _frameWidth, _y2, _x2 + _frameWidth, _y2 + _frameWidth, false);
draw_rectangle(_x1 - _frameWidth, _y1, _x1, _y2, false);
draw_rectangle(_x2, _y1, _x2 + _frameWidth, _y2, false);

// ---- Thin accent line just inside the frame
draw_set_alpha(0.45);
draw_set_color(_accent);
draw_rectangle(_x1, _y1, _x2, _y2, true);

// ---- Corner brackets
draw_set_alpha(1);

// top left
draw_line_width(_x1, _y1, _x1 + _bracketLength, _y1, _bracketWidth);
draw_line_width(_x1, _y1, _x1, _y1 + _bracketLength, _bracketWidth);

// top right
draw_line_width(_x2 - _bracketLength, _y1, _x2, _y1, _bracketWidth);
draw_line_width(_x2, _y1, _x2, _y1 + _bracketLength, _bracketWidth);

// bottom left
draw_line_width(_x1, _y2 - _bracketLength, _x1, _y2, _bracketWidth);
draw_line_width(_x1, _y2, _x1 + _bracketLength, _y2, _bracketWidth);

// bottom right
draw_line_width(_x2 - _bracketLength, _y2, _x2, _y2, _bracketWidth);
draw_line_width(_x2, _y2 - _bracketLength, _x2, _y2, _bracketWidth);

draw_set_color(c_white);
draw_set_alpha(1);
