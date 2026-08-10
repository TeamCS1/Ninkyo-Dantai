///Fog System
//If this is called, it will begin and set the fog, can be used to end fog
///scr_FogSystemBuruwasu(frequency,orientation, startR, startG, startB, targetR, targetG, targetB)

var frequency = argument[0]; //the amount to increase per step 
var orientation = argument[1]; //the direction to go in; 0, reverse, 1, forward
global.fogR = argument[2]; //rgb value
global.fogG = argument[3]; //rgb value
global.fogB = argument[4]; //rgb value
var targetR = argument[5]; //rgb value
var targetG = argument[6]; //rgb value
var targetB = argument[7]; //rgb value

//reverse
if orientation == 0
{
    if global.fogR > targetR
    {
        global.fogR -= frequency; 
    }
    
    if global.fogG > targetG
    {
        global.fogG -= frequency; 
    }
    
    if global.fogB > targetB
    {
        global.fogB -= frequency; 
    }
}

//forward
else if orientation == 1
{
    if global.fogR < targetR
    {
        global.fogR += frequency; 
    }
    
    if global.fogG < targetG
    {
        global.fogG += frequency; 
    }
    
    if global.fogB < targetB
    {
        global.fogB += frequency; 
    }
}



