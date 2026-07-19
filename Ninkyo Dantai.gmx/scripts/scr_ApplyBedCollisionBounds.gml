///scr_ApplyBedCollisionBounds()
//Convenience wrapper so room creation code can size a bed instance's
//collision mask with one no-argument call, the same way zRotation is
//set per-instance. Passes the bed's own Draw-time uniform scale (3, from
//d3d_transform_add_scaling(3,3,3)) and its zRotation variable (note:
//this object uses zRotation, not zDirection). See
//scr_ApplyModelCollisionBoundsScaled.
scr_ApplyModelCollisionBoundsScaled(working_directory + "Assets\Buruwasu\HOME_CELL\bed.d3d", 3, 3, zRotation);
