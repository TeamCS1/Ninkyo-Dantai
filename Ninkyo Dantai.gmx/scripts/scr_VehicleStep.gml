///scr_VehicleStep()
///Shared Step-event driving physics for every drivable vehicle. Call from
///a vehicle's Step event; it reads and writes the caller's own variables,
///so every vehicle behaves identically apart from the handling values set
///in scr_VehicleCreateEventBuruwasu.
///
///This is a bicycle model: the vehicle is treated as a front axle and a
///rear axle, each generating sideways grip based on its SLIP ANGLE - how
///far the direction that axle is actually travelling differs from the
///direction it's pointing. Grip rises with slip angle up to a limit, then
///saturates. That saturation is what a real tyre does when it lets go,
///and it's where the interesting behaviour comes from for free:
///
///  - Lose rear grip (handbrake, or too much throttle mid-corner) and the
///    rear axle stops resisting rotation, so the car rotates into a slide.
///  - Countersteering points the front wheels back along the direction of
///    travel, which drops front slip angle and lets the front bite again,
///    pulling the car straight. You steer a drift, rather than the drift
///    just decaying on a timer.
///  - Weight transfer under throttle/brake moves grip between the axles,
///    so braking into a corner rotates the car and power pushes it wide.
///
///Rotation is a real yaw rate with inertia rather than the heading being
///snapped straight to the steering input, and the steering wheel itself
///moves at a limited rate. Those two are what stop it feeling like a
///turret on ice.

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

// ---- Input
var _left = keyboard_check(vk_left);
var _right = keyboard_check(vk_right);
var _throttle = keyboard_check(vk_up);
var _braking = keyboard_check(vk_down);
var _handbrake = keyboard_check(vk_space);

var _steerInput = _left - _right;

// ---- Body axes.
// Forward, and lateral with LEFT positive, so that positive lateral
// velocity, positive steering and positive yaw all mean "to the left" and
// the signs below stay consistent.
var _fx = lengthdir_x(1, direction);
var _fy = lengthdir_y(1, direction);
var _lx = lengthdir_x(1, direction + 90);
var _ly = lengthdir_y(1, direction + 90);

var _longVel = vx * _fx + vy * _fy;
var _latVel = vx * _lx + vy * _ly;

var _absLong = abs(_longVel);
var _speedRatio = clamp(_absLong / forwardspd, 0, 1);

// ---- Steering wheel.
// Rate-limited rather than instant, and with less lock available at speed
// so the car doesn't get twitchy on the straights.
var _lockNow = lerp(steerLock, steerLockTop, _speedRatio);
var _targetSteer = _steerInput * _lockNow;

var _steerRate = steerSpeed;

if _steerInput == 0
{
    _steerRate = steerReturn;
}

steerAngle += clamp(_targetSteer - steerAngle, -_steerRate, _steerRate);

// ---- Weight transfer.
// Throttle pushes weight rearward (front goes light, car understeers),
// braking pushes it forward (rear goes light, car rotates in).
var _transfer = 0;

if _throttle
{
    _transfer += weightTransfer;
}

if _braking
{
    _transfer -= weightTransfer;
}

var _frontMax = frontGrip * (1 - _transfer);
var _rearMax = rearGrip * (1 + _transfer);

if _handbrake
{
    _rearMax *= handbrakeGrip;
}

// ---- Slip angles.
// Guard the denominator: at a standstill the slip angle is meaningless
// and would otherwise divide by zero.
var _refLong = _absLong;

if _refLong < 0.5
{
    _refLong = 0.5;
}

var _longSign = 1;

if _longVel < 0
{
    _longSign = -1;
}

var _yawRad = degtorad(yawRate);

// Sideways velocity at each axle includes the contribution from the car
// already rotating, which is what makes the model self-stabilising.
var _frontLatVel = _latVel + _yawRad * axleFront;
var _rearLatVel = _latVel - _yawRad * axleRear;

var _frontSlip = darctan2(_frontLatVel, _refLong) - steerAngle * _longSign;
var _rearSlip = darctan2(_rearLatVel, _refLong);

// ---- Lateral grip forces, saturating at each axle's limit
var _frontForce = clamp(-corneringStiffness * _frontSlip, -_frontMax, _frontMax);
var _rearForce = clamp(-corneringStiffness * _rearSlip, -_rearMax, _rearMax);

// Fade grip in from a standstill so a parked vehicle doesn't jitter
var _gripFade = clamp(_absLong / 0.8, 0, 1);
_frontForce *= _gripFade;
_rearForce *= _gripFade;

// ---- Longitudinal forces
var _drive = 0;

if _throttle
{
    _drive += acc;
}

if _braking
{
    if _longVel > 0.1
    {
        _drive -= brakePower;
    }
    else
    {
        // Already stopped or rolling backwards - this is reverse, not braking
        _drive -= brake;
    }
}

if _handbrake
{
    _drive -= handbrakeBrake * _longSign * _gripFade;
}

_longVel += _drive;
_longVel *= drag;
_longVel = clamp(_longVel, reversespd, forwardspd);

// ---- Integrate lateral velocity and yaw
var _steerCos = dcos(steerAngle);

_latVel += (_frontForce * _steerCos) + _rearForce;
_latVel *= lateralDamp;

var _torque = (_frontForce * _steerCos * axleFront) - (_rearForce * axleRear);

yawRate += _torque / yawInertia;
yawRate *= yawDamp;
yawRate = clamp(yawRate, -maxYawRate, maxYawRate);

// ---- Back to world space and move
vx = _longVel * _fx + _latVel * _lx;
vy = _longVel * _fy + _latVel * _ly;

direction += yawRate;

x += vx;
y += vy;

image_angle = direction;

// ---- Readouts for the speedometer and the physics debug overlay
fakeSpeed = _longVel * 15;

dbgLongVel = _longVel;
dbgLatVel = _latVel;
dbgFrontSlip = _frontSlip;
dbgRearSlip = _rearSlip;
dbgFrontForce = _frontForce;
dbgRearForce = _rearForce;
dbgFrontMax = _frontMax;
dbgRearMax = _rearMax;

// The rear axle being at its limit is the definition of "drifting" here
dbgRearSliding = false;

if _rearMax > 0
{
    if abs(_rearForce) >= _rearMax * 0.98
    {
        if _gripFade > 0.5
        {
            dbgRearSliding = true;
        }
    }
}

// ---- Needle rotation
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

// ---- Gear numbers
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
    var _minZoom = 700;
    var _maxZoom = 1020;

    var _minSpeed = 0;
    var _maxSpeed = 80;

    // Clamped to 0 before the log: reversing makes fakeSpeed negative,
    // and logn of zero or a negative number is not a usable value.
    var _zoomSpeed = max(fakeSpeed, _minSpeed);

    var _speedRange = logn(10, _maxSpeed - _minSpeed + 1);
    var _zoomRange = _maxZoom - _minZoom;
    var _zoomRatio = logn(10, _zoomSpeed - _minSpeed + 1) / _speedRange;
    var _zoomLevel = round(_minZoom + _zoomRange * _zoomRatio);

    if fakeSpeed >= 0
    {
        obj_control.ztobe = _zoomLevel - 200;
        obj_control.z = _zoomLevel;
    }
}
