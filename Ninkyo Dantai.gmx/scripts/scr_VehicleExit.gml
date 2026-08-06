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

// Camera defaults
obj_control.ztobe = 500;
obj_control.z = 700;

with obj_player_buruwasu
{
    sprite_index = spr_player;
    instance_create(x + 100, y + 100, _iconObject);
}

instance_destroy();
