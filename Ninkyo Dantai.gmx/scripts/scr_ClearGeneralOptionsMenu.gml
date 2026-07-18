if instance_exists(obj_save_trigger_SBB)
{
    with obj_save_trigger_SBB
    {
        instance_destroy();
    }
}

if instance_exists(obj_load_trigger_SBB) 
{
    with obj_load_trigger_SBB
    {
        instance_destroy();
    }
}
