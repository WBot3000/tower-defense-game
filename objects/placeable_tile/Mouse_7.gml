/// @description Place a unit if one isn't placed already
// You can write your code in this editor

//Place a unit if it isn't placed already
//TODO: Change based off of enemy placed

/*
	Make sure that:
	1) Another unit isn't already on this tile
	2) The player has enough money
	3) The unit is allowed to be placed on this tile
*/
/*
if(placed_unit == noone && global.player_money >= 100 && (array_length(valid_units) == 0 || array_contains(valid_units, sample_gunner))) {
	placed_unit = instance_create_layer(x, y, UNIT_LAYER, sample_gunner);
	global.player_money -= 100//_selected_unit.unit_price;
	highlight = noone; //Can get rid of the highlight on the tile once it's placed
}
*/

//All this logic was moved to the game controller