///scr_BuruwasuMapEditorObjectDestroy(target)
/// @func scr_BuruwasuMapEditorObjectDestroy(target)
/// @desc Create event 
/// @arg target
target = argument0;

with argument0
{
    if show_question("Are you sure you wish to destroy this instance? :" + string(argument0))
    {
        stringEntered = ""
        instance_destroy();
    }
                
    else
    { 
                    
    }    
}
