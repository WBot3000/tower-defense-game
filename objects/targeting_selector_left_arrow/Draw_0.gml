/// @description Draw name, sprite, and health
if(!visible || !layer_get_visible(layer) || entity == noone ||
	!variable_instance_exists(entity, "targeting_tracker")) { return; }

if(highlighted) {
	shader_set(shader_highlight);
}

draw_self();

shader_reset();