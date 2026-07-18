ini_open("configs.ini");

    ini_write_real("options", "roomBeforePrevious", global.roomBeforePrevious); 
    ini_write_real("options", "fullscreenMode", global.fullscreenMode);
    ini_write_string("options", "fullscreenModeText", global.fullscreenModeText);   
    ini_write_string("options", "resolutionSizeFullScreenModeText", global.resolutionSizeFullScreenModeText);   
    ini_write_real("options", "enableRespawningEnemies", global.enableRespawningEnemies);   
    ini_write_string("options", "enableRespawningEnemiesText", global.enableRespawningEnemiesText);   
    ini_write_real("options", "linearInterpolation", global.linearInterpolation);   
    ini_write_string("options", "linearInterpolationText", global.linearInterpolationText);  
    ini_write_string("options", "nameTagOptionsText", global.nameTagOptionsText);  
    ini_write_real("options", "nameTagOptions", global.nameTagOptions);  
    ini_write_real("options", "nameTagRGBColour", global.nameTagRGBColour);
    ini_write_real("options", "antiAliasingFiltering", global.antiAliasingFiltering);
    ini_write_string("options", "antiAliasingFilteringText", global.antiAliasingFilteringText);
    ini_write_real("options", "aaBoundPosition", global.aaBoundPosition);
    ini_write_real("options", "vsync", global.vsync);
    ini_write_string("options", "vsyncText", global.vsyncText);
    ini_write_real("options", "rainDensityAmount", global.rainDensityAmount);
    ini_write_real("options", "coinParticlesAmount", global.coinParticlesAmount);

ini_close();

