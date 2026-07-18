//scr_call_input(x, y, id, max_string_length)

io_clear() //Clear input.

var posx, posy, o_id, max_s;

posx = argument0 //x of displayed input
posy = argument1 //y of displayed input
o_id = argument2 //which instance is calling it
max_s = argument3 //Max characters on the string
typeOfInput = argument4 //which input to use (I added this, so can have multiple)

var tmp = instance_create(posx, posy, typeOfInput); //We call the instance input

with(tmp) //We set its variable
{
    linked_object = o_id
    max_string = max_s
}
