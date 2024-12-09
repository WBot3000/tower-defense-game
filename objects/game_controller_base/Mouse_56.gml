/// @description Place a unit if one isn't placed already

//Honestly can probably move this to the step event too

/*
	Make sure that:
	1) Another unit isn't already on this tile
	2) The player has enough money
	3) The unit is allowed to be placed on this tile
*/ 

//To prevent selection issues, if the unit purchase menu is open, just disable placement for now.
//Will eventually work out a more elegant solution later
if(purchase_menu_state != PURCHASE_MENU_STATE.CLOSED) {
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
with(_tile_at_mouse) { //TODO: Need to get unit data from an external source to get unit price
	/*
	if(placed_unit == noone && global.player_money >= 100 && (array_length(valid_units) == 0 || array_contains(valid_units, unit_picked))) {
		placed_unit = instance_create_layer(x, y, UNIT_LAYER, other.unit_picked);
		global.player_money -= 100//_selected_unit.unit_price;
		highlight = noone; //Can get rid of the highlight on the tile once it's placed
	}
	*/
	var _purchase = other.purchase_selected;
	if(placed_unit == noone && global.player_money >= _purchase.price && (array_length(valid_units) == 0 || array_contains(valid_units, _purchase.unit))) {
		placed_unit = instance_create_layer(x, y, UNIT_LAYER, _purchase.unit);
		global.player_money -= _purchase.price//_selected_unit.unit_price;
		highlight = noone; //Can get rid of the highlight on the tile once it's placed
	}
}