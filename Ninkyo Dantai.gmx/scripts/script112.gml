ini_open("savedata.ini");

//Bandonio General >
ini_write_real("save01", "currentQPoints", global.currentQPoints);
ini_write_real("save01", "onCollision", global.onCollision);
ini_write_real("save01", "backInLevelSelect", global.backInLevelSelect);

//Build It Menu >
ini_write_real("save01", "grassBlockMiddle", global.grassBlockMiddle);
ini_write_real("save01", "grassBlockLeft", global.grassBlockLeft);   
ini_write_real("save01", "grassBlockRight", global.grassBlockRight);  

//Level 3 Checkpoints (world 1) > 
ini_write_real("save01", "onLevelThreeCheckpointX", global.onLevelThreeCheckpointX); 
ini_write_real("save01", "onLevelThreeCheckpointY", global.onLevelThreeCheckpointY);    

//Super Bandonio Bros Level 1 Globals

ini_write_string("save01", "levelRegionOneLevelOneName", global.levelRegionOneLevelOneName ); 
ini_write_string("save01", "levelWorldOneLevelOneStatus", global.levelWorldOneLevelOneStatus); 
ini_write_real("save01", "levelWorldOneLevelOneCompletion", global.levelWorldOneLevelOneCompletion); 
ini_write_real("save01", "timeRegionOneLevelOne", global.timeRegionOneLevelOne); 
ini_write_real("save01", "scoreRegionOneLevelOne", global.scoreRegionOneLevelOne); 
ini_write_real("save01", "coinsRegionOneLevelOne", global.coinsRegionOneLevelOne); 
ini_write_real("save01", "deathsRegionOneLevelOne", global.deathsRegionOneLevelOne); 
ini_write_real("save01", "qCratesDestroyedWorldOneLevelOne", global.qCratesDestroyedWorldOneLevelOne); 
ini_write_real("save01", "itemEntriesFoundRegionOneLevelOne", global.itemEntriesFoundRegionOneLevelOne); 

//Super Bandonio Bros Level 2 Globals
ini_write_string("save01", "worldOneLevelTwoName", global.WorldOneLevelTwoName); 
ini_write_string("save01", "worldOneLevelTwoStatus", global.WorldOneLevelTwoStatus); 
ini_write_real("save01", "worldOneLevelTwoCompletion", global.worldOneLevelTwoCompletion); 
ini_write_real("save01", "timeWorldOneLevelTwo", global.timeWorldOneLevelTwo); 
ini_write_real("save01", "scoreWorldOneLevelTwo", global.scoreWorldOneLevelTwo); 
ini_write_real("save01", "coinsWorldOneLevelTwo", global.coinsWorldOneLevelTwo); 
ini_write_real("save01", "global.deathsWorldOneLevelTwo", global.deathsWorldOneLevelTwo); 
ini_write_real("save01", "qCratesDestroyedWorldOneLevelTwo", global.qCratesDestroyedWorldOneLevelTwo); 
ini_write_real("save01", "itemEntriesFoundWorldOneLevelTwo", global.itemEntriesFoundWorldOneLevelTwo); 
ini_write_real("save01", "statuesDroppedWorldOneLevelTwo", global.statuesDroppedWorldOneLevelTwo); 

//Super Bandonio Bros Level 3 Globals
ini_write_string("save01", "worldOneLevelThreeName", global.worldOneLevelThreeName ); 
ini_write_string("save01", "worldOneLevelThreeStatus", global.worldOneLevelThreeStatus); 
ini_write_real("save01", "worldOneLevelThreeCompletion", global.worldOneLevelThreeCompletion); 
ini_write_real("save01", "timeWorldOneLevelThree", global.timeWorldOneLevelThree); 
ini_write_real("save01", "scoreWorldOneLevelThree", global.scoreWorldOneLevelThree); 
ini_write_real("save01", "coinsWorldOneLevelThree", global.coinsWorldOneLevelThree); 
ini_write_real("save01", "global.deathsWorldOneLevelThree", global.deathsWorldOneLevelThree); 
ini_write_real("save01", "qCratesDestroyedWorldOneLevelThree", global.qCratesDestroyedWorldOneLevelThree); 
ini_write_real("save01", "itemEntriesFoundWorldOneLevelThree", global.itemEntriesFoundWorldOneLevelThree); 
ini_write_real("save01", "statuesDroppedWorldOneLevelThree", global.statuesDroppedWorldOneLevelThree); 

//Super Bandonio Bros Level 4 Globals
ini_write_string("save01", "worldOneLevelFourName", global.worldOneLevelFourName); 
ini_write_string("save01", "worldOneLevelFourStatus", global.worldOneLevelFourStatus); 
ini_write_real("save01", "worldOneLevelFourCompletion", global.worldOneLevelFourCompletion); 
ini_write_real("save01", "timeWorldOneLevelFour", global.timeWorldOneLevelFour); 
ini_write_real("save01", "scoreWorldOneLevelFour", global.scoreWorldOneLevelFour); 
ini_write_real("save01", "coinsWorldOneLevelFour", global.coinsWorldOneLevelFour); 
ini_write_real("save01", "global.deathsWorldOneLevelFour", global.deathsWorldOneLevelFour); 
ini_write_real("save01", "qCratesDestroyedWorldOneLevelFour", global.qCratesDestroyedWorldOneLevelFour); 
ini_write_real("save01", "itemEntriesFoundWorldOneLevelFour", global.itemEntriesFoundWorldOneLevelFour); 
ini_write_real("save01", "statuesDroppedWorldOneLevelFour", global.statuesDroppedWorldOneLevelFour); 

ini_close();

window_set_fullscreen(false)
show_message("Save Successful!")
window_set_fullscreen(true)
