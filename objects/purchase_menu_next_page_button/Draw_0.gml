/// @description Highlight if necessary
if(highlighted) {
	shader_set(shader_highlight);
}
if(!enabled) {
	shader_set(shader_grayscale);
}
draw_self();
shader_reset();