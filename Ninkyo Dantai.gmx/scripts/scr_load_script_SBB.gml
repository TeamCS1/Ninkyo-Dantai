ini_open("savedata.ini");

global.onCollision = ini_read_real("save01", "onCollision", false)
global.backInLevelSelect = ini_read_real("save01", "backInLevelSelect", false)
global.currentQPoints = ini_read_real("save01", "currentQPoints", 0)

//Build It Menu 
global.grassBlockLeft = ini_read_real("save01", "grassBlockLeft",0)
global.grassBlockMiddle = ini_read_real("save01", "grassBlockMiddle",0)
global.grassBlockRight = ini_read_real("save01", "grassBlockRight",0)

//Level 3 Checkpoints (world 1) > 
global.onLevelThreeCheckpointX = ini_read_real("save01", "onLevelThreeCheckpointX",0)
global.onLevelThreeCheckpointY = ini_read_real("save01", "onLevelThreeCheckpointY",0)

//Super Bandonio Bros Level 1 Globals
global.levelRegionOneLevelOneName = ini_read_string("save01", "levelRegionOneLevelOneName","Level 1")
global.levelWorldOneLevelOneStatus = ini_read_string("save01", "levelWorldOneLevelOneStatus","Available")
global.levelWorldOneLevelOneCompletion = ini_read_real("save01", "levelWorldOneLevelOneCompletion",0)
global.timeRegionOneLevelOne = ini_read_real("save01", "timeRegionOneLevelOne",0)
global.scoreRegionOneLevelOne = ini_read_real("save01", "scoreRegionOneLevelOne",0)
global.coinsRegionOneLevelOne = ini_read_real("save01", "coinsRegionOneLevelOne",0)
global.deathsRegionOneLevelOne = ini_read_real("save01", "deathsRegionOneLevelOne",0)
global.qCratesDestroyedWorldOneLevelOne = ini_read_real("save01", "qCratesDestroyedWorldOneLevelOne",0)
global.itemEntriesFoundRegionOneLevelOne = ini_read_real("save01", "itemEntriesFoundRegionOneLevelOne",0)

//Super Bandonio Bros Level 2 Globals
global.worldOneLevelTwoName = ini_read_string("save01", "worldOneLevelTwoName","Level 2")
global.worldOneLevelTwoStatus = ini_read_string("save01", "worldOneLevelTwoStatus","Locked")
global.worldOneLevelTwoCompletion = ini_read_real("save01", "worldOneLevelTwoCompletion",0)
global.timeWorldOneLevelTwo = ini_read_real("save01", "timeWorldOneLevelTwo",0)
global.scoreWorldOneLevelTwo = ini_read_real("save01", "scoreWorldOneLevelTwo",0)
global.coinsWorldOneLevelTwo = ini_read_real("save01", "coinsWorldOneLevelTwo",0)
global.deathsWorldOneLevelTwo = ini_read_real("save01", "deathsWorldOneLevelTwo",0)
global.qCratesDestroyedWorldOneLevelTwo = ini_read_real("save01", "qCratesDestroyedWorldOneLevelTwo",0)
global.itemEntriesFoundWorldOneLevelTwo = ini_read_real("save01", "itemEntriesFoundWorldOneLevelTwo",0)
global.statuesDroppedWorldOneLevelTwo = ini_read_real("save01", "statuesDroppedWorldOneLevelTwo",0)

//Super Bandonio Bros Level 3 Globals
global.worldOneLevelThreeName = ini_read_string("save01", "worldOneLevelThreeName","Level 3")
global.worldOneLevelThreeStatus = ini_read_string("save01", "worldOneLevelThreeStatus","Locked")
global.worldOneLevelThreeCompletion = ini_read_real("save01", "worldOneLevelThreeCompletion",0)
global.timeWorldOneLevelThree = ini_read_real("save01", "timeWorldOneLevelThree",0)
global.scoreWorldOneLevelThree = ini_read_real("save01", "scoreWorldOneLevelThree",0)
global.coinsWorldOneLevelThree = ini_read_real("save01", "coinsWorldOneLevelThree",0)
global.deathsWorldOneLevelThree = ini_read_real("save01", "global.deathsWorldOneLevelThree",0)
global.qCratesDestroyedWorldOneLevelThree = ini_read_real("save01", "qCratesDestroyedWorldOneLevelThree",0)
global.itemEntriesFoundWorldOneLevelThree = ini_read_real("save01", "itemEntriesFoundWorldOneLevelThree",0)
global.statuesDroppedWorldOneLevelThree = ini_read_real("save01", "statuesDroppedWorldOneLevelThree",0)

//Super Bandonio Bros Level 4 Globals
global.worldOneLevelFourName = ini_read_string("save01", "worldOneLevelFourName","Level 4")
global.worldOneLevelFourStatus = ini_read_string("save01", "worldOneLevelFourStatus","Locked")
global.worldOneLevelFourCompletion = ini_read_real("save01", "worldOneLevelFourCompletion",0)
global.timeWorldOneLevelFour = ini_read_real("save01", "timeWorldOneLevelFour",0)
global.scoreWorldOneLevelFour = ini_read_real("save01", "scoreWorldOneLevelFour",0)
global.coinsWorldOneLevelFour = ini_read_real("save01", "coinsWorldOneLevelFour",0)
global.deathsWorldOneLevelFour = ini_read_real("save01", "deathsWorldOneLevelFour",0)
global.qCratesDestroyedWorldOneLevelFour = ini_read_real("save01", "qCratesDestroyedWorldOneLevelFour",0)
global.itemEntriesFoundWorldOneLevelFour = ini_read_real("save01", "itemEntriesFoundWorldOneLevelFour",0)
global.statuesDroppedWorldOneLevelFour = ini_read_real("save01", "statuesDroppedWorldOneLevelFour",0)

ini_close()

window_set_fullscreen(false)
show_message("Load Successful!")
window_set_fullscreen(true)

room_goto(rm_level_select_region1)
