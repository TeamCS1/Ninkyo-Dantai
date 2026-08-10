/// obj_camera draw event or lighting controller

// Get camera position
var camx = x;
var camy = y;

// Create parallel lists for lamp IDs and distances
var lamps_id = ds_list_create();
var lamps_dist = ds_list_create();

// Collect all lamps and their distances
with (obj_light_source)
{
    var d = point_distance(camx, camy, x, y);
    ds_list_add(lamps_id, id);
    ds_list_add(lamps_dist, d);
}

// Sort lamps by distance (simple bubble sort; works for small numbers of lamps)
var n = ds_list_size(lamps_dist);
for (var i = 0; i < n-1; i++)
{
    for (var j = 0; j < n-1-i; j++)
    {
        if (lamps_dist[| j] > lamps_dist[| j+1])
        {
            // Swap distances
            var temp_d = lamps_dist[| j];
            lamps_dist[| j] = lamps_dist[| j+1];
            lamps_dist[| j+1] = temp_d;
            
            // Swap IDs in parallel list
            var temp_id = lamps_id[| j];
            lamps_id[| j] = lamps_id[| j+1];
            lamps_id[| j+1] = temp_id;
        }
    }
}

// NOTE: this script defines and enables the point lights, but deliberately
// does NOT switch lighting on. It used to (d3d_set_lighting(true), right
// here) and never switched it back, which was a real bug: this runs from
// obj_control's DRAW event, and every Draw GUI event in the game happens
// after all Draw events - so the whole GUI, minimap and objective text
// included, was rendered with lighting enabled. At midday the ambient is
// pure white, so they washed out. It looked positional only because any
// object drawing at a lower depth afterwards would turn lighting off again
// as part of its own draw.
//
// Light definitions persist regardless of the on/off toggle, so the
// objects that want lighting still get these lights when they enable it
// for their own draw.

// Disable all lights first
for (var i = 0; i < 8; i++)
{
    d3d_light_enable(i, false);
}

// Turn on up to 8 closest lamps
var count = min(8, ds_list_size(lamps_id));
for (var i = 0; i < count; i++)
{
    var inst = lamps_id[| i];
    // Make sure instance still exists
    if (instance_exists(inst))
    {
        var lx = inst.x;
        var ly = inst.y;
        var lz = inst.light_z;       // make sure your lamps have this variable
        var col = inst.light_col;    // make sure your lamps have this variable
        var range = inst.light_range;// make sure your lamps have this variable
        
        // Set point light with a reasonable range
        d3d_light_define_point(i, lx, ly, lz, range, col);
        d3d_light_enable(i, true);
    }
}

// Cleanup
ds_list_destroy(lamps_id);
ds_list_destroy(lamps_dist);

// Leave lighting off, the resting state the rest of the project assumes.
// obj_control's Draw is a useful place to guarantee it, since it runs
// before the lower-depth objects and before every Draw GUI event.
d3d_set_lighting(false);
