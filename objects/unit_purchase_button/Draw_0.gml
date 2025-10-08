/// @description Highlight if necessary
if(current_purchase_data == undefined) { return; }

if(highlighted) {
	shader_set(shader_highlight);
}
if(!enabled) {
	shader_set(shader_grayscale);
}
draw_self();
draw_sprite(object_get_sprite(current_purchase_data.unit), 0, x + 8 + TILE_SIZE/2, y + 4 + TILE_SIZE);

draw_set_halign(fa_right);
draw_text(x + sprite_width - 8, y + 72, string(current_purchase_data.price));
draw_set_halign(fa_left);

shader_reset();