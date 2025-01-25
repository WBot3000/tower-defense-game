/*
	utility.gml
	This file contains additional functions that help out with specific computations and such.
	If a function doesn't "fit" in another script, then it's probably here.
*/


#region map_value (Function)
//Taken from https://forum.gamemaker.io/index.php?threads/map_value-remap-values-from-one-range-to-another.59699/
//Will probably write my own version eventually to break it down into more understandable pieces
//map a value from one range to another
function map_value(_value, _current_lower_bound, _current_upper_bound, _desired_lowered_bound, _desired_upper_bound) {
    return (((_value - _current_lower_bound) / (_current_upper_bound - _current_lower_bound)) * (_desired_upper_bound - _desired_lowered_bound)) + _desired_lowered_bound;
}
#endregion


#region number_is_between (Function)
//Used to determine whether one value is in between two other values.
//Not difficult to do, this is just to save screen space
//NOTE: This function is inclusive
function number_is_between(_num, _boundary1, _boundary2) {
	return (_boundary1 <= _num && _num <= _boundary2) || (_boundary2 <= _num && _num <= _boundary1)
}
#endregion


#region can_purchase_unit (Function)
//Used for determining if a unit can be placed on a certain tile
//TODO: Will probably move to a different file eventually
//TODO: Will need to account for player money once it's no longer a global variable
function can_purchase_unit(tile, purchase_data) {
	//Make sure tile can accept any units, and the unit is on the tile's approved list if it has one.
	return tile.placeable && tile.placed_unit == noone && global.player_money >= purchase_data.price && (array_length(tile.valid_units) == 0 || array_contains(tile.valid_units, purchase_data.unit));
}
#endregion