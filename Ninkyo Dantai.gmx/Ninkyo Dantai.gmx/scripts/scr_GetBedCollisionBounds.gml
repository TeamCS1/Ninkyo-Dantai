///scr_GetBedCollisionBounds()
//Parses the bed's .d3d model to find a symmetric-safe collision size,
//caching the result (parsed once, reused after). Unlike
//scr_GetModelBounds (shared by the fence/cabinet/fridge), this doesn't
//just return the raw width/depth extent - it returns 2*max(|min|,|max|)
//per axis, i.e. the smallest box centered on the origin that still
//fully contains the model on both sides.
//
//This exists because the bed's real model is NOT centered on its own
//local origin the way the other props' are: its raw Y-extent is
//-53.7 to +26.3 (offset ~-13.7, not roughly 0). A plain symmetric box
//sized to the model's true extent (scr_GetModelBounds's approach) left
//an ~41-unit gap you could walk through on one side once the bed's
//180-degree placement rotation flipped that offset outward. This
//trades a bit of harmless over-blocking on the opposite side for
//guaranteeing no walkthrough at any 90-degree rotation the bed might be
//placed or added at (the "add furniture" flow can spawn a second bed at
//a different rotation than the shipped default).
//
//Returns a 2-element ds_list: [0]=safe width (local X), [1]=safe depth
//(local Y). Cached separately from scr_GetModelBounds since it measures
//a different thing for the same file.
if (!ds_exists(global.bedCollisionBoundsCache, ds_type_list))
{
    var _path = working_directory + "Assets\Buruwasu\HOME_CELL\bed.d3d";

    var _minX, _minY, _maxX, _maxY;
    _minX = 100000000;
    _minY = 100000000;
    _maxX = -100000000;
    _maxY = -100000000;

    var _file = file_text_open_read(_path);

    //skip the 3-line header (format version, vertex count, primitive flags)
    file_text_readln(_file);
    file_text_readln(_file);
    file_text_readln(_file);

    while (!file_text_eof(_file))
    {
        var _line = file_text_read_string(_file);
        file_text_readln(_file);

        var _sp = string_pos(" ", _line);
        if (_sp == 0)
        {
            continue;
        }
        var _rest = string_delete(_line, 1, _sp);

        _sp = string_pos(" ", _rest);
        if (_sp == 0)
        {
            continue;
        }
        var _x = real(string_copy(_rest, 1, _sp - 1));
        _rest = string_delete(_rest, 1, _sp);

        _sp = string_pos(" ", _rest);
        if (_sp == 0)
        {
            continue;
        }
        var _y = real(string_copy(_rest, 1, _sp - 1));
        _rest = string_delete(_rest, 1, _sp);

        _sp = string_pos(" ", _rest);
        if (_sp == 0)
        {
            continue;
        }
        var _z = real(string_copy(_rest, 1, _sp - 1));

        //skip degenerate/terminator rows - see scr_GetModelBounds
        if (_x == 0 && _y == 0 && _z == 0)
        {
            continue;
        }

        if (_x < _minX) _minX = _x;
        if (_x > _maxX) _maxX = _x;
        if (_y < _minY) _minY = _y;
        if (_y > _maxY) _maxY = _y;
    }

    file_text_close(_file);

    global.bedCollisionBoundsCache = ds_list_create();
    ds_list_add(global.bedCollisionBoundsCache, max(abs(_minX), abs(_maxX)) * 2);
    ds_list_add(global.bedCollisionBoundsCache, max(abs(_minY), abs(_maxY)) * 2);
}

return global.bedCollisionBoundsCache;
