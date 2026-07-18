ini_open("savedata.ini");

//General >
ini_write_real("save01", "currentMoneyYen", global.yenAmount);
ini_write_real("save01", "previousLocation", global.previousLocation);

//Time specific
ini_write_real("save01", "timeMinutes", global.timeMinutes);
ini_write_real("save01", "timeSeconds", global.timeSeconds);
ini_write_real("save01", "timeHour", global.timeHour);
ini_write_real("save01", "daysOfWeekIndex", global.daysOfWeekIndex);

//character
ini_write_real("save01", "currentHealthCount", global.currentHealthCount);
ini_write_real("save01", "currentHealthMaximum", global.currentHealthMaximum);

ini_write_real("save01", "currentStaminaCount", global.currentStaminaCount);
ini_write_real("save01", "currentStaminaMaximum", global.currentStaminaMaximum);

//prayer shrines
for (var i = 0; i < 5; i++) {
    ini_write_real("save01", "shrineCollected" + string(i), global.prayerShrines[i, 2]);
}

show_debug_message("Save Success!");

ini_close();


