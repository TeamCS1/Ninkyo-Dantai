///scr_SaveHomeFurniture()
//Persists the home-customisation furniture layout to home.ini: the
//shipped default positions (always, under "defaults", shared by every
//save slot), and the player's layout for the active save slot under
//"custom" + global.currentSaveSlot. Writes from
//global.homeFurnitureSnapshot (captured by scr_SnapshotHomeFurniture
//when rm_ShinjiHome was last left) rather than scanning live instances -
//by the time Save is actually pressed, the player is standing in
//rm_options_menu and the furniture instances no longer exist. Only
//writes the custom section if the player's last-visited room was
//rm_ShinjiHome and a snapshot actually exists, so saving from somewhere
//the player has never taken the furniture through never overwrites a
//previously-saved layout with nothing.
ini_open("home.ini");

ini_write_real("defaults", "count", 3);
ini_write_string("defaults", "item0", "obj_fridge,0,640,384,0,0");
ini_write_string("defaults", "item1", "obj_cabinet,1,896,640,0,0");
ini_write_string("defaults", "item2", "obj_bed,2,1376,368,0,180");

if (global.previousLocation == rm_ShinjiHome && ds_exists(global.homeFurnitureSnapshot, ds_type_list))
{
    var _section = "custom" + string(global.currentSaveSlot);
    var _count = ds_list_size(global.homeFurnitureSnapshot);

    for (var i = 0; i < _count; i++)
    {
        ini_write_string(_section, "item" + string(i), global.homeFurnitureSnapshot[| i]);
    }

    ini_write_real(_section, "count", _count);
}

ini_close();
