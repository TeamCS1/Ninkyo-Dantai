///scr_VehicleCreateEventBuruwasu(
/// top_speed_max,
/// reverse_speed_max,
/// acceleration,
/// brake_velocity,
/// car_name)
///
///Shared Create-event setup for every drivable vehicle. Call it first,
///then override any handling value below that should differ for this
///vehicle type - a truck wants slower steering and worse brakes than a
///police car, but they run the same code to get there.
///
///The defaults are the sedan's (obj_car), which is the vehicle the
///grip/drift model was originally tuned against.
///
///NOTE: this no longer takes the instance as argument0. Scripts run in
///the caller's scope, so it writes to whichever instance called it. The
///old signature invited passing the OBJECT (obj_truck) rather than `id`,
///which writes to every instance of that type instead of the one being
///created - harmless with a single instance, wrong as soon as there are
///two. turn_radius / deacc / brake_strength are gone with it: they only
///fed the old built-in-speed model that scr_VehicleStep replaced.

forwardspd = argument0;
reversespd = argument1;
acc = argument2;
brake = argument3;
carName = argument4;

// Custom physics state - the vehicle moves by adding these to x/y itself
// rather than using GameMaker's built-in speed/direction
vx = 0;
vy = 0;
yawRate = 0;            // how fast the body is rotating, degrees per step
steerAngle = 0;         // where the front wheels are actually pointed

// ---- Handling values. Override these per vehicle after calling this.
// See scr_VehicleStep for how they combine; the notes below are what each
// one does to the FEEL, which is what you actually want when tuning.

// Grip. The maximum sideways force each axle can make before the tyres
// let go. Front lower than rear = understeer (pushes wide, safe). Rear
// lower than front = oversteer (rotates, wants to drift).
frontGrip = 0.14;
rearGrip = 0.13;

// How hard the tyres bite per degree of slip. Higher = sharper, more
// darty response and grip reached sooner; lower = softer and lazier.
corneringStiffness = 0.05;

// Steering wheel. steerLock is the lock available when crawling,
// steerLockTop the (much smaller) lock at full speed. That drop is what
// stops you taking any corner flat out - at speed the car is limited by
// steering geometry, not grip, exactly like a real one. steerSpeed is
// how fast the wheel moves toward the input, steerReturn how fast it
// recentres. Low steerSpeed is a big part of feeling like a car rather
// than a cursor.
steerLock = 40;
steerLockTop = 7;
steerSpeed = 1.2;
steerReturn = 2.0;

// Rotation. yawInertia is how reluctant the body is to start or stop
// rotating - raise it for something heavy, and it sets how long turn-in
// takes. yawDamp bleeds off spin; note that lowering it also widens
// every corner, because sustained rotation then needs more torque.
yawInertia = 90;
yawDamp = 0.98;
maxYawRate = 8;         // safety clamp, degrees per step

// How quickly sideways motion scrubs off on its own. THIS IS THE FLOATY
// DIAL: lower values plant the car, higher values let it skate. Kept
// high so the tyre model does the work rather than this hiding it.
lateralDamp = 0.97;

// How much throttle/braking shifts grip between the axles. Raise it for
// more dramatic lift-off rotation and power understeer.
weightTransfer = 0.25;

// Handbrake. handbrakeGrip is the fraction of rear grip left while it's
// held (low = breaks away easily), handbrakeBrake how much it slows you.
handbrakeGrip = 0.22;
handbrakeBrake = 0.06;

// Distance from the centre of mass to each axle, in the same pixels the
// vehicle moves in. These have to be big relative to how far the car
// travels per step or the geometry stops making sense - at 6px a step
// with a 40px wheelbase the car covers about a sixth of its own length
// per frame, which is roughly right. Raising axleRear makes the rear
// more stable; a shorter wheelbase overall rotates faster.
axleFront = 20;
axleRear = 20;

drag = 0.995;           // rolling/air resistance along the direction of travel
brakePower = 0.12;      // braking force when slowing from forward movement

// How the vehicle sprite is drawn (see scr_VehicleDraw)
drawXScale = 0.6;
drawYScale = 0.7;

// Readouts for the physics debug overlay, filled in by scr_VehicleStep
dbgLongVel = 0;
dbgLatVel = 0;
dbgFrontSlip = 0;
dbgRearSlip = 0;
dbgFrontForce = 0;
dbgRearForce = 0;
dbgFrontMax = 0;
dbgRearMax = 0;
dbgRearSliding = false;

// Speedometer / name plate state
fakeSpeed = 0;
toDrawCarName = false;
gearNumber = "1";
needleRot = 25;

// Show the vehicle name shortly after getting in
alarm[0] = room_speed * 0.1;

// Car zoom effect - you see further from a moving vehicle.
// Set from the resting base rather than doubling the CURRENT range: this
// used to be "drawOCRange = drawOCRange * 2", which compounded every time
// you got into a vehicle (750 -> 1500 -> 3000 -> ...) because nothing put
// it back on the way out. Each doubling quadruples how much of the world
// is drawn, so it ate the framerate a little more with every car.
if global.carZooming == true
{
    global.drawOCRange = global.drawOCRangeBase * 2;
}

else
{
    global.drawOCRange = global.drawOCRangeBase;
}
