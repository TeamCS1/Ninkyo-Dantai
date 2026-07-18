//argument0 = name of the model

//returns the model
var t_model;
t_model = d3d_model_create();
d3d_model_load( t_model, argument0 );
return t_model;
