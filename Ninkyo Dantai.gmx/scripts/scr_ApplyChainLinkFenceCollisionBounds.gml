///scr_ApplyChainLinkFenceCollisionBounds()
//Convenience wrapper so room creation code can size a fence instance's
//collision mask with one no-argument call, the same way zDirection is
//set per-instance. Passes the fence's own Draw-time Y-scale (1.1, from
//d3d_transform_set_scaling(1,1.1,1)) so the box matches what's actually
//drawn. See scr_ApplyModelCollisionBoundsScaled.
scr_ApplyModelCollisionBoundsScaled(working_directory + "Assets\Buruwasu\chain_link_fence.d3d", 1, 1.1, zDirection);
