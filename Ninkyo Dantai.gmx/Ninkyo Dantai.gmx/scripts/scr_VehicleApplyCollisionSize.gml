///scr_VehicleApplyCollisionSize()
///Sizes the vehicle's collision box from its collisionSize, and forces
///every vehicle onto the same centred 128x128 mask.
///
///Call at the END of a vehicle's Create event, after any per-vehicle
///overrides - it reads collisionSize, so calling it before those would
///bake in the default.
///
///mask_index is set here rather than left to each object's maskName so
///the ten can't drift: obj_scooter_vehicle had no mask at all, which in
///GameMaker means falling back to the sprite - a 623x280 bounding box on
///a vehicle whose visible size is a fraction of that.
///
///This does NOT affect how the vehicle is drawn. scr_VehicleDraw passes
///drawXScale/drawYScale to draw_sprite_ext explicitly rather than using
///image_xscale/image_yscale, so the two are independent.

mask_index = mask_128;

image_xscale = collisionSize / 128;
image_yscale = collisionSize / 128;
