///scr_BuruwasuMapEditorAxisZUpMove(target)
/// @func scr_BuruwasuMapEditorAxisZUpMove(target)
/// @desc Create event 
/// @arg target
target = argument0; 

with argument0
{
    if zIsTwoPoints == true
    {
        z1 -= global.pixelSpacing
        z2 += global.pixelSpacing
        show_debug_message("Moved " + string(argument0) + " Up by 64px!")
    }

    else
    {
        z += global.pixelSpacing
        show_debug_message("Moved " + string(argument0) + " Up by 64px!")
    }
}
