///NPC Spawner
///scr_UniversalNPCSpawner(npcCount,npcCell,nameOfFloor)
var npcCount = argument[0]; //real number 
var npcCell = argument[1]; //real number between 0-1
var nameOfFloor = argument[2] //variable of object name (-1 for none)

for (i = 0; i < npcCount; i++)
{
    var instVert;
    var instHoriz;

    randomize();

    //Choose a random spot in the whole map
    var xx = random_range(0, room_width)
    var yy = random_range(0, room_height)
    
    if npcCell == 0 //roads
    {
        //Find the closest vertical and horizontal road to that spot
        instVert = instance_nearest(xx,yy,obj_roadv)
        instHoriz = instance_nearest(xx,yy,obj_roadh)
    }
    
    else if npcCell == 1    //cells
    {
        instVert = instance_nearest(xx,yy,nameOfFloor)
        instHoriz = instance_nearest(xx,yy,nameOfFloor)
    }
 
    //Choose whether horizontal or vertical roads
    roadType = choose(0,1)
    
    //Choose a random NPC object
    createNPC = choose(obj_humanNPC_woman_green_buruwasu, obj_humanNPC_man_blue_buruwasu,
        obj_humanNPC_hitman_black_buruwasu, obj_humanNPC_man_brown_buruwasu,
        obj_humanNPC_man_old_black_buruwasu, obj_humanNPC_soldier_man_green_buruwasu,
        obj_humanNPC_survivor_man_blue_buruwasu)
    
    if npcCell == 0 //roads
    {
        if roadType == 0
        {
            instance_create(instVert.x, instVert.y, createNPC);
        }
        
        else if roadType == 1
        {
            instance_create(instHoriz.x, instHoriz.y, createNPC);
        }
    }
    
    else if npcCell == 1    //inside a cell
    {
        if !place_meeting(x,y,obj_block_modern_mall_floor1) 
        {
            instance_create(instVert.x, instVert.y, createNPC);
            
            with createNPC
            {
                if distance_to_object(obj_modern_mall_interior_block) < 32
                {
                    instance_destroy();
                    npcCount++;
                }
            }
        }       
    }
}
