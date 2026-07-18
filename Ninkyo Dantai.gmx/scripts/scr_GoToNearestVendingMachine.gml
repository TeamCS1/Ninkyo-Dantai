var maxDistance = 1000000, targetedInstance = noone, distanceDifference, 
target, startMoving = false;

//Find nearest vending machine
with obj_vending_machine
{
    distanceDifference = distance_to_object(other.id);
    if distanceDifference < maxDistance
    {
        maxDistance = distanceDifference;
        targetedInstance = id;
    }
}

if targetedInstance != noone
{
    target = targetedInstance;
    startMoving = true;
}

//Start moving towards nearest
if startMoving == true
{
    if point_distance(x,y,target.x,target.y) > 46
    {
        move_towards_point(target.x,target.y,3)
    }    
    
    if point_distance(x,y,target.x,target.y) < 45 or place_meeting(x,y,obj_vending_machine)
    {
        speed = 0;
        //show_debug_message("At Vending Machine. Speed Set to 0.")
        
        //startMoving = false;
    }  
}
