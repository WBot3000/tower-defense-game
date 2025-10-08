/// @description Draw tile highlights and grayscale unit on tiles without enemies (and pause screen if needed)

if(global.PAUSE_SCREEN != -1) {
	draw_sprite(global.PAUSE_SCREEN, 0, camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]));
}


if(game_state_manager.state != GAME_STATE.RUNNING) {
	return; //Don't need to draw anything else here if the game is paused
}

if(selected_entity_manager.currently_selected_entity != undefined) { //Draw range on the currently selected unit.
	with(selected_entity_manager.currently_selected_entity) {
		entity_data.sight_range.draw_range();
	}
}


//If the mouse is over any UI elements, don't draw any placement graphics
//NOTE: For some reason, the instance_position function wasn't working properly for this (which is why all this code is here). Probably some UI-layer stuff going on.
if(currently_highlighted_ui_elem != noone) {
	return;
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