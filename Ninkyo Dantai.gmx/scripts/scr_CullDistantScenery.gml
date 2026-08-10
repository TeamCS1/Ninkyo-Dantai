///scr_CullDistantScenery()
///Deactivates static scenery that's too far from the player to be drawn,
///so its events stop running entirely. Call once per frame from
///obj_control's Begin Step.
///
///THE PROBLEM: rm_city_buruwasu holds ~6,800 instances, ~93% of them
///static scenery. Every one runs its Draw event every frame just to
///evaluate a point_distance check and decide not to draw. The check saves
///the drawing; it doesn't save the per-instance event dispatch, which at
///that count is most of the cost. A deactivated instance runs nothing at
///all.
///
///WHY IT ONLY TOUCHES A FIXED LIST, rather than deactivating everything
///outside a region: NPCs are the reason. Deactivating an NPC freezes it
///mid-walk - its Step and its AI alarms stop ticking - so a city that's
///meant to feel alive would quietly turn into one where everything
///beyond the draw distance is standing still, and anything that had been
///walking somewhere would never arrive. The same goes for the player,
///obj_control, the GUI, spawners, triggers and pickups. So the list below
///is only ever things with no behaviour to lose: floors, walls, roads,
///pavements, grass, water. Anything with a Step event that MEANS
///something must not be added to it.
///
///cullRange must stay comfortably larger than the widest drawOCRange
///gets, because a deactivated instance doesn't draw either - cull closer
///than you draw and you'll see the world end.

if global.cullSceneryEnabled == false
{
    exit;
}

// The map editor needs the whole room addressable, not just what's near
// the player
if global.hideAllGameElements == true
{
    exit;
}

// Re-cull only when the player has actually moved somewhere, so the cost
// is paid every few hundred pixels rather than every frame
var _force = false;

if global.cullLastRoom != room
{
    global.cullLastRoom = room;
    _force = true;
}

if _force == false
{
    if point_distance(global.playerX, global.playerY, global.cullLastX, global.cullLastY) < global.cullStep
    {
        exit;
    }
}

global.cullLastX = global.playerX;
global.cullLastY = global.playerY;

// Put all of it to sleep, then wake what's near the player. Sleeping an
// already-sleeping instance is harmless, and doing it this way means the
// active set is always exactly "what's in range" with no bookkeeping.
//Every sidewalk variant, not just the Buruwasu one - the city-specific
//pavements are separate objects, so each has to be listed by name. Both
//of these are Create+Draw only, same as the original, so there is no
//behaviour to lose by sleeping them.
instance_deactivate_object(obj_side_walk_buruwasu);
instance_deactivate_object(obj_side_walk_snow_buruwasu);
instance_deactivate_object(obj_sidewalk_yokyohama);
instance_deactivate_object(obj_house_block001);
instance_deactivate_object(obj_grass_buruwasu);
instance_deactivate_object(obj_roadh);
instance_deactivate_object(obj_roadv);
//The only one here with a Step and an alarm. Checked, and safe: they just
//cycle its animation frame, so the worst case is that off-screen water
//holds a frame until the player comes back. (That animation looks broken
//anyway - its Step overwrites the frame counter its own alarm just
//incremented - but that's a separate bug, not something culling caused.)
instance_deactivate_object(obj_water_anim_buruwasu);
instance_deactivate_object(obj_alleyway_floor);
instance_deactivate_object(obj_canal_buruwasu);
instance_deactivate_object(obj_construction_dirt);
instance_deactivate_object(obj_sidewalk_mall_buruwasu);

var _size = global.cullRange * 2;

instance_activate_region(global.playerX - global.cullRange,
                         global.playerY - global.cullRange,
                         _size, _size, true);
