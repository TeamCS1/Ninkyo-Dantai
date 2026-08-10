///scr_GamepadNavPoll()
///Polls the gamepad for menu navigation and publishes the result as three
///globals:
///  global.gamepadNavUp
///  global.gamepadNavDown
///  global.gamepadNavConfirm
///Each is true only on the frame it's first engaged, so holding a
///direction moves the selection one item rather than scrolling
///continuously, and holding confirm selects once rather than repeatedly.
///
///CALL THIS ONCE PER FRAME, FROM A BEGIN STEP EVENT.
///Every instance's Begin Step runs before any instance's Step, so any
///number of objects can then read these globals in their own Step event
///without depending on instance order. Calling it more than once in a
///frame would swallow the press, since the second call sees the input as
///already engaged.
///
///A room that READS these globals must also POLL them. Nothing clears
///them on a room change, so a room that only reads would see whatever the
///previous room left behind - including a stale "true".
///
///D-pad and stick are folded into a single direction before the edge
///check. That way a pad whose D-pad is picked up by both detection paths
///inside scr_GetGamepadDpadY - or a player nudging the stick while
///pressing the D-pad - still only moves the selection one item.

var _direction = scr_GetGamepadDpadY();

if _direction == 0
{
    _direction = scr_GetGamepadStickY();
}

global.gamepadNavUp = false;
global.gamepadNavDown = false;

if _direction != global.gamepadNavDirectionPrevious
{
    if _direction == -1
    {
        global.gamepadNavUp = true;
    }

    if _direction == 1
    {
        global.gamepadNavDown = true;
    }
}

global.gamepadNavDirectionPrevious = _direction;

var _confirm = scr_GetGamepadConfirm();

global.gamepadNavConfirm = false;

if _confirm
{
    if global.gamepadConfirmPrevious == false
    {
        global.gamepadNavConfirm = true;
    }
}

global.gamepadConfirmPrevious = _confirm;
