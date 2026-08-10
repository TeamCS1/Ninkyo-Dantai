///scr_VehicleExit(icon_object)
///Shared "get out of the vehicle" handling for every drivable vehicle:
///hands control back to the player, resets the camera, drops the
///vehicle's pickup icon next to them and destroys the vehicle instance.
///
///icon_object is the only thing that differs per vehicle - the icon the
///player walks back into to get in again (obj_car_icon, obj_truck_icon,
///and so on).
///
///Call from the vehicle's exit key event. Destroys the calling instance,
///so nothing after the call in that event will run.

var _iconObject = argument0;

global.inVehicle = false;

// Put the draw distance back to its resting value. Doing it here rather
// than relying on the vehicle's own Draw GUI is what actually makes it
// happen - by the time the player is out, the vehicle instance is gone
// and its events never run again.
global.drawOCRange = global.drawOCRangeBase;

// Camera defaults
obj_control.ztobe = 500;
obj_control.z = 700;

with obj_player_buruwasu
{
    sprite_index = spr_player;
    instance_create(x + 100, y + 100, _iconObject);
}

instance_destroy();
