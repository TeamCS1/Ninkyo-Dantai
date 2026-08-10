///scr_MinimapMarkChecker(world_x, world_y, world_half_size, cell_world_size, colour_a, colour_b)
///Draws one blip as a two-tone checkerboard instead of a flat block.
///Fills the whole footprint in colour_a, then lays colour_b over
///alternating cells.
///
///cell_world_size is in WORLD pixels, not panel pixels, so the pattern
///keeps a fixed real-world size as the minimap zoom changes. Scenery
///tiles here are 256 world px, so 128 gives a 2x2 check per tile and 64
///gives 4x4.
///
///THE PHASE COMES FROM WORLD COORDINATES, not from each blip's own
///bounds. That matters: work it out per blip and every tile restarts the
///pattern at its own corner, so a row of alleyway tiles shows a seam at
///every join instead of one continuous checkerboard running across them.
///Deriving the parity from floor(worldPos / cell) makes neighbouring
///tiles line up automatically.
///
///Cost is one extra rectangle per filled cell, so keep cell_world_size a
///reasonable fraction of the footprint - 128 on a 256 tile is two extra
///rectangles, 16 would be 128 of them.

var _wx = argument0;
var _wy = argument1;
var _half = argument2;
var _cell = argument3;
var _colourA = argument4;
var _colourB = argument5;

var _left = _wx - _half;
var _top = _wy - _half;
var _right = _wx + _half;
var _bottom = _wy + _half;

// Base coat
scr_MinimapMarkRect(_left, _top, _right, _bottom, _colourA, false);

// Alternating cells on top
var _cx = floor(_left / _cell);
var _cxEnd = floor((_right - 0.001) / _cell);
var _cyStart = floor(_top / _cell);
var _cyEnd = floor((_bottom - 0.001) / _cell);

while (_cx <= _cxEnd)
{
    var _cy = _cyStart;

    while (_cy <= _cyEnd)
    {
        // != 0 rather than == 1: GML's mod keeps the sign of the
        // dividend, so a negative cell index gives -1 for odd
        if (((_cx + _cy) mod 2) != 0)
        {
            scr_MinimapMarkRect(max(_cx * _cell, _left),
                                max(_cy * _cell, _top),
                                min((_cx + 1) * _cell, _right),
                                min((_cy + 1) * _cell, _bottom),
                                _colourB, false);
        }

        _cy++;
    }

    _cx++;
}
