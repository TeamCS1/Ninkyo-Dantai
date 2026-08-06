///scr_GetGamepadConfirm()
///Whether the confirm button - Cross on a DualSense, A on an Xbox pad -
///is currently held.
///
///This is a LEVEL, not an edge: it stays true for as long as the button
///is down. Read global.gamepadNavConfirm (set by scr_GamepadNavPoll) if
///you want one action per press instead.
///
///Which raw index that button lives at depends on the pad's layout, so
///the two cases are picked between rather than OR'd together. OR-ing them
///makes two different buttons both confirm: on a DualSense, Cross (raw 1)
///AND Square (raw 0, which is what gp_face1 actually reads).
///See scr_GamepadUsesPlaystationLayout for why gp_face1 is not
///layout-aware on this runtime.

var _device = scr_GetGamepadDevice();

if _device == -1
{
    return false;
}

if scr_GamepadUsesPlaystationLayout()
{
    //Raw index 1 = Cross, confirmed on a DualSense via the debug overlay
    return gamepad_button_check(_device, 1);
}

//gp_face1 = A on an XInput pad, which is the correct confirm there
return gamepad_button_check(_device, gp_face1);
