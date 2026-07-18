/*
Is the solid, enemy, etc. colliding with the character?
*/

if instance_exists(oCharacter)
{
    oCharacter.tempId=id;   //this should be the id of a block or enemy.
    with (oCharacter) 
    {
        calculateCollisionBounds(); //if there is a collision with tempId on the character's sides.
    
    if (collision_rectangle(lb,tb,rb-1,bb-1,tempId,1,1) >0) 
    {
        return 1;
    }
    
    }
    
    return 0;
}
