ini_open("configs.ini");

    global.roomBeforePrevious = ini_read_real("options", "roomBeforePrevious", 0)
    global.fullscreenMode = ini_read_real("options", "fullscreenMode", 0)
    global.fullscreenModeText = ini_read_string("options", "fullscreenModeText", 0)
    global.resolutionSizeFullScreenModeText = ini_read_string("options", "resolutionSizeFullScreenModeText", 0)
    global.enableRespawningEnemies = ini_read_real("options", "enableRespawningEnemies", 0)
    global.enableRespawningEnemiesText = ini_read_string("options", "enableRespawningEnemiesText", 0)
    global.linearInterpolation = ini_read_real("options", "linearInterpolation", 0)
    global.linearInterpolationText = ini_read_string("options", "linearInterpolationText", 0)
    global.nameTagOptionsText = ini_read_string("options", "nameTagOptionsText", 0)
    global.nameTagOptions = ini_read_real("options", "nameTagOptions", 0)
    global.nameTagRGBColour = ini_read_real("options", "nameTagRGBColour", 0)
    global.antiAliasingFiltering = ini_read_real("options", "antiAliasingFiltering", 0)
    global.antiAliasingFilteringText = ini_read_string("options", "antiAliasingFilteringText", 0)
    global.aaBoundPosition = ini_read_real("options", "aaBoundPosition", 0)
    global.vsync = ini_read_real("options", "vsync", 0)
    global.vsyncText = ini_read_string("options", "vsyncText", 0)
    global.rainDensityAmount = ini_read_real("options", "rainDensityAmount", 0)
    global.coinParticlesAmount = ini_read_real("options", "coinParticlesAmount", 0)

    ini_close();

