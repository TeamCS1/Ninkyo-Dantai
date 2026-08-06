///scr_GetGamepadConfirm()
///Whether the confirm button - Cross on a DualSense, A on an Xbox pad -
///is currently held.
///
///This is a LEVEL, not an edge: it stays true for as long as the button
///is down. Read global.gamepadNavConfirm (set by scr_GamepadNavPoll) if
///you want one action per press instead.
///
///Two sources are checked, for the same reason scr_GetGamepadDpadY checks
///two - GMS 1.4's controller mapping can't be relied on for this pad:
///
///  1. gp_face1, the mapped constant. Correct on any pad the runtime's
///     mapping actually knows about.
///  2. Raw button index 1, which is Cross on a DualSense - read straight
///     off the debug overlay's raw button readout while holding it.
///
///CAVEAT on source 2: raw index 1 is Cross under the DirectInput
///PlayStation layout, but B under the XInput Xbox layout - so on an Xbox
///pad this currently makes B confirm as well as A. It's a deliberate
///trade while we don't yet know whether gp_face1 fires on a DualSense.
///The overlay's "Mapped buttons held" line answers that; if gp_face1 does
///fire, delete source 2 and this caveat with it.

var _device = scr_GetGamepadDevice();

if _device == -1
{
    return false;
}

if gamepad_button_check(_device, gp_face1)
{
    return true;
}

if gamepad_button_check(_device, 1)
{
    return true;
}

return false;
