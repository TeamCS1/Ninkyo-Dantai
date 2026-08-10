///obj_to_model(obj_data,mtl_data)
// 
// Converts OBJ and optional MTL data to a model.
// 
// obj_data   The contents of an entire OBJ file, string.
// mtl_data   The contents of an entire MTL file, string.
// 
// Supports diffuse color.
// Textures are not supported, but UV mapping is maintained.
// Requires a script called "scireal".
// 
/// GMLscripts.com/license

/*
Supported OBJ Calls:
v vt vn f usemtl
Supported MTL Calls:
Kd
*/

var var_done, var_ii_pos;

var var_work_string_a1=argument[0];
var var_work_string_b1='null_data';
if argument_count>1 var_work_string_b1=argument[1];

// remove carrage return charactors, and add a newline at the end.
var_work_string_a1=string_replace(var_work_string_a1,chr(10)+chr(12),chr(10));
var_work_string_a1=string_replace(var_work_string_a1,chr(12),chr(10))+chr(10);

if var_work_string_b1!='null_data' {
 var_work_string_b1=string_replace(var_work_string_b1,chr(10)+chr(12),chr(10));
 var_work_string_b1=string_replace(var_work_string_b1,chr(12),chr(10))+chr(10);
}

var var_total_faces=string_count('f ',var_work_string_a1)

dsg_v=ds_grid_create(3,var_total_faces*3);
current_v=0;
dsg_vt=ds_grid_create(2,var_total_faces*2);
current_vt=0;
dsg_vn=ds_grid_create(3,var_total_faces*3);
current_vn=0
dsg_f=ds_grid_create(10,var_total_faces);
current_f=0;
var dsm_mtl=ds_map_create();

var current_mtl='null_material';
var_done=0;
var var_start_pos=1;
var var_end_pos=string_pos(chr(10),var_work_string_a1);
if var_end_pos=0 var_end_pos=string_length(var_work_string_a1);
var var_work_string_a2=string_copy(var_work_string_a1,var_start_pos,(var_end_pos-var_start_pos)-1);
while string_char_at(var_work_string_a2,1)=' ' {
 var_work_string_a2=string_delete(var_work_string_a2,1,1)
}
while var_done<=1 { // convert obj string to model data (in ds_grids)
 if string_pos("v ",var_work_string_a2)=1 {
  var_work_string_a2=string_delete(var_work_string_a2,1,2)
  var_ii_pos=string_pos(" ",var_work_string_a2);
  ds_grid_set(dsg_v,0,current_v,scireal(string_copy(var_work_string_a2,1,var_ii_pos-1)));
  var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
  var_ii_pos=string_pos(" ",var_work_string_a2);
  ds_grid_set(dsg_v,1,current_v,scireal(string_copy(var_work_string_a2,1,var_ii_pos-1)));
  var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
  ds_grid_set(dsg_v,2,current_v,scireal(var_work_string_a2));
  current_v+=1;
 }
 if string_pos("vt ",var_work_string_a2)=1 {
  var_work_string_a2=string_delete(var_work_string_a2,1,3)
  var_ii_pos=string_pos(" ",var_work_string_a2);
  ds_grid_set(dsg_vt,0,current_vt,scireal(string_copy(var_work_string_a2,1,var_ii_pos-1)));
  var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
  ds_grid_set(dsg_vt,1,current_vt,scireal(var_work_string_a2));
  current_vt+=1;
 }
 if string_pos("vn ",var_work_string_a2)=1 {
  var_work_string_a2=string_delete(var_work_string_a2,1,3)
  var_ii_pos=string_pos(" ",var_work_string_a2);
  ds_grid_set(dsg_vn,0,current_vn,scireal(string_copy(var_work_string_a2,1,var_ii_pos-1)));
  var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
  var_ii_pos=string_pos(" ",var_work_string_a2);
  ds_grid_set(dsg_vn,1,current_vn,scireal(string_copy(var_work_string_a2,1,var_ii_pos-1)));
  var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
  ds_grid_set(dsg_vn,2,current_vn,scireal(var_work_string_a2));
  current_vn+=1;
 }
 if string_pos("f ",var_work_string_a2)=1 {
  var_work_string_a2=string_delete(var_work_string_a2,1,2)
  var var_slash_count=string_count("/",var_work_string_a2)
  var var_ii1, var_ii2, var_ii3, var_ii4, var_ii5, var_ii6, var_ii7, var_ii8, var_ii9;
  if var_slash_count=0 {
   var_ii_pos=string_pos(" ",var_work_string_a2)
   var_ii1=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii_pos=string_pos(" ",var_work_string_a2)
   var_ii3=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii6=scireal(var_work_string_a2)
  }
  if var_slash_count=3 {
   var_ii_pos=string_pos("/",var_work_string_a2)
   var_ii1=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii_pos=string_pos(" ",var_work_string_a2)
   var_ii2=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii_pos=string_pos("/",var_work_string_a2)
   var_ii4=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii_pos=string_pos(" ",var_work_string_a2)
   var_ii5=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii_pos=string_pos("/",var_work_string_a2)
   var_ii7=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii8=scireal(var_work_string_a2)
  }
  if var_slash_count=6 {
   var_ii_pos=string_pos("/",var_work_string_a2)
   var_ii1=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii_pos=string_pos("/",var_work_string_a2)
   var_ii2=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii_pos=string_pos(" ",var_work_string_a2)
   var_ii3=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii_pos=string_pos("/",var_work_string_a2)
   var_ii4=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii_pos=string_pos("/",var_work_string_a2)
   var_ii5=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii_pos=string_pos(" ",var_work_string_a2)
   var_ii6=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii_pos=string_pos("/",var_work_string_a2)
   var_ii7=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii_pos=string_pos("/",var_work_string_a2)
   var_ii8=scireal(string_copy(var_work_string_a2,1,var_ii_pos-1));
   var_work_string_a2=string_delete(var_work_string_a2,1,var_ii_pos)
   var_ii9=scireal(var_work_string_a2)
  }
  ds_grid_set(dsg_f,0,current_f,var_ii1);
  ds_grid_set(dsg_f,1,current_f,var_ii2);
  ds_grid_set(dsg_f,2,current_f,var_ii3);
  ds_grid_set(dsg_f,3,current_f,var_ii4);
  ds_grid_set(dsg_f,4,current_f,var_ii5);
  ds_grid_set(dsg_f,5,current_f,var_ii6);
  ds_grid_set(dsg_f,6,current_f,var_ii7);
  ds_grid_set(dsg_f,7,current_f,var_ii8);
  ds_grid_set(dsg_f,8,current_f,var_ii9);
  ds_grid_set(dsg_f,9,current_f,current_mtl);
  current_f+=1;
 }
 if string_pos("usemtl ",var_work_string_a2)=1 {
  current_mtl=string_delete(var_work_string_a2,1,7)
 }
 var_work_string_a1=string_delete(var_work_string_a1,1,var_end_pos)
 var_end_pos=string_pos(chr(10),var_work_string_a1);
 if var_done=1 {
  var_done=2;
  var_total_faces=current_f;
 }
 if var_end_pos=0 and var_done=0 {
  var_end_pos=string_length(var_work_string_a1);
  var_done=1;
 }
 else {
  var_work_string_a2=string_copy(var_work_string_a1,var_start_pos,(var_end_pos-var_start_pos)-1);
  while string_char_at(var_work_string_a2,1)=' ' {
   var_work_string_a2=string_delete(var_work_string_a2,1,1)
  }
 }
}

if var_work_string_b1!='null_data' { // get material data
 var_done=0;
 current_mtl='invalid_material';
 var var_start_pos=1;
 var var_end_pos=string_pos(chr(10),var_work_string_b1);
 if var_end_pos=0 var_end_pos=string_length(var_work_string_b1);
 var var_work_string_b2=string_copy(var_work_string_b1,var_start_pos,(var_end_pos-var_start_pos)-1);
 while string_char_at(var_work_string_b2,1)=' ' {
  var_work_string_b2=string_delete(var_work_string_b2,1,1)
 }
 while var_done<=1 { // convert mtl string to material data (in ds_grids)
  if string_pos("newmtl ",var_work_string_b2)=1 {
   current_mtl=string_delete(var_work_string_b2,1,7);
  }
  if string_pos("Kd ",var_work_string_b2)=1 { // color
   var_work_string_b2=string_delete(var_work_string_b2,1,3)
   var_ii_pos=string_pos(" ",var_work_string_b2)
   var_ii1=scireal(string_copy(var_work_string_b2,1,var_ii_pos-1)); // R
   var_work_string_b2=string_delete(var_work_string_b2,1,var_ii_pos)
   var_ii_pos=string_pos(" ",var_work_string_b2)
   var_ii2=scireal(string_copy(var_work_string_b2,1,var_ii_pos-1)); // G
   var_work_string_b2=string_delete(var_work_string_b2,1,var_ii_pos)
   var_ii3=scireal(var_work_string_b2); // B
   ds_map_replace(dsm_mtl,'Kd_'+current_mtl,make_colour_rgb(var_ii1*255,var_ii2*255,var_ii3*255));
  }
  var_work_string_b1=string_delete(var_work_string_b1,1,var_end_pos)
  var_end_pos=string_pos(chr(10),var_work_string_b1);
  if var_done=1 var_done=2;
  if var_end_pos=0 and var_done=0 {
   var_end_pos=string_length(var_work_string_b1);
   var_done=1;
  }
  else {
   var_work_string_b2=string_copy(var_work_string_b1,var_start_pos,(var_end_pos-var_start_pos)-1);
   while string_char_at(var_work_string_b2,1)=' ' {
    var_work_string_b2=string_delete(var_work_string_b2,1,1)
   }
  }
 }
}

// convert collected data to model

var var_current_face=0;
var current_vertex=0;
var current_normal=0;
var current_texture=0;
var var_color_value='null_material';
var current_model_gm_index=d3d_model_create();
d3d_model_primitive_begin(current_model_gm_index,pr_trianglelist)
 while var_current_face<var_total_faces {
  var_color_value=ds_map_find_value(dsm_mtl,'Kd_'+ds_grid_get(dsg_f,9,var_current_face))
  if var_color_value=undefined var_color_value=c_white;
  var_current_vertex=ds_grid_get(dsg_f,0,var_current_face)-1
  var_current_texture=ds_grid_get(dsg_f,1,var_current_face)-1
  var_current_normal=ds_grid_get(dsg_f,2,var_current_face)-1
  d3d_model_vertex_normal_texture_colour
   (current_model_gm_index
   ,ds_grid_get(dsg_v,0,var_current_vertex)
   ,ds_grid_get(dsg_v,1,var_current_vertex)
   ,ds_grid_get(dsg_v,2,var_current_vertex)
   ,ds_grid_get(dsg_vn,0,var_current_normal)
   ,ds_grid_get(dsg_vn,1,var_current_normal)
   ,ds_grid_get(dsg_vn,2,var_current_normal)
   ,ds_grid_get(dsg_vt,0,var_current_texture)
   ,ds_grid_get(dsg_vt,1,var_current_texture)
   ,var_color_value
   ,1
  )
  // // //
  var_current_vertex=ds_grid_get(dsg_f,3,var_current_face)-1
  var_current_texture=ds_grid_get(dsg_f,4,var_current_face)-1
  var_current_normal=ds_grid_get(dsg_f,5,var_current_face)-1
  d3d_model_vertex_normal_texture_colour
   (current_model_gm_index
   ,ds_grid_get(dsg_v,0,var_current_vertex)
   ,ds_grid_get(dsg_v,1,var_current_vertex)
   ,ds_grid_get(dsg_v,2,var_current_vertex)
   ,ds_grid_get(dsg_vn,0,var_current_normal)
   ,ds_grid_get(dsg_vn,1,var_current_normal)
   ,ds_grid_get(dsg_vn,2,var_current_normal)
   ,ds_grid_get(dsg_vt,0,var_current_texture)
   ,ds_grid_get(dsg_vt,1,var_current_texture)
   ,var_color_value
   ,1
  )
  // // //
  var_current_vertex=ds_grid_get(dsg_f,6,var_current_face)-1
  var_current_texture=ds_grid_get(dsg_f,7,var_current_face)-1
  var_current_normal=ds_grid_get(dsg_f,8,var_current_face)-1
  d3d_model_vertex_normal_texture_colour
   (current_model_gm_index
   ,ds_grid_get(dsg_v,0,var_current_vertex)
   ,ds_grid_get(dsg_v,1,var_current_vertex)
   ,ds_grid_get(dsg_v,2,var_current_vertex)
   ,ds_grid_get(dsg_vn,0,var_current_normal)
   ,ds_grid_get(dsg_vn,1,var_current_normal)
   ,ds_grid_get(dsg_vn,2,var_current_normal)
   ,ds_grid_get(dsg_vt,0,var_current_texture)
   ,ds_grid_get(dsg_vt,1,var_current_texture)
   ,var_color_value
   ,1
  )
  var_current_face+=1;
 }
d3d_model_primitive_end(current_model_gm_index);

ds_grid_destroy(dsg_v);
ds_grid_destroy(dsg_vt);
ds_grid_destroy(dsg_vn);
ds_grid_destroy(dsg_f);
ds_map_destroy(dsm_mtl);

return current_model_gm_index;
