///scr_SnapshotHomeFurniture()
//Captures the current position/rotation of every placeable furniture
//instance into global.homeFurnitureSnapshot (a ds_list of
//"objectName,furnitureId,x,y,z,zRotation" strings, one per instance).
//This exists because by the time the player actually presses Save, they
//are standing inside rm_options_menu - a real room_goto away from
//rm_ShinjiHome - and the furniture instances (non-persistent) no longer
//exist at that point for scr_SaveHomeFurniture to read directly. Called
//from obj_home_customisation_controller's Room End event, which fires
//while still in rm_ShinjiHome, right before the room actually changes.
if (ds_exists(global.homeFurnitureSnapshot, ds_type_list))
{
    ds_list_destroy(global.homeFurnitureSnapshot);
}

global.homeFurnitureSnapshot = ds_list_create();

for (var i = 0; i < ds_list_size(global.movableTypes); i++)
{
    var _type = global.movableTypes[| i];
    var _objName = object_get_name(_type);

    with (_type)
    {
        var _zRotation = 0;
        if (variable_instance_exists(id, "zRotation"))
        {
            _zRotation = zRotation;
        }

        ds_list_add(global.homeFurnitureSnapshot,
            _objName + "," + string(furnitureId) + "," + string(x) + "," +
            string(y) + "," + string(z) + "," + string(_zRotation));
    }
}
