///scr_ParseHomeFurnitureItem(line)
//Parses one "objectName,x,y,z,zRotation" line (as written by
//scr_SaveHomeFurniture) into a 5-element ds_list:
//[0]=object name (string), [1]=x, [2]=y, [3]=z, [4]=zRotation.
//Caller owns the returned list and must destroy it.
var _line = argument0;

var _result = ds_list_create();

var _sp = string_pos(",", _line);
ds_list_add(_result, string_copy(_line, 1, _sp - 1));
_line = string_delete(_line, 1, _sp);

_sp = string_pos(",", _line);
ds_list_add(_result, real(string_copy(_line, 1, _sp - 1)));
_line = string_delete(_line, 1, _sp);

_sp = string_pos(",", _line);
ds_list_add(_result, real(string_copy(_line, 1, _sp - 1)));
_line = string_delete(_line, 1, _sp);

_sp = string_pos(",", _line);
ds_list_add(_result, real(string_copy(_line, 1, _sp - 1)));
_line = string_delete(_line, 1, _sp);

ds_list_add(_result, real(_line));

return _result;
