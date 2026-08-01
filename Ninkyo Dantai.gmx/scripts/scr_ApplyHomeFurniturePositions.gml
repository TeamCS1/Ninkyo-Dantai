///scr_ApplyHomeFurniturePositions()
//Repositions rm_ShinjiHome's default furniture instances to match the
//active save slot's saved layout in home.ini, if any exists yet for
//that slot - otherwise leaves the room-editor-placed defaults untouched
//(a fresh/never-saved slot). Called from
//obj_home_customisation_controller's Room Start event.
ini_open("home.ini");

var _section = "custom" + string(global.currentSaveSlot);
var _count = ini_read_real(_section, "count", 0);

for (var i = 0; i < _count; i++)
{
    var _line = ini_read_string(_section, "item" + string(i), "");

    if (_line != "")
    {
        var _item = scr_ParseHomeFurnitureItem(_line);
        var _objIndex = asset_get_index(_item[| 0]);

        if (_objIndex != -1)
        {
            with (_objIndex)
            {
                x = _item[| 1];
                y = _item[| 2];
                z = _item[| 3];

                if (variable_instance_exists(id, "zRotation"))
                {
                    zRotation = _item[| 4];
                }
            }
        }

        ds_list_destroy(_item);
    }
}

ini_close();
