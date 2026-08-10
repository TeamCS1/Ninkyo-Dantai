///scr_GetGamepadStickY()
///Current left stick vertical direction as a LEVEL, not an edge, with a
///deadzone applied:
///  -1 = pushed up, 0 = inside the deadzone, 1 = pushed down
///
///Held directions keep returning the same value every frame. Use
///scr_GamepadNavPoll if you want one step per push instead.

var _device = scr_GetGamepadDevice();

if _device == -1
{
    return 0;
}

var _value = gamepad_axis_value(_device, gp_axislv);

//Generous deadzone - a resting stick reads a little either side of 0
if _value < -0.5
{
    return -1;
}

if _value > 0.5
{
    return 1;
}

return 0;
