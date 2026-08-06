///scr_VehicleDrawGUI()
///Shared Draw GUI rendering for every drivable vehicle: the speedometer,
///gear indicator, needle and the vehicle name plate. Call from a
///vehicle's Draw GUI event.
///
///Reads carName / toDrawCarName off the calling instance rather than a
///hardcoded object, so it works for whichever vehicle the player is
///actually in.

if (global.inVehicle == true)
{
    draw_sprite_ext(spr_speedometer_buruwasu, 0, 1480, 710, 1, 1, 0, c_white, 1);

    draw_set_font(ft_speedometer_buruwasu);
    draw_set_color(c_white);

    var displaySpeed = floor(fakeSpeed);

    draw_text(1840, 925, string(abs(displaySpeed)));
    draw_text(1840, 1000, string(gearNumber));

    draw_sprite_ext(spr_needle_buruwasu, 0, 1640, 860, 1, 1, needleRot, c_white, 1);

    if (toDrawCarName == true)
    {
        draw_set_font(ft_carName_buruwasu);
        draw_set_color(c_red);

        draw_text(300, 900, string(carName));
    }

    draw_set_color(c_white);

    scr_DrawVehicleDebugOverlay();
}
else
{
    global.drawOCRange = global.drawOCRangeBase;
}
