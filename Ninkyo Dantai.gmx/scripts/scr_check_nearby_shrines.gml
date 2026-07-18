// scr_check_nearby_shrines()

if (!instance_exists(obj_player_buruwasu)) {
    return -1;
}

var closestDist = 999999; // big initial value
var closestIndex = -1;

var px = obj_player_buruwasu.x; 
var py = obj_player_buruwasu.y;

for (var i = 0; i < 5; i++) {
    if (!global.prayerShrines[i, 2]) { // not collected
        var sx = global.prayerShrines[i, 0];
        var sy = global.prayerShrines[i, 1];
        var dist = point_distance(px, py, sx, sy);
        
        if (dist <= 256 && dist < closestDist) {
            closestDist = dist;
            closestIndex = i;
        }
    }
}

// Just return the index, no collection yet
return closestIndex;

