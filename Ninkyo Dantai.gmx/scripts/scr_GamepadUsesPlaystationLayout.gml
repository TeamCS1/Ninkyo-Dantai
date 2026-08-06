///scr_GamepadUsesPlaystationLayout()
///Whether the connected pad reports its face buttons in the DirectInput
///PlayStation order:
///    raw 0 = Square, 1 = Cross, 2 = Circle, 3 = Triangle
///rather than the XInput order that GMS 1.4's gp_face* constants assume:
///    raw 0 = A,      1 = B,     2 = X,      3 = Y
///
///This matters because gp_face1 is not really "the bottom face button" on
///this runtime - it is just raw index 0 passed straight through. Verified
///on a DualSense with the debug overlay: holding Cross lights raw index 1
///AND reports gp_face2, i.e. no per-layout translation happens at all. So
///gp_face1 is A on an Xbox pad but Square on a DualSense, and the correct
///index for "confirm" depends on the physical pad.
///
///There is no API that reports the layout, so this matches on the device
///name. When a pad is wrong, read its exact name off the debug overlay's
///slot line and add it here.
///
///The proper long-term fix is a rebindable confirm button in the options
///menu, which would make this guess unnecessary.

var _device = scr_GetGamepadDevice();

if _device == -1
{
    return false;
}

var _name = string_lower(gamepad_get_description(_device));

if string_pos("dualsense", _name) > 0
{
    return true;
}

if string_pos("dualshock", _name) > 0
{
    return true;
}

if string_pos("playstation", _name) > 0
{
    return true;
}

//A DualShock 4 commonly reports exactly this and nothing more. Slightly
//broad, so it's checked last - a third-party Xbox-layout pad using the
//same generic name would be misread as PlayStation.
if string_pos("wireless controller", _name) > 0
{
    return true;
}

return false;
