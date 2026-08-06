///scr_DrawVehicleDebugOverlay()
///Draws a live readout of the driving physics, or nothing at all while
///global.debugVehiclePhysics is off. Toggle it in game with the debug
///console command "/physics". Call from a vehicle's Draw GUI event.
///
///What to look at when the handling feels wrong:
///
///  Lateral vel   sideways sliding. If this stays high when you're not
///                deliberately drifting, the car will feel floaty -
///                lower lateralDamp, or raise the grip values.
///  Rear grip %   how much of the rear tyres' grip is being used. It has
///                to reach 100% for the car to drift at all. If a
///                handbrake turn never gets there, lower handbrakeGrip
///                or rearGrip.
///  Front grip %  if this sits at 100% mid-corner the car is understeering
///                and will push wide - raise frontGrip.
///  Slip angles   how far each axle is travelling away from where it
///                points. Big rear slip with small front slip is a
///                controlled drift; both large means it's just sliding.
///  Yaw rate      rotation speed. If it barely moves the car feels like
///                it's on rails; if it overshoots and won't settle,
///                lower yawDamp or raise yawInertia.

if global.debugVehiclePhysics == false
{
    exit;
}

draw_set_font(ft_buruwasu_gui);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_yellow);

var _drawX = 20;

// Starts below the notification box (which occupies y 20-100), so the
// "/physics" confirmation doesn't sit on top of the readout
var _drawY = 120;

draw_text(_drawX, _drawY, carName + "   speed " + string(round(abs(fakeSpeed))));
_drawY += 24;

draw_text(_drawX, _drawY, "Forward vel: " + string(dbgLongVel));
_drawY += 24;

draw_text(_drawX, _drawY, "Lateral vel: " + string(dbgLatVel) + "   (sideways slide)");
_drawY += 24;

draw_text(_drawX, _drawY, "Yaw rate: " + string(yawRate) + "   steer: " + string(steerAngle));
_drawY += 24;

draw_text(_drawX, _drawY, "Slip angle  front " + string(round(dbgFrontSlip)) + "   rear " + string(round(dbgRearSlip)));
_drawY += 24;

var _frontPct = 0;

if dbgFrontMax > 0
{
    _frontPct = round(abs(dbgFrontForce) / dbgFrontMax * 100);
}

var _rearPct = 0;

if dbgRearMax > 0
{
    _rearPct = round(abs(dbgRearForce) / dbgRearMax * 100);
}

draw_text(_drawX, _drawY, "Grip used   front " + string(_frontPct) + "%   rear " + string(_rearPct) + "%");
_drawY += 24;

if dbgRearSliding
{
    draw_set_color(c_red);
    draw_text(_drawX, _drawY, ">>> DRIFTING - rear tyres at their limit");
    draw_set_color(c_yellow);
}
else
{
    draw_text(_drawX, _drawY, "Gripping");
}

_drawY += 24;

draw_text(_drawX, _drawY, "Tuning: frontGrip " + string(frontGrip) + "  rearGrip " + string(rearGrip) + "  lateralDamp " + string(lateralDamp));
_drawY += 24;

draw_text(_drawX, _drawY, "        yawInertia " + string(yawInertia) + "  yawDamp " + string(yawDamp) + "  steerSpeed " + string(steerSpeed));

draw_set_color(c_white);
