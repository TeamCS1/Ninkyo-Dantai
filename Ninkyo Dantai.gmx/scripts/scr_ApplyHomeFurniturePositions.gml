///scr_ApplyHomeFurniturePositions()
//Applies the active save slot's saved layout in home.ini to
//rm_ShinjiHome: repositions an existing instance if one with matching
//furnitureId is already in the room (the 3 shipped defaults, or a piece
//added earlier this session), otherwise creates a new instance for it
//(a previously-added custom piece that doesn't exist yet this load). If
//the slot has no saved data yet, the room-editor-placed defaults are
//left untouched. Also advances global.nextFurnitureId past every id
//seen, so newly added pieces never collide with restored ones. Called
//from obj_home_customisation_controller's Room Start event.
ini_open("home.ini");

var _section = "custom" + string(global.currentSaveSlot);
var _count = ini_read_real(_section, "count", 0);

var _maxId = 2; //the 3 shipped defaults use ids 0-2

for (var i = 0; i < _count; i++)
{
    var _line = ini_read_string(_section, "item" + string(i), "");

    if (_line != "")
    {
        var _item = scr_ParseHomeFurnitureItem(_line);
        var _objIndex = asset_get_index(_item[| 0]);
        var _savedId = _item[| 1];
        var _savedX = _item[| 2];
        var _savedY = _item[| 3];
        var _savedZ = _item[| 4];
        var _savedRotation = _item[| 5];

        if (_savedId > _maxId)
        {
            _maxId = _savedId;
        }

        if (_objIndex != -1)
        {
            var _found = false;

            with (_objIndex)
            {
                if (furnitureId == _savedId)
                {
                    x = _savedX;
                    y = _savedY;
                    z = _savedZ;

                    if (variable_instance_exists(id, "zRotation"))
                    {
                        zRotation = _savedRotation;
                    }

                    _found = true;
                }
            }

            if (!_found)
            {
                var _newInst = instance_create(_savedX, _savedY, _objIndex);
                _newInst.furnitureId = _savedId;
                _newInst.z = _savedZ;

                if (variable_instance_exists(_newInst, "zRotation"))
                {
                    _newInst.zRotation = _savedRotation;
                }
            }
        }

        ds_list_destroy(_item);
    }
}

global.nextFurnitureId = _maxId + 1;

ini_close();
