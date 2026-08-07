///scr_FogWeatherUpdate()
///Owns the fog completely: decides when a fog bank rolls in, ramps it up
///and down, and applies it. Call once per step from
///obj_weather_controller, after the hour blocks.
///
///WHEN FOG HAPPENS
///  00:00  10% chance of fog rolling in
///  02:00   5% chance, if it didn't already
///  04:00 - 09:00  it clears, at an hour picked at random when it started
///
///  So fog is a night-and-early-morning thing only, and most nights have
///  none at all. It is deliberately uncommon - roughly one night in seven
///  gets fog at all, which is what stops it becoming wallpaper.
///
///FOG NEVER APPEARS FROM 10:00 TO 15:00. That is partly the schedule
///above and partly that it would not read if it did: obj_weather_controller
///drives global.lightingAmbience to its brightest over exactly those hours
///(205 at 10:00, peaking at 255 at noon, still 190 at 15:00), so a pale fog
///against a fully lit scene is invisible. There is a hard guard below that
///clears any fog still running by 10:00, so a clock jump (the /time console
///commands, or a save loaded at midday) can't strand a fog bank in daylight.
///
///HOW IT LOOKS
///Intensity runs 0 to 1 and is eased with a smoothstep, so the bank
///arrives and leaves gently instead of at a constant rate. Both the colour
///and the distance are driven from that one value:
///
///  colour   a cool dark grey at first light haze, through mid greys, to
///           white at full thickness. Thin fog reading as grey rather than
///           white is what makes it look like weather instead of a screen
///           fade.
///  distance the range closes in as it thickens - at full strength things
///           start fading about 150px out and are gone by 1000px, which is
///           inside the draw distance, so you actually lose sight of the
///           street.
///
///Everything below is tunable through the globals set in obj_control's
///Create event.

// ---- Once-per-hour decisions.
//
// Skipped entirely while global.fogForced is set, which is what the "/fog"
// console command does. Without that, forcing a bank on for tuning would be
// undone on the spot by the 10:00 guard below - and the middle of the day is
// exactly when someone is going to be tuning it. "/fog auto" hands control
// back to the schedule.
if global.fogForced == false
{

// Guarded on the hour changing so the dice are rolled once, not every step.
if global.fogLastHour != global.timeHour
{
    global.fogLastHour = global.timeHour;

    if global.fogActive == false
    {
        if global.timeHour == 0
        {
            if random(100) < global.fogChanceMidnight
            {
                global.fogActive = true;
                global.fogClearHour = choose(4, 5, 6, 7, 8, 9);
            }
        }

        if global.timeHour == 2
        {
            if random(100) < global.fogChanceLate
            {
                global.fogActive = true;
                global.fogClearHour = choose(4, 5, 6, 7, 8, 9);
            }
        }
    }
    else
    {
        if global.timeHour == global.fogClearHour
        {
            global.fogActive = false;
        }
    }
}

// Hard guard: nothing keeps fog past 10:00, however we got here. A clock
// jump can skip the clear hour entirely, and without this the bank would
// hang around all day.
if global.fogActive == true
{
    if global.timeHour >= 10
    {
        global.fogActive = false;
    }
}

} //end of the scheduled behaviour skipped by global.fogForced

// ---- Ramp toward the target thickness.
// Separate speeds because fog rolling in and fog burning off are not
// symmetrical - it lifts more slowly than it arrives.
var _target = 0;

if global.fogActive == true
{
    _target = 1;
}

if global.fogIntensity < _target
{
    global.fogIntensity = min(_target, global.fogIntensity + global.fogRampSpeed);
}
else if global.fogIntensity > _target
{
    global.fogIntensity = max(_target, global.fogIntensity - global.fogClearSpeed);
}

// Smoothstep, so it eases in and out rather than starting and stopping
// abruptly at a constant rate
var _t = clamp(global.fogIntensity, 0, 1);
var _eased = _t * _t * (3 - 2 * _t);

// ---- Colour: cool dark grey when thin, white when thick
global.fogR = lerp(global.fogThinR, global.fogThickR, _eased);
global.fogG = lerp(global.fogThinG, global.fogThickG, _eased);
global.fogB = lerp(global.fogThinB, global.fogThickB, _eased);

// ---- Distance: pushed out beyond the draw distance when clear, so no fog
// is visible at all, and drawn in close as it thickens
global.startFog = lerp(global.fogClearStart, global.fogThickStart, _eased);
global.endFog = lerp(global.fogClearEnd, global.fogThickEnd, _eased);

d3d_set_fog(true,
            make_colour_rgb(global.fogR, global.fogG, global.fogB),
            global.startFog, global.endFog);
