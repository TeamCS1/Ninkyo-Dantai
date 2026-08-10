/// scr_center_text_on_button(str, padding)
//  str text    string
//  padding integer    real
var str = string(argument0);

var textCenterX = string_width(argument0) /2;
var textCenterY = string_height(argument0) / 2;
var buttonCenterX = sprite_width / 2;
var buttonCenterY = sprite_height / 2;
var paddingY = real(argument1);

draw_text_transformed((x + buttonCenterX - textCenterX) , (y + buttonCenterY - textCenterY + paddingY), string(str),1,1,0);
return(0);
