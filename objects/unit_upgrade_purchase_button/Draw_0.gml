/// @description Highlight if necessary and draw icons
if(!visible || !layer_get_visible(layer) || entity == noone) { return; }

if(highlighted) {
	shader_set(shader_highlight);
}
if(!enabled) {
	shader_set(shader_grayscale);
}
draw_self();

var _upgrade_data = entity.unit_upgrades[upgrade_idx];
if(_upgrade_data == undefined) {
	shader_reset();
	return 
};

var _sprite = _upgrade_data.new_animbank.get_animation("DEFAULT");
draw_sprite(_sprite, 0, x + 8 + TILE_SIZE/2, y + 4 + TILE_SIZE);

draw_set_halign(fa_right);
draw_text(x + sprite_width - 8, y + 72, string(_upgrade_data.price));
draw_set_halign(fa_left);

shader_reset();