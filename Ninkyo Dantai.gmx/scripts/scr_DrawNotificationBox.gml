///scr_DrawNotificationBox(message, box_width, alpha)
///Draws one of the fading black message boxes in the top-left of the
///screen - the notification system and the tutorial prompts both use it.
///Call from a Draw GUI event.
///
///This exists because the layout was copy-pasted between
///obj_notification_system_out and obj_TutorialBoxRotateCamera. When the
///notification box was moved clear of the minimap, the tutorial box was
///not, and carried on drawing underneath it. One copy means that can't
///happen again.
///
///Three things it handles that the original inline version got wrong:
///
///  - It sits clear of the minimap rather than on top of it, worked out
///    from the panel's own padding and size so resizing or moving the
///    minimap doesn't put it back underneath. Falls back to the original
///    position in any room with no minimap globals.
///  - The text wraps to the box INTERIOR. It used to be drawn 30px inside
///    the box but wrap at the full box width, so a long message ran past
///    the right edge of its own background.
///  - The box height comes from the text. It used to be a fixed 80px, so
///    anything wrapping past three lines spilled out of the bottom.

var _message = argument0;
var _boxWidth = argument1;
var _alpha = argument2;

// Font first - string_height_ext measures with whatever font is currently
// set, so measuring before this would size the box wrong
draw_set_font(ft_map_editor_buruwasu);

var _left = 30;

if variable_global_exists("minimapEnabled")
{
    if global.minimapEnabled == true
    {
        _left = global.minimapPad + global.minimapSize + 30;
    }
}

var _top = 20;
var _pad = 12;
var _lineHeight = 20;
var _wrap = _boxWidth - (_pad * 2);
var _height = string_height_ext(string(_message), _lineHeight, _wrap);

draw_set_alpha(_alpha);
draw_rectangle_colour(_left, _top,
                      _left + _boxWidth, _top + _height + (_pad * 2),
                      c_black, c_black, c_black, c_black, false);

draw_set_color(c_white);
draw_text_ext(_left + _pad, _top + _pad, string(_message), _lineHeight, _wrap);

draw_set_alpha(1.0);
draw_set_color(c_white);
