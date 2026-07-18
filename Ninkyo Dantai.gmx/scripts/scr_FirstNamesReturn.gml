var namesReturn;

names = ds_list_create();


//A
ds_list_add(names, "Aoi");
ds_list_add(names, "Aoto");
ds_list_add(names, "Akita");

//B

//C

//K
ds_list_add(names, "Kenji");
ds_list_add(names, "Kenzo");

//H
ds_list_add(names, "Haruto");
ds_list_add(names, "Hinata");
ds_list_add(names, "Honma");

//I

//J

//K
ds_list_add(names, "Kamei");
ds_list_add(names, "Kubo");

//L

//M
ds_list_add(names, "Minato");
ds_list_add(names, "Mori");

//N
ds_list_add(names, "Nakatani");
ds_list_add(names, "Nitta");
ds_list_add(names, "Nozawa");
//O
ds_list_add(names, "Osada");

//R
ds_list_add(names, "Riku");

//S
ds_list_add(names, "Shintani");
ds_list_add(names, "Sonoda");

//T
ds_list_add(names, "Tani");
//U

//V

//X

//Y
ds_list_add(names, "Yoshii");

//Z

//ds_list_add(names, " ");

//END OF NAMES!

ds_list_shuffle(names);

//stores result in temp variable
namesReturn = names[| irandom(ds_list_size(names)-1)];

//destroys the ds list
ds_list_destroy(names);

//returns the name
return namesReturn;
