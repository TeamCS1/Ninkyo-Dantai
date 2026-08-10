/// draw_sprite_3d(sprite, subimg, xscale, yscale, x, y, z, xrot, yrot, zrot)

var sprite = argument[0];
var subimg = argument[1];
var xscale = argument[2];
var yscale = argument[3];
var xx = argument[4];
var yy = argument[5];
var zz = argument[6];
var xrot = argument[7];
var yrot = argument[8];
var zrot = argument[9];

var mat_default = matrix_get(matrix_world);

matrix_set(matrix_world,
    matrix_build(
        xx, yy, zz,
        xrot, yrot, zrot,
        xscale, yscale, 1
    )
);

draw_sprite(sprite, subimg, 0, 0);

matrix_set(matrix_world, mat_default);

