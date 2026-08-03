///scr_ApplyBedCollisionBounds()
//Sizes the bed's collision mask using scr_GetBedCollisionBounds's
//symmetric-safe measurement rather than the shared
//scr_ApplyModelCollisionBoundsScaled/scr_GetModelBounds pipeline the
//fence/cabinet/fridge use - the bed's real model isn't centered on its
//own local origin (see scr_GetBedCollisionBounds), so the shared
//tight-fit approach left a walk-through gap on one side once rotated.
var _scale = 3; //matches obj_bed's Draw event d3d_transform_add_scaling(3,3,3)

var _bounds = scr_GetBedCollisionBounds();
var _localWidth = ds_list_find_value(_bounds, 0) * _scale;
var _localDepth = ds_list_find_value(_bounds, 1) * _scale;

var _worldWidth, _worldDepth;
if (zRotation mod 180 == 90)
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
