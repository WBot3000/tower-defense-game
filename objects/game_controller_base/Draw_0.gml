/// @description Draw grayscale unit on tiles without enemies

if(purchase_selected == undefined) { //If there's nothing to draw, don't bother
	exit;
}

/*
	Don't need to get the tile itself, since the same sprite will be drawn no matter what.
	
	NOTE: This MIGHT change as more functionality is added, so keep this in mind
*/

//These will give us values divisible by TILE_SIZE
var _nearest_tile_x = mouse_x - (mouse_x % TILE_SIZE);
var _nearest_tile_y = mouse_y - (mouse_y % TILE_SIZE);

//Draw the currently selected unit in grayscale
shader_set(shader_grayscale);
draw_sprite(object_get_sprite(purchase_selected.unit), 0, _nearest_tile_x, _nearest_tile_y);
shader_reset();