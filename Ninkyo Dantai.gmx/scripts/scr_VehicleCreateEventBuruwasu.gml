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

// Custom physics velocity - the vehicle moves by adding these to x/y
// itself rather than using GameMaker's built-in speed/direction
vx = 0;
vy = 0;

// Handling values - override these per vehicle after calling this
grip = 0.12;            // how quickly it regains traction and stops sliding sideways
driftGrip = 0.035;      // reduced traction while handbraking, for controlled drifting
drag = 0.985;           // rolling resistance that slowly bleeds off momentum
brakePower = 0.12;      // braking force when slowing from forward movement
handbrakePower = 0.965; // fraction of momentum kept each frame while handbraking

// Steering - turn rate falls off as speed rises, between these two
maxTurn = 1.45;         // turn rate when barely moving
minTurn = 0.25;         // turn rate at top speed

// How the vehicle sprite is drawn (see scr_VehicleDraw)
drawXScale = 0.6;
drawYScale = 0.7;

// Speedometer / name plate state
fakeSpeed = 0;
toDrawCarName = false;
gearNumber = "1";
needleRot = 25;

// Show the vehicle name shortly after getting in
alarm[0] = room_speed * 0.1;

// Car zoom effect
if global.carZooming == true
{
    global.drawOCRange = (global.drawOCRange * 2);
}

else
{
    global.drawOCRange = 576;
}
