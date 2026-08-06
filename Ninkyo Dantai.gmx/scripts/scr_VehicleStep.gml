///scr_VehicleStep()
///Shared Step-event driving physics for every drivable vehicle - the
///grip/drift model. Call from a vehicle's Step event; it reads and writes
///the caller's own variables, so every vehicle behaves identically apart
///from the handling values set in scr_VehicleCreateEventBuruwasu.
///
///Velocity is tracked as vx/vy and applied to x/y directly rather than
///using GameMaker's built-in speed/direction, which is what makes drift
///possible: the vehicle can be pointing one way while still travelling
///another.

with (obj_player_buruwasu)
{
    sprite_index = spr_empty;
    x = other.x;
    y = other.y;
}

obj_control.bearing = direction;

// Stop GameMaker's built-in movement fighting our custom movement
speed = 0;
friction = 0;

// Inputs
var a = keyboard_check(vk_left);
var d = keyboard_check(vk_right);
var w = keyboard_check(vk_up);
var s = keyboard_check(vk_down);
var handbrake = keyboard_check(vk_space);

// Direction vectors - forward, and 90 degrees off it
var fx = lengthdir_x(1, direction);
var fy = lengthdir_y(1, direction);

var rx = lengthdir_x(1, direction - 90);
var ry = lengthdir_y(1, direction - 90);

// Current forward and sideways speed
var forwardVel = vx * fx + vy * fy;
var sideVel = vx * rx + vy * ry;

// Acceleration
if (w)
{
    vx += fx * acc;
    vy += fy * acc;
}

// Brake / reverse
if (s)
{
    if (forwardVel > 0.4)
    {
        vx -= fx * brakePower;
        vy -= fy * brakePower;
    }
    else
    {
        vx -= fx * brake;
        vy -= fy * brake;
    }
}

// Recalculate after acceleration
forwardVel = vx * fx + vy * fy;
sideVel = vx * rx + vy * ry;

// Clamp forward/reverse speed
if (forwardVel > forwardspd)
{
    vx -= fx * (forwardVel - forwardspd);
    vy -= fy * (forwardVel - forwardspd);
}

if (forwardVel < reversespd)
{
    vx -= fx * (forwardVel - reversespd);
    vy -= fy * (forwardVel - reversespd);
}

// Steering based on actual forward speed
var absSpeed = abs(forwardVel);

var speedRatio = clamp(absSpeed / forwardspd, 0, 1);
speedRatio = power(speedRatio, 0.7);

var steerPower = lerp(maxTurn, minTurn, speedRatio);

// Less steering when barely moving
var moveGrip = clamp(absSpeed / 1.5, 0, 1);

// Extra steering while handbraking so drifting feels controllable
var driftSteerBonus = 1;

if (handbrake)
{
    driftSteerBonus = 1.35;
}

if (a || d)
{
    direction += (a - d) * forwardVel * steerPower * moveGrip * driftSteerBonus;
}

// Recalculate direction vectors after steering
fx = lengthdir_x(1, direction);
fy = lengthdir_y(1, direction);

rx = lengthdir_x(1, direction - 90);
ry = lengthdir_y(1, direction - 90);

forwardVel = vx * fx + vy * fy;
sideVel = vx * rx + vy * ry;

// Drift / grip handling
var currentGrip = grip;

if (handbrake)
{
    currentGrip = driftGrip;

    // Only slightly reduce momentum so the vehicle keeps sliding
    vx *= handbrakePower;
    vy *= handbrakePower;
}

// Remove sideways velocity based on grip
vx -= rx * sideVel * currentGrip;
vy -= ry * sideVel * currentGrip;

// Drag always applies
vx *= drag;
vy *= drag;

// Extra engine braking when coasting
if (!w && !s)
{
    vx *= 0.97;
    vy *= 0.97;
}

// Move the vehicle
x += vx;
y += vy;

// Fake speed for the speedometer
forwardVel = vx * fx + vy * fy;
fakeSpeed = forwardVel * 15;

// Needle rotation
if (fakeSpeed > 0)
{
    needleRot = lerp(25, -115, clamp(fakeSpeed / 100, 0, 1));
}
else if (fakeSpeed < 0)
{
    needleRot = irandom_range(-25, -15);
}
else
{
    needleRot = 25;
}

image_angle = direction;

// Gear numbers
if (fakeSpeed <= 0)
{
    gearNumber = "R";
}
else if (fakeSpeed < 10)
{
    gearNumber = "1";
}
else if (fakeSpeed < 23)
{
    gearNumber = "2";
}
else if (fakeSpeed < 30)
{
    gearNumber = "3";
}
else if (fakeSpeed < 44)
{
    gearNumber = "4";
}
else if (fakeSpeed < 56)
{
    gearNumber = "5";
}
else
{
    gearNumber = "6";
}

/// Camera dynamics - zoom out as speed rises
if global.carZooming == true
{
    var minZoom = 700;
    var maxZoom = 1020;

    var minSpeed = 0;
    var maxSpeed = 80;

    // Clamped to 0 before the log: reversing makes fakeSpeed negative,
    // and logn of zero or a negative number is not a usable value.
    var zoomSpeed = max(fakeSpeed, minSpeed);

    var speedRange = logn(10, maxSpeed - minSpeed + 1);
    var zoomRange = maxZoom - minZoom;
    var zoomRatio = logn(10, zoomSpeed - minSpeed + 1) / speedRange;
    var zoomLevel = round(minZoom + zoomRange * zoomRatio);

    if fakeSpeed >= 0
    {
        obj_control.ztobe = zoomLevel - 200;
        obj_control.z = zoomLevel;
    }
}
