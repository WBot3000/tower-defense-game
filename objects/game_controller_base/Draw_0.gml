/// @description Draw tile highlights and grayscale unit on tiles without enemies
if(game_ui.is_cursor_on_gui()) { //Draw nothing if you're hovering over a GUI component
	exit;
}

var _tile_at_mouse = instance_position(mouse_x, mouse_y, base_tile);
if(_tile_at_mouse == noone) { //No need to keep drawing if we don't have a tile
	exit;
}
		
var _highlight_color;

if(purchase_selected == undefined) { //If there's nothing to draw, don't bother
	_highlight_color = _tile_at_mouse.placeable ? c_white : c_red;
	draw_set_alpha(0.25);
	draw_rectangle_color(_tile_at_mouse.x, _tile_at_mouse.y, _tile_at_mouse.x + TILE_SIZE, _tile_at_mouse.y + TILE_SIZE,
		_highlight_color, _highlight_color, _highlight_color, _highlight_color, false);
	draw_set_alpha(1);
	exit;
}
else {
	_highlight_color = can_purchase_unit(_tile_at_mouse, purchase_selected) ? c_white : c_red;
	draw_set_alpha(0.25);
	draw_rectangle_color(_tile_at_mouse.x, _tile_at_mouse.y, _tile_at_mouse.x + TILE_SIZE, _tile_at_mouse.y + TILE_SIZE,
		_highlight_color, _highlight_color, _highlight_color, _highlight_color, false);
	draw_set_alpha(1);
}

/*
	Don't need to get the tile itself, since the same sprite will be drawn no matter what.
	
	NOTE: This MIGHT change as more functionality is added, so keep this in mind
*/
//These will give us values divisible by TILE_SIZE

/*
var _nearest_tile_x = mouse_x - (mouse_x % TILE_SIZE);
var _nearest_tile_y = mouse_y - (mouse_y % TILE_SIZE);*/

//Draw the currently selected unit in grayscale
shader_set(shader_grayscale);
draw_sprite(object_get_sprite(purchase_selected.unit), 0, _tile_at_mouse.x, _tile_at_mouse.y);
shader_reset();