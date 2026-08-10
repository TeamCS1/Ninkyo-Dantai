var namesReturn;

names = ds_list_create();

//A
ds_list_add(names, "Abbey");
ds_list_add(names, "Abbot");

//K
ds_list_add(names, "Kiryu");

//I
ds_list_add(names, "Ito");

//N
ds_list_add(names, "Nakamura");

//S
ds_list_add(names, "Sato");
ds_list_add(names, "Suzuki");

//T
ds_list_add(names, "Takahashi");
ds_list_add(names, "Tanaka");

//W
ds_list_add(names, "Watanabe");

//Y
ds_list_add(names, "Yamamoto");


//END OF NAMES!

ds_list_shuffle(names);

//stores result in temp variable
namesReturn = names[| irandom(ds_list_size(names)-1)];

//destroys the ds list
ds_list_destroy(names);

//returns the name
return namesReturn;
