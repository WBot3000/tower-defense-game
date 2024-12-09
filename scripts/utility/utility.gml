/*
	This file contains additional functions that help out with specific computations and such.
	If a function doesn't "fit" in another script, then it's probably here.
*/

//Taken from https://forum.gamemaker.io/index.php?threads/map_value-remap-values-from-one-range-to-another.59699/
//map a value from one range to another
function map_value(_value, _current_lower_bound, _current_upper_bound, _desired_lowered_bound, _desired_upper_bound) {
    return (((_value - _current_lower_bound) / (_current_upper_bound - _current_lower_bound)) * (_desired_upper_bound - _desired_lowered_bound)) + _desired_lowered_bound;
}

//Used to determine whether one value is in between two other values.
//Not difficult to do, this is just to save screen space
//NOTE: This function is inclusive
function number_is_between(_num, _boundary1, _boundary2) {
	return (_boundary1 <= _num && _num <= _boundary2) || (_boundary2 <= _num && _num <= _boundary1)
}