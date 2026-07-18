if room == rm_worldOneLevelOne
{
    if !surface_exists(global.light0) && !surface_exists(global.light1)
    {
        global.lightingColour = make_colour_rgb(40, 40, 40);    //day
        global.light0 = surface_create(view_wview[0],view_hview[0]);
        global.light1 = surface_create(view_wview[1],view_hview[1]);
    }
}

else if room == rm_worldOneLevelTwo
{
    if !surface_exists(global.light0) && !surface_exists(global.light1)
    {
        global.lightingColour = make_colour_rgb(200, 200, 200); //night
        global.light0 = surface_create(view_wview[0],view_hview[0]);
        global.light1 = surface_create(view_wview[1],view_hview[1]);
    }
}

else if room == rm_worldOneLevelThree
{
    if !surface_exists(global.light0) && !surface_exists(global.light1)
    {
        global.lightingColour = make_colour_rgb(40, 40, 40); //day (barely lights visible)
        global.light0 = surface_create(view_wview[0],view_hview[0]);
        global.light1 = surface_create(view_wview[1],view_hview[1]);
    }
}

else if room == rm_worldOneLevelFour
{
    if !surface_exists(global.light0) && !surface_exists(global.light1)
    {
        global.lightingColour = make_colour_rgb(200, 200, 200); //night
        global.light0 = surface_create(view_wview[0],view_hview[0]);
        global.light1 = surface_create(view_wview[1],view_hview[1]);
    }
}

else if room == rm_worldOneLevelFive
{
    if !surface_exists(global.light0) && !surface_exists(global.light1)
    {
        global.lightingColour = make_colour_rgb(130, 130, 130) //day
        global.light0 = surface_create(view_wview[0],view_hview[0]);
        global.light1 = surface_create(view_wview[1],view_hview[1]);
    }
}

