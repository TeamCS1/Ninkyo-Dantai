///scireal(string)
//
// converts a string to a real value, with scientific notation.
//
// string   number to convert to a real value, string
//
// scientific notation is used by adding an "e", such as "1.23652e-016".
//
/// GMLscripts.com/license

var var_e=0;
var var_work_value=string_lower(argument[0]);
var var_e_pos=string_pos('e',var_work_value);
if var_e_pos!=0 {
 var_e=real(string_copy(var_work_value,var_e_pos+1,string_length(var_work_value)-(var_e_pos+1)));
 var_work_value=real(string_delete(var_work_value,var_e_pos,string_length(var_work_value)-var_e_pos))*power(10,var_e);
}
else var_work_value=real(var_work_value);
return var_work_value;
