//Any changes have to be made to both scripts
if room == rm_worldOneLevelOne
{
    if !surface_exists(global.light)
    {
        global.lightingColour = make_colour_rgb(40, 40, 40);    //day
        global.light = surface_create(view_wview[2],view_hview[2]);
    }
}

else if room == rm_worldOneLevelTwo
{
    if !surface_exists(global.light)
    {
        global.lightingColour = make_colour_rgb(200, 200, 200); //night
        global.light = surface_create(view_wview[2],view_hview[2]);
    }
}

else if room == rm_worldOneLevelThree
{
    if !surface_exists(global.light)
    {
        global.lightingColour = make_colour_rgb(40, 40, 40); //day
        global.light = surface_create(view_wview[2],view_hview[2]);
    }
}

else if room == rm_worldOneLevelFour
{
    if !surface_exists(global.light)
    {
        global.lightingColour = make_colour_rgb(200, 200, 200); //night
        global.light = surface_create(view_wview[2],view_hview[2]);
    }
}

else if room == rm_worldOneLevelFive
{
    if !surface_exists(global.light)
    {
        global.lightingColour = make_colour_rgb(130, 130, 130) //day
        global.light = surface_create(view_wview[2],view_hview[2]);
    }
}

