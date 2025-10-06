/// @description Draw button, labels, and appropriate stat icon
if(!visible || !layer_get_visible(layer) || entity == noone) { return; }

var _curr_stat_data = entity.stat_upgrades[stat_idx];

if(!enabled) {
	shader_set(shader_grayscale);
}
draw_self();
shader_reset();
if(_curr_stat_data == undefined) {
	draw_sprite(spr_locked_stat_icon, 1, x, y);
	return;
}
else {
	draw_sprite(_curr_stat_data.upgrade_spr, 1, x, y);
}

draw_set_font(fnt_smalltext);
draw_set_alignments(fa_right, fa_bottom)

if(_curr_stat_data.current_level >= _curr_stat_data.max_level) {
	draw_text_color(x + sprite_width*0.9,
				y + sprite_height - 4, "MAX", 
				c_white, c_white, c_white, c_white, 1);
}
else {
	draw_text_color(x + sprite_width*0.9,
				y + sprite_height - 4, _curr_stat_data.current_price, 
				c_white, c_white, c_white, c_white, 1);
}

//Draws stat level
draw_text_color(x + sprite_width*0.9,
	y + sprite_height/2 - 4,
	_curr_stat_data.current_level,
	c_white, c_white, c_white, c_white, 1);


draw_set_alignments();