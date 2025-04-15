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


#region get_bbox_center_x (Function)
//Get the horizontal center of an instance's bounding box
function get_bbox_center_x(inst) {
	return (inst.bbox_left + inst.bbox_right)/2
}
#endregion


#region get_bbox_center_y (Function)
//Get the vertical center of an instance's bounding box
function get_bbox_center_y(inst) {
	return (inst.bbox_top + inst.bbox_bottom)/2
}
#endregion


#region vector_to_get_components (Function)
//When referencing values returned from this function, use these values to make code more understandable
#macro VEC_X 0
#macro VEC_Y 1
#macro VEC_LEN 2
//Returns x and y components of a vector originating from source_inst, pointing towards destination_inst, along with the vector's length
function vector_to_get_components(source_inst, destination_inst, normalized = false) {
	var _vector_x = get_bbox_center_x(destination_inst) - get_bbox_center_x(source_inst);
	var _vector_y = get_bbox_center_y(destination_inst) - get_bbox_center_y(source_inst);
	var _vector_len = sqrt(sqr(_vector_x) + sqr(_vector_y));
	
	if(normalized) { //Set this when you want to use these components in a Step event for things like movement
		_vector_x = _vector_x / _vector_len;
		_vector_y = _vector_y / _vector_len;
	}
	
	return [_vector_x, _vector_y, _vector_len];
}
#endregion


#region get_entity_facing_direction (Function)
function get_entity_facing_direction(_entity, _x_coord) {
	return (_entity.x < _x_coord ? DIRECTION_RIGHT : DIRECTION_LEFT);
}
#endregion


