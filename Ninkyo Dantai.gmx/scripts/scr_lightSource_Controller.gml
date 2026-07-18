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

// Enable lighting
d3d_set_lighting(true);
//LIGHTING
//removed it on this line

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
