///scr_ApplyCabinetCollisionBounds()
//Convenience wrapper to size a cabinet instance's collision mask. The
//cabinet's Draw event draws at scale (1,1,1) and never rotates (its
//d3d_transform_add_rotation_z call is hardcoded to 0), so this always
//passes scale 1/1 and rotation 0. See scr_ApplyModelCollisionBoundsScaled.
scr_ApplyModelCollisionBoundsScaled(working_directory + "Assets\Buruwasu\HOME_CELL\wood_cabinet.d3d", 1, 1, 0);
