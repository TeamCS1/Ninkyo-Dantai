///W1 Level 1 & 2 Singleplayer and Co-Op
if room == rm_worldOneLevelOne && global.isSoloBandonio == 1
{
    if !instance_exists(oPlayer1)
    {
        instance_create(80, 272, oPlayer1)
    }

    //Setup cameras
    view_visible[0] = false; //co op view player 1
    view_visible[1] = false; //co op view player 2
    view_visible[2] = true; //singleplayer view
}

else if room == rm_worldOneLevelOne && global.isSoloBandonio == 2
{
    if !instance_exists(oPlayer1)
    {
        instance_create(80, 272, oPlayer1)
    }

    if !instance_exists(oPlayer2)
    {
        instance_create(176, 448, oPlayer2)
    }

    view_visible[0] = true; //co op view player 1
    view_visible[1] = true; //co op view player 2
    view_visible[2] = false; //singleplayer view
}

//Level 2
if room == rm_worldOneLevelTwo && global.isSoloBandonio == 1
{
    if !instance_exists(oPlayer1)
    {
        instance_create(585, 285, oPlayer1)
    }

    view_visible[0] = false; //co op view player 1
    view_visible[1] = false; //co op view player 2
    view_visible[2] = true; //singleplayer view
}

else if room == rm_worldOneLevelTwo && global.isSoloBandonio == 2
{
    //Game is co-op 
    if !instance_exists(oPlayer1)
    {
        instance_create(585, 285, oPlayer1)
    }

    if !instance_exists(oPlayer2)
    {
        instance_create(448, 328, oPlayer2)
    }

    view_visible[0] = true; //co op view player 1
    view_visible[1] = true; //co op view player 2
    view_visible[2] = false; //singleplayer view
}

///Level 3 Singleplayer and Co-Op

//level 3 - Respawn without checkpoint
if room == rm_worldOneLevelThree && global.isSoloBandonio == 1 && global.onLevelThreeIsCheckpointTriggered == false //Is in solo-mode
{
    if !instance_exists(oPlayer1)
    {
        instance_create(496, 656, oPlayer1)
    }
}

//level 3 - Respawn without checkpoint
else if room == rm_worldOneLevelThree && global.isSoloBandonio == 2 && global.onLevelThreeIsCheckpointTriggered == false //is in co-op
{
    if !instance_exists(oPlayer1)
    {
        instance_create(496, 656, oPlayer1)
    }

    if !instance_exists(oPlayer2)
    {
        instance_create(496 + 30, 656, oPlayer2)
    }
}

//Checkpoint check - singleplayer
else if room == rm_worldOneLevelThree && global.isSoloBandonio == 1 && global.onLevelThreeIsCheckpointTriggered == true
{
    if !instance_exists(oPlayer1)
    {
        instance_create(global.onLevelThreeCheckpointX, global.onLevelThreeCheckpointY - 30, oPlayer1)
    }
}

//Checkpoint check - co-op
else if room == rm_worldOneLevelThree && global.isSoloBandonio == 2 && global.onLevelThreeIsCheckpointTriggered == true
{

    if !instance_exists(oPlayer1)
    {
        instance_create(global.onLevelThreeCheckpointX, global.onLevelThreeCheckpointY - 30, oPlayer1);
    }

    if !instance_exists(oPlayer2)
    {
        instance_create(global.onLevelThreeCheckpointX - 20, global.onLevelThreeCheckpointY - 30, oPlayer2);
    }
}

//Level 3 singleplayer - camera control
if room == rm_worldOneLevelThree && global.isSoloBandonio == 1
{
    view_visible[0] = false; //co op view player 1
    view_visible[1] = false; //co op view player 2
    view_visible[2] = true; //singleplayer view
}

///W1 Level 3 Co-Op - camera camera control
if room == rm_worldOneLevelThree && global.isSoloBandonio == 2
{
    view_visible[0] = true; //co op view player 1
    view_visible[1] = true; //co op view player 2
    view_visible[2] = false; //singleplayer view
}

///W1 Level 4 Singleplayer and Co-Op
if room == rm_worldOneLevelFour && global.isSoloBandonio == 1 && !instance_exists(oPlayer1)

{
    instance_create(1264, 400, oPlayer1)

    view_visible[0] = false; //co op view player 1
    view_visible[1] = false; //co op view player 2
    view_visible[2] = true; //singleplayer view
}

///W1 Level 4 Co-Op

if room == rm_worldOneLevelFour && global.isSoloBandonio == 2 && !instance_exists(oPlayer1) && !instance_exists(oPlayer2)

//Game is co-op 

{
    instance_create(1264, 400, oPlayer1)
    instance_create(1264, 400 - 50, oPlayer2)

    view_visible[0] = true; //co op view player 1
    view_visible[1] = true; //co op view player 2
    view_visible[2] = false; //singleplayer view
}

///W1 Level 5 Singleplayer and Co-Op
if room == rm_worldOneLevelFive && global.isSoloBandonio == 1 && !instance_exists(oPlayer1)
{
    //check if checkpoint is triggered
    if global.levelFiveCheckpointY > 0
    {
        if !instance_exists(oPlayer1)
        {
            instance_create(global.levelFiveCheckpointX, global.levelFiveCheckpointY, oPlayer1)
        }
    }
    
    else
    {
        if !instance_exists(oPlayer1)
        {
            instance_create(1088, 5616, oPlayer1);
        }
    }
    

    //instance_create(x,y,obj_draw_level5_HUD)

    view_visible[0] = false; //co op view player 1
    view_visible[1] = false; //co op view player 2
    view_visible[2] = true; //singleplayer view
}

///W1 Level 5 Co-Op
if room == rm_worldOneLevelFive && global.isSoloBandonio == 2 && !instance_exists(oPlayer1) && !instance_exists(oPlayer2)
{
    //check if checkpoint is triggered
    if global.levelFiveCheckpointY > 0
    {
        if !instance_exists(oPlayer1)
        {
            instance_create(global.levelFiveCheckpointX, global.levelFiveCheckpointY, oPlayer1)
        }
        
        if !instance_exists(oPlayer2)
        {
            instance_create(global.levelFiveCheckpointX + 16, global.levelFiveCheckpointY, oPlayer2)
        }
    }
    
    else
    {
        if !instance_exists(oPlayer1)
        {
            instance_create(1088, 5616, oPlayer1)
        }

        if !instance_exists(oPlayer2)
        {
            instance_create(1088 + 16, 5616, oPlayer2)
        }
    }   

    view_visible[0] = true; //co op view player 1
    view_visible[1] = true; //co op view player 2
    view_visible[2] = false; //singleplayer view
}

///W1 Level 6 Singleplayer and Co-Op
if room == rm_worldOneLevelSix && global.isSoloBandonio == 1 && !instance_exists(oPlayer1)

{
    instance_create(32, 144, oPlayer1)

    view_visible[0] = false; //co op view player 1
    view_visible[1] = false; //co op view player 2
    view_visible[2] = true; //singleplayer view
}

///W1 Level 6 Co-Op

if room == rm_worldOneLevelSix && global.isSoloBandonio == 2 && !instance_exists(oPlayer1) && !instance_exists(oPlayer2)

//Game is co-op 
{
    instance_create(50, 400, oPlayer1)
    instance_create(50, 400 - 50, oPlayer2)

    view_visible[0] = true; //co op view player 1
    view_visible[1] = true; //co op view player 2
    view_visible[2] = false; //singleplayer view
}
