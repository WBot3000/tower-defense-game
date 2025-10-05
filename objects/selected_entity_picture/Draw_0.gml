/// @description Draw name, sprite, and health
if(!visible || !layer_get_visible(layer) || selected_entity_manager.currently_selected_entity == noone) { return; }
var _entity = selected_entity_manager.currently_selected_entity;

draw_self();
draw_set_font(fnt_smalltext);
draw_set_halign(fa_center);
draw_sprite(_entity.sprite_index, 1, x + sprite_width/2, y + sprite_height - 32);
draw_text_color(x + sprite_width/2, y + 16, _entity.entity_data.name, c_black, c_black, c_black, c_black, 1);
draw_text_color(x + sprite_width/2, y + sprite_height - 34, string(_entity.current_health) + "/" + string(_entity.entity_data.max_health), c_black, c_black, c_black, c_black, 1);
draw_set_halign(fa_left);
