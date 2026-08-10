randomize();

direction = choose(0,90,180,270)
speed = choose(0,1,2,3,4)

enum characterstates
{
    idle,
    walking,
    actiontelephonebox,
    actionvendingmachine 
}

if speed <= 0
{
    characterstates = characterstates.idle;  
}

else if speed == 4
{
    characterstates = characterstates.actionvendingmachine;
}

else
{
    characterstates = characterstates.walking;
}

switch(characterstates)
{
    case characterstates.idle: //standing state/idle
    {
        drawState = 0;
        stringState = "";
        
        //Retrieve random character idle/standing dialogue
        stringState = scr_IdleStatesReturn();

        //Re-run logic
        doAgainInterval = choose(5,6,7,8,9,10);
        alarm[0] = room_speed * doAgainInterval;
        
        break;
         
    }
    
    case characterstates.walking:
    {
        stringState = "";
        
        doAgainInterval = choose(5,6,7,8,9,10);
        alarm[0] = room_speed * doAgainInterval;

        break;
    }
    
    case characterstates.actiontelephonebox:
    {
        break; 
    }
    
    case characterstates.actionvendingmachine:
    {
        drawState = 1;
        stringStateVending = "";
        stringStateVendingQuotes = ds_list_create();
        ds_list_add(stringStateVendingQuotes, "Yum yum.");
        ds_list_add(stringStateVendingQuotes, "Nothing like some soda");
        ds_list_add(stringStateVendingQuotes, "That tastes delicious!");
        ds_list_shuffle(stringStateVendingQuotes);

        randomize();
        stringStateVending = stringStateVendingQuotes[| irandom(ds_list_size(stringStateVendingQuotes)-1)];

        ds_list_destroy(stringStateVendingQuotes); 
        //go towards vending machine
        //show_debug_message("Vending Machine function loaded")
        scr_GoToNearestVendingMachine();

        doAgainInterval = 30
        alarm[0] = room_speed * doAgainInterval;
        
        break; 
    }
    
    default: 
        stringState = "";
        break;
        
}



