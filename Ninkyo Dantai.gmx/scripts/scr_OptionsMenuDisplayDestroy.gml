if instance_exists(obj_optionsMenuToggleFullscreen)
{
    with obj_optionsMenuToggleFullscreen
    {
       instance_destroy();    
    }
}

if instance_exists(obj_optionsMenuMemoryReaderContainer)
{
    with obj_optionsMenuMemoryReaderContainer
    {
        instance_destroy();
    } 
}

