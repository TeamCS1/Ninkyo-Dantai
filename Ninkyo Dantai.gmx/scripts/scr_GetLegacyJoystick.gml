///scr_GetLegacyJoystick()
///Returns the id (1-4) of the first legacy DirectInput joystick, or -1 if
///there isn't one.
///
///This is the older, lower-level input API that predates GameMaker's
///mapped gamepad functions. It's needed because that mapping doesn't
///recognise every pad's D-pad - see scr_GetGamepadDpadY for the detail.

var _i = 1;

while (_i <= 4)
{
    if joystick_exists(_i)
    {
        return _i;
    }

    _i++;
}

return -1;
