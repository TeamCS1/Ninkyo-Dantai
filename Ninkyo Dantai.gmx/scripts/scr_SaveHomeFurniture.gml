///scr_SaveHomeFurniture()
//Persists the home-customisation furniture layout to home.ini: the
//shipped default positions (always, under "defaults", shared by every
//save slot), and the player's current in-room layout for the active
//save slot under "custom" + global.currentSaveSlot - but only while
//actually standing in rm_ShinjiHome, so saving anywhere else never
//clobbers a previously-saved layout with nothing. Loops over every
//existing instance of each movable type (not just one per type), since
//the player can now add more than one of the same piece.
ini_open("home.ini");

ini_write_real("defaults", "count", 3);
ini_write_string("defaults", "item0", "obj_fridge,0,640,384,0,0");
ini_write_string("defaults", "item1", "obj_cabinet,1,896,640,0,0");
ini_write_string("defaults", "item2", "obj_bed,2,1376,368,0,180");

if (room == rm_ShinjiHome)
{
    var _section = "custom" + string(global.currentSaveSlot);
    var _itemIndex = 0;

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

            ini_write_string(_section, "item" + string(_itemIndex),
                _objName + "," + string(furnitureId) + "," + string(x) + "," +
                string(y) + "," + string(z) + "," + string(_zRotation));

            _itemIndex += 1;
        }
    }

    ini_write_real(_section, "count", _itemIndex);
}

ini_close();
