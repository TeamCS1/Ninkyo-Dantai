// Save timescale before pausing so we can restore it correctly
if (argument[0] == 0) {
    global.timescaleSaved = global.timescale;
}
global.timescale = argument[0];
global.timescaleDivide = argument[1];
