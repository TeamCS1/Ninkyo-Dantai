//draw_sprite_3d(sprite,subimg,xscale,yscale,x,y,z,xrot,yrot,zrot)

var sprite, subimg, xscale, yscale,z, xrot, yrot, zrot;

sprite = argument[0];
subimg = argument[1];
xscale = argument[2];
yscale = argument[3];
z = argument[6];
xrot = argument[7];
yrot = argument[8];
zrot = argument[9];

var default_mat = matrix_get(matrix_world);
matrix_set(matrix_world, matrix_build(x,y,z,xrot,yrot,-zrot, 1, 1, 1));
draw_sprite_ext(sprite,subimg,0,0,xscale,yscale,0,c_white,1);
matrix_set(matrix_world, default_mat);


