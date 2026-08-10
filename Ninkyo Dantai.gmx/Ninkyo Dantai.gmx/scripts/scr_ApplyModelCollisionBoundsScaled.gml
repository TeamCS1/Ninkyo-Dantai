///scr_ApplyModelCollisionBoundsScaled(modelPath, scaleX, scaleY, rotationDegrees)
//Sizes the calling instance's collision mask (image_xscale/image_yscale)
//to the real local-space footprint of the given .d3d model (see
//scr_GetModelBounds), after applying the same scaleX/scaleY the
//instance's own Draw event passes to d3d_transform_set_scaling /
//d3d_transform_add_scaling (models are drawn in local space then scaled,
//so the collision box must apply the same scale to match), and swapping
//width/depth when rotationDegrees is 90/270 so the mask matches what's
//actually drawn. Callers pass their own rotation variable explicitly
//(e.g. zDirection, zRotation, or a literal 0) since not every object
//uses the same variable name - see scr_ApplyChainLinkFenceCollisionBounds
//and scr_ApplyBedCollisionBounds for examples. The instance's
//sprite_index must already be its collision mask sprite, and must have
//a centered origin or the resulting box will be positioned wrong
//regardless of size.
var _path = argument0;
var _scaleX = argument1;
var _scaleY = argument2;
var _rotationDegrees = argument3;

var _bounds = scr_GetModelBounds(_path);
var _localWidth = ds_list_find_value(_bounds, 0) * _scaleX;
var _localDepth = ds_list_find_value(_bounds, 1) * _scaleY;

var _worldWidth, _worldDepth;
if (_rotationDegrees mod 180 == 90)
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
