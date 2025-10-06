/// @description Draw name, sprite, and health
if(!visible || !layer_get_visible(layer) || entity == noone) { return; }

if(highlighted) {
	shader_set(shader_highlight);
}

draw_self();

shader_reset();