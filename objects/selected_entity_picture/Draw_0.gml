/// @description Draw name, sprite, and health
if(!visible || !layer_get_visible(layer) || entity == noone) { return; }

draw_self();
draw_set_font(fnt_smalltext);
draw_set_halign(fa_center);
draw_sprite(entity.sprite_index, 1, x + sprite_width/2, y + sprite_height - 32);
draw_text_color(x + sprite_width/2, y + 16, entity.entity_data.name, c_black, c_black, c_black, c_black, 1);
draw_text_color(x + sprite_width/2, y + sprite_height - 34, string(entity.current_health) + "/" + string(entity.entity_data.max_health), c_black, c_black, c_black, c_black, 1);
draw_set_halign(fa_left);
