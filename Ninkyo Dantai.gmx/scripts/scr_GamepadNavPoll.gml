///scr_GamepadNavPoll()
///Polls the gamepad for menu navigation and publishes the result as two
///globals:
///  global.gamepadNavUp
///  global.gamepadNavDown
///Each is true only on the frame its direction is first engaged, so
///holding a direction moves the selection one item rather than scrolling
///continuously.
///
///CALL THIS ONCE PER FRAME, FROM A BEGIN STEP EVENT.
///Every instance's Begin Step runs before any instance's Step, so any
///number of objects can then read the two globals in their own Step event
///without depending on instance order. Calling it more than once in a
///frame would swallow the press, since the second call sees the direction
///as already engaged.
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
