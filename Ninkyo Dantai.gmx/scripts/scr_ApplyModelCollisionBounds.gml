///scr_ApplyModelCollisionBounds(modelPath)
//Sizes the calling instance's collision mask (image_xscale/image_yscale)
//to the real local-space footprint of the given .d3d model (see
//scr_GetModelBounds), swapping width/depth when the instance's own
//zDirection is rotated 90/270 degrees so the mask matches what's
//actually drawn. Must be called after zDirection is set for this
//instance (i.e. after any room creation-code override), and the
//instance's sprite_index must already be its collision mask sprite.
var _path = argument0;

var _bounds = scr_GetModelBounds(_path);
var _localWidth = ds_list_find_value(_bounds, 0);
var _localDepth = ds_list_find_value(_bounds, 1);

var _worldWidth, _worldDepth;
if (zDirection mod 180 == 90)
{
    _worldWidth = _localDepth;
    _worldDepth = _localWidth;
}
else
{
    _worldWidth = _localWidth;
    _worldDepth = _localDepth;
}

image_xscale = _worldWidth / sprite_get_width(sprite_index);
image_yscale = _worldDepth / sprite_get_height(sprite_index);
