///DrawArrowWaypoint(x, y, targetX, targetY, maxDistance);
//
// Script draws arrow from (x,y) to (targetX, targetY) with a maximum length
//
//-----------

var _x, _y, _mx, _my, _maxLength, _dir, _dist;

_x = argument[0];
_y = argument[1];
_mx = argument[2];
_my = argument[3];
_maxLength = argument[4];

_dir = point_direction(_x,_y,_mx,_my);
_dist = min(point_distance(_x,_y,_mx,_my), _maxDistance);

draw_arrow(_x,_y,_x+(dcos(_dir)*_dist),_y-(dsin(_dir)*_dist), 8); //8 is simply a placeholder thickness and can be changed
