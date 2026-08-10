// scr_menu_bar_handler

// Get the command ID of the clicked menu item
var cmd = argument0;

switch (cmd) 
{
    case 5:
        // Exit menu item selected
        game_end(); // Ends the game
        show_debug_message("Menu item " + string(cmd) + " selected");
        break;
    case 6:
        // Sound option selected
        // Handle graphics settings
        show_message("Sound settings");
        show_debug_message("Menu item " + string(cmd) + " selected");
        break;
    case 7:
        // Sound option selected
        // Handle sound settings
        show_message("Help Menu 
        
        #Activating the Map Editor will also trigger the Debug Mode. As a result, game behavior may have unintended consequences, and the game may function differently than it is intended to be played. Please proceed with caution.

#Getting Started
Welcome to the Map Editor! This tool allows you to customize and create your own game maps with a range of options for designing environments and placing objects.

#Basic Features
#Selecting Objects
Use the object toolbar to choose various objects to place on your map. You can select terrain, buildings, items, and NPCs from the list.

#Placing Objects
Click anywhere on the map to place the selected object. The object will automatically snap to the grid for easier alignment.

#Moving Objects
To move an object, simply click and drag it to a new location. The object will retain its current properties unless modified.

#Rotating Objects
Use the rotation tool in the top toolbar to rotate selected objects. You can rotate objects in 90-degree increments for precise placement.

#Resizing Objects
Some objects allow resizing. Use the resize tool to scale objects up or down as needed.

#Terrain Editing
Select the terrain tool to modify the landscape. You can raise or lower the ground level, add water, or change the terrain type (such as grass, sand, etc.).

#Saving Your Work
Always remember to save your map regularly. Use the save button at the top of the editor to save your progress. You can also use the “Export Map” option to create a file that can be loaded into the game.

#Previewing the Map
Use the 'Preview' button to see how the map will look in-game. This will load the map in the game engine for you to explore and test.
               
        ");
        show_debug_message("Menu item " + string(cmd) + " selected");
        break;
        
        case 9:
        
        // Close map editor menu item selected
        with obj_map_editor_controller
        {
            instance_destroy();
        }
        
        global.hideAllGameElements = false;
        window_set_caption("Ninkyo Dantai");
        
        show_debug_message("Menu item " + string(cmd) + " selected");
        break;
        
        case 10:
        
        // Exit menu item selected
        game_end(); // Ends the game
        show_debug_message("Menu item " + string(cmd) + " selected");
        break;
        
        case 34:
        
        show_debug_message("Menu item " + string(cmd) + " selected");
        break;
        
        case 36:
        
        global.pixelSpacing = 1;
        show_debug_message("Menu item " + string(cmd) + " selected");
        break;
        
        case 37:
        
        global.pixelSpacing = 16;
        show_debug_message("Menu item " + string(cmd) + " selected");
        break;
        
        case 38:
        
        global.pixelSpacing = 32;
        show_debug_message("Menu item " + string(cmd) + " selected");
        break;
        
        case 39:
        
        global.pixelSpacing = 64;
        show_debug_message("Menu item " + string(cmd) + " selected");
        break;
        
        case 40:
        
        global.pixelSpacing = 100;
        show_debug_message("Menu item " + string(cmd) + " selected");
        break;
        
    default:
        // Handle other menu actions if needed
        show_debug_message("Menu item " + string(cmd) + " selected");
        break;
}

