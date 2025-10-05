/// @description Highlight if necessary
draw_set_halign(fa_center);
draw_text_color(x + sprite_width/2, y - 24, label, c_white, c_white, c_white, c_white, 1);
draw_set_halign(fa_left);
if(highlighted) {
	shader_set(shader_highlight);
}
draw_self();
shader_reset();