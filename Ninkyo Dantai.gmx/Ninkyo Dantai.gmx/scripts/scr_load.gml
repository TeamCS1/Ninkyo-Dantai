ini_open("savedata.ini");

// General
global.yenAmount = ini_read_real("save01", "currentMoneyYen", 0);
global.previousLocation = ini_read_real("save01", "previousLocation", 0);

// Time specific
global.timeMinutes = ini_read_real("save01", "timeMinutes", 0);
global.timeSeconds = ini_read_real("save01", "timeSeconds", 0);
global.timeHour = ini_read_real("save01", "timeHour", 22);
global.daysOfWeekIndex = ini_read_real("save01", "daysOfWeekIndex", 0);

// Character
global.currentHealthCount = ini_read_real("save01", "currentHealthCount", 100);
global.currentHealthMaximum = ini_read_real("save01", "currentHealthMaximum", 100);

global.currentStaminaCount = ini_read_real("save01", "currentStaminaCount", 100);
global.currentStaminaMaximum = ini_read_real("save01", "currentStaminaMaximum", 100);

//collectables

for (var i = 0; i < 5; i++) {
    global.prayerShrines[i, 2] = ini_read_real("save01", "shrineCollected" + string(i), 0);
}

ini_close();

//home customisation furniture (separate home.ini, see scr_LoadHomeFurniture) -
//actual repositioning happens when rm_ShinjiHome starts, since the
//furniture instances don't exist yet at this point
scr_LoadHomeFurniture();

