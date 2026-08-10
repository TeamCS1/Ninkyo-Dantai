///scr_LoadHomeFurniture()
//Ensures home.ini's shared "defaults" section exists, seeding it with
//the shipped furniture layout on a fresh install (e.g. an existing
//savedata.ini from before this system existed, with no home.ini yet).
//Per-slot custom positions are applied separately once rm_ShinjiHome is
//actually entered (see scr_ApplyHomeFurniturePositions), since the
//furniture instances it repositions don't exist until that room starts.
ini_open("home.ini");

if (!ini_key_exists("defaults", "count"))
{
    ini_write_real("defaults", "count", 3);
    ini_write_string("defaults", "item0", "obj_fridge,640,384,0,0");
    ini_write_string("defaults", "item1", "obj_cabinet,896,640,0,0");
    ini_write_string("defaults", "item2", "obj_bed,1376,368,0,180");
}

ini_close();
