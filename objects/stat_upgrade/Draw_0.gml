/// @description Draw button, labels, and appropriate stat icon
if(!visible || !layer_get_visible(layer) || selected_entity_manager.currently_selected_entity == noone) { return; }

if(!enabled) {
	shader_set(shader_grayscale);
}
draw_self();
shader_reset();
if(current_stat_data == undefined) {
	draw_sprite(spr_locked_stat_icon, 1, x, y);
	return;
}
else {
	draw_sprite(current_stat_data.upgrade_spr, 1, x, y);
}

draw_set_font(fnt_smalltext);
draw_set_alignments(fa_right, fa_bottom)

if(current_stat_data.current_level >= current_stat_data.max_level) {
	draw_text_color(x + sprite_width*0.9,
				y + sprite_height - 4, "MAX", 
				c_white, c_white, c_white, c_white, 1);
}
else {
	draw_text_color(x + sprite_width*0.9,
				y + sprite_height - 4, current_stat_data.current_price, 
				c_white, c_white, c_white, c_white, 1);
}

//Draws stat level
draw_text_color(x + sprite_width*0.9,
	y + sprite_height/2 - 4,
	current_stat_data.current_level,
	c_white, c_white, c_white, c_white, 1);


draw_set_alignments();


/*
		if(_stat_upgrades[upgrade_idx] == undefined) {
			draw_sprite(spr_blank_stat_icon, 0, x_pos, y_pos);
			draw_sprite(spr_blank_stat_icon, 0, x_pos, y_pos - STAT_BUTTON_SIZE);
			return; //No drawing needed for a stat that doesn't exist
		}
		
		draw_sprite(_stat_upgrades[upgrade_idx].upgrade_spr, 0, x_pos, y_pos - STAT_BUTTON_SIZE);
		draw_stat_level(x_pos, y_pos - STAT_BUTTON_SIZE, _stat_upgrades[upgrade_idx].current_level);
		
		draw_set_alignments(fa_right, fa_bottom);
		if(_stat_upgrades[upgrade_idx].current_level >= _stat_upgrades[upgrade_idx].max_level) {
			draw_text_color(x_pos + sprite_get_width(button_sprite_default)*0.9,
				y_pos + sprite_get_height(_stat_upgrades[upgrade_idx].upgrade_spr) - 4, "MAX", 
				c_white, c_white, c_white, c_white, 1);
		}
		else {
			draw_text_color(x_pos + sprite_get_width(button_sprite_default)*0.9, 
				y_pos + sprite_get_height(_stat_upgrades[upgrade_idx].upgrade_spr) - 4, _stat_upgrades[upgrade_idx].current_price, 
				c_white, c_white, c_white, c_white, 1);
		}
		draw_set_alignments();
		*/