///scr_ApplyFridgeCollisionBounds()
//Convenience wrapper to size the fridge instance's collision mask.
//Passes the fridge's own Draw-time uniform scale (4.8, from
//d3d_transform_add_scaling(4.8,4.8,4.8)); the fridge never rotates (its
//d3d_transform_add_rotation_z call is hardcoded to 0). See
//scr_ApplyModelCollisionBoundsScaled.
scr_ApplyModelCollisionBoundsScaled(working_directory + "Assets\Buruwasu\HOME_CELL\fridge.d3d", 4.8, 4.8, 0);
