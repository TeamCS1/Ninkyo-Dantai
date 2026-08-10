///scr_VehicleDraw()
///Shared Draw-event rendering for every drivable vehicle: draws the
///sprite rotated to travel direction, but only while the player is close
///enough to matter. Call from a vehicle's Draw event.
///
///drawXScale / drawYScale come from scr_VehicleCreateEventBuruwasu so a
///vehicle whose sprite is authored at a different size (the scooter)
///can render correctly without needing its own copy of this code.

if point_distance(x, y, global.playerX, global.playerY) < global.drawOCRange
{
    draw_set_alpha_test(true);
    draw_set_alpha_test_ref_value(128);
    draw_sprite_ext(sprite_index, image_index, x, y, drawXScale, drawYScale, direction, c_white, 1);
}

// Always turned back off, not just in the out-of-range branch. Draw state
// persists across instances and frames, so leaving alpha testing on here
// silently changes how everything drawn after this vehicle renders.
draw_set_alpha_test(false);
