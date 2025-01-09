/// @description Place a unit if one isn't placed already

//TODO: Honestly can probably move this to the step event too

/*
	Make sure that:
	1) Another unit isn't already on this tile
	2) The player has enough money
	3) The unit is allowed to be placed on this tile
*/ 

/*
	You shouldn't be able to place units behind the open menu
	Unlike the previous solution, this DOES allow you to place units while the menu was open, just not on tiles completely under the menu.
	Because the menu's x position is based on the viewport and not the room, the viewport's current position must be added to the menu's x position, otherwise the player won't be able to place things on the right of the room
*/
/*
if(game_ui.purchase_menu.x_pos_current + camera_get_view_x(view_camera[0]) <= mouse_x) {
	exit;
}

//Can't purchase anything if nothing is selected
if(purchase_selected == undefined) {
	exit;
}

var _tile_at_mouse = instance_position(mouse_x, mouse_y, placeable_tile);
if(_tile_at_mouse == noone) {
	exit;
}
with(_tile_at_mouse) {

	var _purchase = other.purchase_selected;
	if(placed_unit == noone && global.player_money >= _purchase.price && (array_length(valid_units) == 0 || array_contains(valid_units, _purchase.unit))) {
		placed_unit = instance_create_layer(x, y, UNIT_LAYER, _purchase.unit);
		global.player_money -= _purchase.price
		highlight = noone; //Can get rid of the highlight on the tile once it's placed
	}
}
*/