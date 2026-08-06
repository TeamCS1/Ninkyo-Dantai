///scr_GetGamepadDpadY()
///Current D-pad vertical direction as a LEVEL, not an edge:
///  -1 = up, 0 = centred, 1 = down
///Held directions keep returning the same value every frame. Use
///scr_GamepadNavPoll if you want one step per press instead.
///
///Two independent sources are checked, because neither covers every pad:
///
///  1. The mapped gamepad API (gp_padu / gp_padd). Works for most
///     Xbox-layout controllers.
///  2. The legacy DirectInput POV hat. GMS 1.4's bundled controller
///     mapping predates the DualSense, which reports its D-pad as a POV
///     hat rather than four discrete buttons - so gp_padu / gp_padd never
///     fire for it (confirmed on a DualSense over Bluetooth, where the
///     analog stick mapped correctly but the D-pad did not). Reading the
///     hat directly bypasses the mapping entirely.
///
///Either source reporting a direction is enough.

var _device = scr_GetGamepadDevice();

if _device != -1
{
    if gamepad_button_check(_device, gp_padu)
    {
        return -1;
    }

    if gamepad_button_check(_device, gp_padd)
    {
        return 1;
    }
}

var _joystick = scr_GetLegacyJoystick();

if _joystick != -1
{
    if joystick_has_pov(_joystick)
    {
        var _pov = joystick_pov(_joystick);

        //-1 means the hat is centred. Otherwise it's an angle in degrees,
        //clockwise from up, so "up" straddles 0.
        if _pov != -1
        {
            if (_pov >= 315) or (_pov <= 45)
            {
                return -1;
            }

            if (_pov >= 135) and (_pov <= 225)
            {
                return 1;
            }
        }
    }
}

return 0;
