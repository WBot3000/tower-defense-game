/// @description Highlight if necessary
if(highlighted) {
	shader_set(shader_highlight);
}
draw_self();
draw_set_font(fnt_smalltext);
draw_text_color(x + 16, y + 12, label, c_white, c_white, c_white, c_white, 1);
shader_reset();