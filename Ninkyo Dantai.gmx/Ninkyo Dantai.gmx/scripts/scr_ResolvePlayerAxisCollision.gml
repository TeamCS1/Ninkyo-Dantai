///scr_ResolvePlayerAxisCollision(other)
//Reverts the player's X and Y movement independently against the given
//solid instance, so contact on one axis doesn't cancel motion on the
//other (lets the player slide along edges/corners instead of stopping
//dead on diagonal contact).
var _other = argument0;

var _blockedX = place_meeting(x, yprevious, _other);
var _blockedY = place_meeting(xprevious, y, _other);

if (_blockedX) x = xprevious;
if (_blockedY) y = yprevious;

if (!_blockedX && !_blockedY)
{
    x = xprevious;
    y = yprevious;
}
