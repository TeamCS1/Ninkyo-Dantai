//Clears all the particle options
if instance_exists(obj_particleOptionsController)
{
    with obj_particleOptionsController
    {
        instance_destroy();
    }
}

if instance_exists(obj_rainDensityController) 
{
    with obj_rainDensityController
    {
        instance_destroy();
    }
}

if instance_exists(obj_coinParticlesSlider) 
{
    with obj_coinParticlesSlider
    {
        instance_destroy();
    }
}

if instance_exists(obj_waterQualitySliderBandonio) 
{
    with obj_waterQualitySliderBandonio
    {
        instance_destroy();
    }
}


