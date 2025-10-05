/// @description Highlight if necessary
var _current_page_data = purchase_menu_base.purchase_list[purchase_menu_base.current_page];
if(array_length(_current_page_data) <= button_number) {
	image_alpha = 0;
	return;
}
var _current_purchase_data = _current_page_data[button_number];

if(highlighted) {
	shader_set(shader_highlight);
}
if(!enabled) {
	shader_set(shader_grayscale);
}
draw_self();
draw_sprite(object_get_sprite(_current_purchase_data.unit), 0, x + 8 + TILE_SIZE/2, y + 4 + TILE_SIZE);

draw_set_halign(fa_right);
draw_text(x + sprite_width - 8, y + 72, string(_current_purchase_data.price));
draw_set_halign(fa_left);

shader_reset();