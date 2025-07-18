if(selected_entity_manager.currently_selected_entity != undefined) { //Draw range on the currently selected unit.
	with(selected_entity_manager.currently_selected_entity) {
		entity_data.range.draw_range();
	}
}

/// @description Draw tile highlights and grayscale unit on tiles without enemies
if(game_ui.get_highlighted_child() != undefined) { //Draw nothing else if you're hovering over a GUI component
	exit;
}


var _tile_at_mouse = instance_position(mouse_x, mouse_y, base_tile);
if(_tile_at_mouse == noone) { //No need to keep drawing if we don't have a tile
	exit;
}
		
var _highlight_color;

if(purchase_manager.currently_selected_purchase == undefined) { //If there's nothing to draw, don't bother
	_highlight_color = _tile_at_mouse.placeable ? c_white : c_red;
}
else {
	_highlight_color = can_purchase_unit(_tile_at_mouse, purchase_manager.currently_selected_purchase) ? c_white : c_red;
}

	
draw_set_alpha(0.25);
draw_rectangle_color(_tile_at_mouse.x, _tile_at_mouse.y, _tile_at_mouse.x + TILE_SIZE, _tile_at_mouse.y + TILE_SIZE,
	_highlight_color, _highlight_color, _highlight_color, _highlight_color, false);
draw_set_alpha(1);
draw_sprite(spr_tile_hover, 1, _tile_at_mouse.x, _tile_at_mouse.y)

//Draw the currently selected unit in grayscale
if(purchase_manager.currently_selected_purchase != undefined) {
	shader_set(shader_grayscale);
	draw_sprite(object_get_sprite(purchase_manager.currently_selected_purchase.unit), 0, 
		_tile_at_mouse.x + TILE_SIZE/2, _tile_at_mouse.y + TILE_SIZE);
	shader_reset();
}