///scr_GetGamepadDevice()
///Returns the slot index of the first connected gamepad, or -1 if there
///isn't one.
///
///Every slot is scanned rather than assuming device 0: a DualSense paired
///over Bluetooth reports in slot 4 on this runtime, not slot 0, and other
///pads land in other slots depending on connection order.

var _count = gamepad_get_device_count();
var _i = 0;

while (_i < _count)
{
    if gamepad_is_connected(_i)
    {
        return _i;
    }

    _i++;
}

return -1;
