///scr_DrawGamepadDebugOverlay()
///Draws the gamepad diagnostics readout in the top-left corner, or
///nothing at all while global.debugGamepadOverlay is off (toggled by
///"Debug Gamepad" on the main menu options screen).
///
///Call from a Draw GUI event. Useful whenever a controller isn't
///behaving: it shows what GameMaker actually detects, rather than what it
///should detect - which slot the pad is in, its reported name, every raw
///button and axis, and the legacy joystick's POV hat.

if global.debugGamepadOverlay == false
{
    exit;
}

var _device = scr_GetGamepadDevice();
var _joystick = scr_GetLegacyJoystick();

draw_set_font(ft_buruwasu_gui);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_yellow);

var _count = gamepad_get_device_count();
draw_text(20, 20, "Gamepad slots: " + string(_count));

var _drawY = 44;
var _i = 0;

while (_i < _count)
{
    var _line = "Slot " + string(_i) + ": ";

    if gamepad_is_connected(_i)
    {
        _line += "CONNECTED - " + gamepad_get_description(_i);
    }
    else
    {
        _line += "not connected";
    }

    draw_text(20, _drawY, _line);
    _drawY += 24;
    _i++;
}

if _device == -1
{
    draw_text(20, _drawY, "No gamepad recognised by GameMaker.");
    _drawY += 24;
}
else
{
    draw_text(20, _drawY, "Active device " + string(_device) + " | left stick Y axis: " + string(gamepad_axis_value(_device, gp_axislv)));
    _drawY += 24;

    var _buttonCount = gamepad_button_count(_device);
    var _bits = "";
    var _b = 0;

    while (_b < _buttonCount)
    {
        if gamepad_button_check(_device, _b)
        {
            _bits += "1";
        }
        else
        {
            _bits += "0";
        }

        _b++;
    }

    draw_text(20, _drawY, "Raw buttons (" + string(_buttonCount) + "): " + _bits);
    _drawY += 24;

    var _axisCount = gamepad_axis_count(_device);
    var _axes = "";
    var _a = 0;

    while (_a < _axisCount)
    {
        _axes += string(_a) + "=" + string(gamepad_axis_value(_device, _a)) + " ";
        _a++;
    }

    draw_text(20, _drawY, "Raw axes: " + _axes);
    _drawY += 24;

    //Face buttons, named for the layout actually detected. gp_faceN is
    //just raw index N-1 passed through - the runtime does NOT translate
    //per layout - so the gp_ name is shown alongside as a reminder that
    //it describes a position, not a physical button.
    var _face0 = "A";
    var _face1 = "B";
    var _face2 = "X";
    var _face3 = "Y";

    if scr_GamepadUsesPlaystationLayout()
    {
        _face0 = "Square";
        _face1 = "Cross";
        _face2 = "Circle";
        _face3 = "Triangle";
    }

    var _held = "";

    if gamepad_button_check(_device, 0)
    {
        _held += _face0 + " (raw 0 = gp_face1) ";
    }

    if gamepad_button_check(_device, 1)
    {
        _held += _face1 + " (raw 1 = gp_face2) ";
    }

    if gamepad_button_check(_device, 2)
    {
        _held += _face2 + " (raw 2 = gp_face3) ";
    }

    if gamepad_button_check(_device, 3)
    {
        _held += _face3 + " (raw 3 = gp_face4) ";
    }

    if _held == ""
    {
        _held = "(none held)";
    }

    draw_text(20, _drawY, "Face buttons held: " + _held);
    _drawY += 24;

    //Shown separately because this is the mapping that's actually broken
    //for a DualSense - it stays empty even while the D-pad is held, which
    //is the whole reason scr_GetGamepadDpadY falls back to the POV hat.
    var _mappedDpad = "";

    if gamepad_button_check(_device, gp_padu)
    {
        _mappedDpad += "padu ";
    }

    if gamepad_button_check(_device, gp_padd)
    {
        _mappedDpad += "padd ";
    }

    if _mappedDpad == ""
    {
        _mappedDpad = "(none held)";
    }

    draw_text(20, _drawY, "Mapped D-pad held: " + _mappedDpad);
    _drawY += 24;

    //Which face-button layout the confirm button is being read for. If
    //this is wrong for your pad, see scr_GamepadUsesPlaystationLayout.
    var _layout = "Xbox/XInput (confirm = gp_face1)";

    if scr_GamepadUsesPlaystationLayout()
    {
        _layout = "PlayStation (confirm = raw index 1 / Cross)";
    }

    draw_text(20, _drawY, "Detected layout: " + _layout);
    _drawY += 24;

    var _confirmState = "up";

    if scr_GetGamepadConfirm()
    {
        _confirmState = "HELD";
    }

    draw_text(20, _drawY, "Confirm button: " + _confirmState);
    _drawY += 24;
}

if _joystick == -1
{
    draw_text(20, _drawY, "Legacy joystick API: none found");
}
else
{
    var _pov = "no POV";

    if joystick_has_pov(_joystick)
    {
        _pov = string(joystick_pov(_joystick));
    }

    draw_text(20, _drawY, "Legacy joystick " + string(_joystick) + " | POV: " + _pov);
}

draw_set_color(c_white);
