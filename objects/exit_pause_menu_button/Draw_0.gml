/// @description Highlight if necessary
if(highlighted) {
	shader_set(shader_highlight);
}
draw_self();
shader_reset();