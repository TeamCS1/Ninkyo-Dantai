///scr_GetModelBounds(modelPath)
//Parses a .d3d model file (GameMaker's own plain-text d3d_model_save
//format) to find its true local-space bounding box, and caches the
//result per unique path so repeat calls for the same model are free.
//Returns a 3-element ds_list: [0]=width (local X extent), [1]=depth
//(local Y extent), [2]=height (local Z extent). The returned list is a
//shared, persistent cache entry - callers must not destroy it.
var _path = argument0;

if (!ds_exists(global.modelBoundsCache, ds_type_map))
{
    global.modelBoundsCache = ds_map_create();
}

if (ds_map_exists(global.modelBoundsCache, _path))
{
    return ds_map_find_value(global.modelBoundsCache, _path);
}

var _minX, _minY, _minZ, _maxX, _maxY, _maxZ;
_minX = 100000000;
_minY = 100000000;
_minZ = 100000000;
_maxX = -100000000;
_maxY = -100000000;
_maxZ = -100000000;

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

    //skip degenerate/terminator rows - GameMaker writes an all-zero
    //sentinel line at the end of each primitive block, and a real mesh
    //vertex is never simultaneously at x=y=z=0
    if (_x == 0 && _y == 0 && _z == 0)
    {
        continue;
    }

    if (_x < _minX) _minX = _x;
    if (_x > _maxX) _maxX = _x;
    if (_y < _minY) _minY = _y;
    if (_y > _maxY) _maxY = _y;
    if (_z < _minZ) _minZ = _z;
    if (_z > _maxZ) _maxZ = _z;
}

file_text_close(_file);

var _bounds = ds_list_create();
ds_list_add(_bounds, _maxX - _minX);
ds_list_add(_bounds, _maxY - _minY);
ds_list_add(_bounds, _maxZ - _minZ);

ds_map_add(global.modelBoundsCache, _path, _bounds);

return _bounds;
