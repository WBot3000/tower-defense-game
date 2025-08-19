/// @description Draw unit health bar

draw_health_bar_target(x + sprite_width/2, y, current_health, entity_data.max_health);
if(instance_position(mouse_x, mouse_y, self.id)) {
	draw_set_halign(fa_center);
	draw_text_color(x + sprite_width/2, y - (sprite_get_height(spr_health_bar_target)*2), string(current_health) + "/" + string(entity_data.max_health), 
				c_black, c_black, c_black, c_black, 1);
	draw_set_halign(fa_left);
}
