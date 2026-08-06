///--- Globals Persists
global.modelBoundsCache = -1; //ds_map, lazily created by scr_GetModelBounds
global.bedCollisionBoundsCache = -1; //ds_list, lazily created by scr_GetBedCollisionBounds
global.currentSaveSlot = 1; //1-5, selects which home.ini "customN" section is active
global.nextFurnitureId = 3; //0-2 are the shipped defaults (fridge/cabinet/bed); next added piece gets this
global.homeFurnitureSnapshot = -1; //ds_list, captured by scr_SnapshotHomeFurniture on leaving rm_ShinjiHome
global.debugGamepadOverlay = false; //toggled from the main menu options screen, drives the gamepad debug readout
global.gamepadNavUp = false; //set by scr_GamepadNavPoll, true only on the frame "up" is engaged
global.gamepadNavDown = false; //set by scr_GamepadNavPoll, true only on the frame "down" is engaged
global.gamepadNavConfirm = false; //set by scr_GamepadNavPoll, true only on the frame confirm (Cross/A) is pressed
global.gamepadNavDirectionPrevious = 0; //scr_GamepadNavPoll's edge-detection state, don't write to this elsewhere
global.gamepadConfirmPrevious = false; //scr_GamepadNavPoll's edge-detection state, don't write to this elsewhere
global.mallCount = 100;
global.cellCount = 25;
global.yenAmount = 0;
global.currentHealthCount = 100;
global.currentHealthMaximum = 100;

global.currentStaminaCount = 100;
global.currentStaminaMaximum = 100;

//time specific
global.timeMinutes = 0;
global.timeSeconds = 0;
global.timeHour = 22; //22:00 start, single variable 0-23
global.timescale = 90; //CHANGEs time speed
global.timescaleSaved = 90;
global.timescaleDivide = 60;

global.overallGameCompletion = 0;

// Create global 2D array: global.shrines[row, column]

// Shrine 0
global.prayerShrines[0, 0] = 2816; // x
global.prayerShrines[0, 1] = 4096; // y
global.prayerShrines[0, 2] = false; // collected

// Shrine 1
global.prayerShrines[1, 0] = 9728;
global.prayerShrines[1, 1] = 2944;
global.prayerShrines[1, 2] = false;

// Shrine 2
global.prayerShrines[2, 0] = 22784;
global.prayerShrines[2, 1] = 2688;
global.prayerShrines[2, 2] = false;

// Shrine 3
global.prayerShrines[3, 0] = 24704;
global.prayerShrines[3, 1] = 8960;
global.prayerShrines[3, 2] = false;

// Shrine 4
global.prayerShrines[4, 0] = 19712;
global.prayerShrines[4, 1] = 14464;
global.prayerShrines[4, 2] = false;


