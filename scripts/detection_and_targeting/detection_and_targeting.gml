/*
	detection_and_targeting.gml
	
	This file contains structs and functions relating to how units target enemies, including
	- Detection ranges, used for things like:
		-Unit attack range
		-Persistent projectile damage range
	- Unit targeting functions
*/


#region Ranges

#region Range (Class)
/*
	Base "range" from which all other ranges can derive from. Largely used as an interface.
	unit: the id of the unit object that uses this range
*/
function Range(_unit) constructor {
	unit = _unit;
	
	static draw_range = function(){};
	static get_entities_in_range = function(){};
	static move_range = function(){};
}
#endregion


#region CircularRange (Class)
/*
	For units with a circular viewing range (think most towers from Bloons Tower Defense 6)
	origin_x: x-coordinate of the circle's origin
	origin_y: y-coordinate of the circle's origin
	radius: How far the unit can "see"
*/
function CircularRange(_unit, _origin_x, _origin_y, _radius) : Range(_unit) constructor {
	origin_x = _origin_x;
	origin_y = _origin_y;
	radius = _radius;
	
	static draw_range = function() {
		draw_set_alpha(0.125)
		draw_circle_color(origin_x, origin_y, radius, c_white, c_white, false);
		draw_set_alpha(1)
	}
	
	/*
		Detect...
		All of a certain type of entity (obj = _entity_type)
		Within it's radius (first three arguments)
		Using boundary boxes for speed increase (prec = false)
		While not targeting yourself (notme = true)
	*/
	static get_entities_in_range = function(_entity_type, _storage_list, _ordered) {
		collision_circle_list(origin_x, origin_y, radius, _entity_type, false, true, _storage_list, _ordered);
	}
	
	/*
		In the event you want to move a range. Can also be used to resize the range, though that's not required.
		_new_origin_x: Where the origin of the CircularRange should move to on the x-axis.
		_new_origin_y: Where the origin of the CircularRange should move to on the y-axis.
	*/
	static move_range = function(_new_origin_x, _new_origin_y, _new_radius = radius) {
		origin_x = _new_origin_x;
		origin_y = _new_origin_y;
		radius = _new_radius;
	}
}
#endregion


#region RectangularRange (Class)
/*
	For units with a rectangular viewing range (mostly for specialty towers, not very common)
	x1: x-coordinate of the rectangle's top-left
	y1: y-coordinate of the rectangle's top-left
	x2: x-coordinate of the rectangle's bottom-right
	y2: y-coordinate of the rectangle's bottom-right
*/
function RectangularRange(_unit, _x1, _y1, _x2, _y2) : Range(_unit) constructor {
	x1 = _x1;
	y1 = _y1;
	x2 = _x2;
	y2 = _y2;
	
	static draw_range = function() {
		draw_set_alpha(0.125)
		draw_rectangle_color(x1, y1, x2, y2, c_white, c_white, c_white, c_white, false);
		draw_set_alpha(1)
	}
	
	/*
		Detect...
		All of a certain type of entity (obj = _entity_type)
		Within it's radius (first three arguments)
		Using boundary boxes for speed increase (prec = false)
		While not targeting yourself (notme = true)
	*/
	static get_entities_in_range = function(_entity_type, _storage_list, _ordered) {
		collision_rectangle_list(x1, y1, x2, y2, _entity_type, false, true, _storage_list, _ordered);
	}
	
	/*
		In the event you want to move a range. Can also be used to resize the range, though that's not required.
		_new_x1: Where the x-coordinate of the RectangularRange's left is.
		_new_y1: Where the y-coordinate of the RectangularRange's top is.
		_new_x2: Where the x-coordinate of the RectangularRange's right is.
		_new_y2: Where the y-coordinate of the RectangularRange's bottom is.
	*/
	static move_range = function(_new_x1, _new_y1, _new_x2 = x2 - x1 + _new_x1, _new_y2 = y2 - y1 + _new_y1) {
		x1 = _new_x1;
		y1 = _new_y1;
		x2 = _new_x2;
		y2 = _new_y2;
	}
}
#endregion


/*
	The following ranges are used for specific types of entities.
*/


#region MeleeRange (Class)
/*
	A Circular Range that's used for units/enemies that attack up close.
	ex) Cobblestone Construct, Sword Beetle
	
	In order to accomodate for melee units having different bounding boxes, the radius is proportional to said bounding box
	If you give all melee units the same range radius, then you have situations where the larger melee unit can't reach the smaller one.
*/
function MeleeRange(_unit) : CircularRange(_unit) constructor {
	origin_x = get_bbox_center_x(_unit);
	origin_y = get_bbox_center_y(_unit);
	radius = max((_unit.bbox_right - _unit.bbox_left)/2, (_unit.bbox_bottom - _unit.bbox_top)/2) * 1.5; //So that melee units have just a bit more range.
}
#endregion

#endregion


#region Unit Targeting


#region target_close (Function)
/*
	Given an enemy list, selects the enemy closest to the unit. Can pass if the list has already been ordered to prevent the linear search.
*/
function target_close(_unit, _enemy_list, _list_is_ordered = false) {
	if(ds_list_empty(_enemy_list)) {
		return noone;
	}
	if(_list_is_ordered) {
		return _enemy_list[| 0];
	}
	var _closest_enemy = _enemy_list[| 0];
	var _closest_distance = sqrt(sqr(_unit.x - _closest_enemy.x) + sqr(_unit.y - _closest_enemy.y));
	for(var i = 1; i < ds_list_size(_enemy_list); ++i) {
		var _enemy = _enemy_list[| i];
		var _distance = sqrt(sqr(_unit.x - _enemy.x) + sqr(_unit.y - _enemy.y));
		if(_distance < _closest_distance) {
			_closest_distance = _distance;
			_closest_enemy = _enemy;
		}
	}
	return _closest_enemy;
}
#endregion


#region target_first (Function)
/*
	Given an enemy list, selects the enemy closest to the wall.
	Currently only takes into account enemies that have paths.
*/
function target_first(_unit, _enemy_list) {
	if(ds_list_empty(_enemy_list)) {
		return noone;
	}
	var _most_ahead_enemy = _enemy_list[| 0];
	var _most_ahead_percentage = 0;
	if(_most_ahead_enemy.path_index != -1 && _most_ahead_enemy.path_index != pth_dummypath) {
		_most_ahead_percentage = _most_ahead_enemy.path_position;
	}
	for(var i = 1; i < ds_list_size(_enemy_list); ++i) {
		var _enemy = _enemy_list[| i];
		var _ahead_percentage = 0;
		if(_enemy.path_index != -1 && _enemy.path_index != pth_dummypath) {
			_ahead_percentage = _enemy.path_position;
		}
		if(_ahead_percentage > _most_ahead_percentage) {
			_most_ahead_enemy = _enemy;
			_most_ahead_percentage = _ahead_percentage;
		}
	}
	return _most_ahead_enemy;
}
#endregion


#region target_last (Function)
/*
	Given an enemy list, selects the enemy furthest from the wall.
	Currently only takes into account enemies that have paths.
*/
function target_last(_unit, _enemy_list) {
	if(ds_list_empty(_enemy_list)) {
		return noone;
	}
	var _most_behind_enemy = _enemy_list[| 0];
	var _most_behind_percentage = 1;
	if(_most_behind_enemy.path_index != -1 && _most_behind_enemy.path_index != pth_dummypath) {
		_most_behind_percentage = _most_behind_enemy.path_position;
	}
	for(var i = 1; i < ds_list_size(_enemy_list); ++i) {
		var _enemy = _enemy_list[| i];
		var _behind_percentage = 1;
		if(_enemy.path_index != -1 && _enemy.path_index != pth_dummypath) {
			_behind_percentage = _enemy.path_position;
		}
		if(_behind_percentage < _most_behind_percentage) {
			_most_behind_enemy = _enemy;
			_most_behind_percentage = _behind_percentage;
		}
	}
	return _most_behind_enemy;
}
#endregion


#region target_healthy (Function
/*
	Given an enemy list, selects the enemy with the most amount of health
	NOTE: Currently doesn't take into account health buffs/debuffs
*/
function target_healthy(_unit, _enemy_list) {
	if(ds_list_empty(_enemy_list)) {
		return noone;
	}

	var _healthiest_enemy = _enemy_list[| 0];
	var _highest_health = _healthiest_enemy.current_health
	for(var i = 1; i < ds_list_size(_enemy_list); ++i) {
		var _enemy = _enemy_list[| i];
		if(_enemy.current_health > _highest_health) {
			_highest_health = _enemy.current_health;
			_healthiest_enemy = _enemy;
		}
	}
	return _healthiest_enemy;
}
#endregion


#region target_weak (Function)
/*
	Given an enemy list, selects the enemy with the least amount of health
	NOTE: Currently doesn't take into account health buffs/debuffs
*/
function target_weak(_unit, _enemy_list) {
	if(ds_list_empty(_enemy_list)) {
		return noone;
	}

	var _weakest_enemy = _enemy_list[| 0];
	var _lowest_health = _weakest_enemy.current_health
	for(var i = 1; i < ds_list_size(_enemy_list); ++i) {
		var _enemy = _enemy_list[| i];
		if(_enemy.current_health < _lowest_health) {
			_lowest_health = _enemy.current_health;
			_weakest_enemy = _enemy;
		}
	}
	return _weakest_enemy;
}
#endregion


#region TargetingTypes (Class)
/*
	Struct containing info regarding different targeting types units can select from
	
	Argument Variables:
	All correspond to Data Variables
	
	Data Variables:
	targeting_name: The string value that the targeting type is referred to in the targeting menu
	targeting_fn: The function used to select a target from a list of enemies.
*/
function TargetingType(_targeting_name, _targeting_fn) constructor {
	targeting_name = _targeting_name;
	targeting_fn = _targeting_fn;
}

global.TARGETING_CLOSE = new TargetingType("Close", target_close);
global.TARGETING_FIRST = new TargetingType("Far Along", target_first);
global.TARGETING_LAST = new TargetingType("At Back", target_last);
global.TARGETING_HEALTHY = new TargetingType("Healthiest", target_healthy);
global.TARGETING_WEAK = new TargetingType("Weakest", target_weak);
#endregion


#region TargetingTracker (Class)
/*
	Used to keep track of a unit's current targeting option, as well as changing said option
	
	Argument Variables:
	All correspond to Data Variables
	
	Data Variables:
	potential_targeting_types: A list of all the targeting types a unit can use. Should all be globals labeled TARGETING_[TARGETINGTYPE]
	currently_selected_idx: Index into the potential_targeting_type list that 
*/
function TargetingTracker(_potential_target_types = [TARGETING_TYPE.CLOSEST]) constructor {
	potential_targeting_types = _potential_target_types;
	currently_selected_idx = 0; //By default, use the first option provided in the list
	
	static get_current_targeting_type = function() {
		if(array_length(potential_targeting_types) == 0) {
			return undefined;
		}
		return potential_targeting_types[currently_selected_idx];
	}
	
	static use_next_targeting_type = function() {
		currently_selected_idx++;
		if(currently_selected_idx >= array_length(potential_targeting_types)) {
			currently_selected_idx = 0;
		}
	}
	
	static use_previous_targeting_type = function() {
		currently_selected_idx--;
		if(currently_selected_idx < 0) {
			currently_selected_idx = array_length(potential_targeting_types) - 1;
		}
	}
}
#endregion

#endregion


#region Enemy Targeting

#region enemy_target_close (Function)
//NOTE: Currently assumes that both lists are sorted
function enemy_target_close(_unit_list, _target_list, _prioritize_targets = false) {
	if(!ds_list_empty(_target_list) && _prioritize_targets) {
		return _target_list[| 0];
	}
	for(var i = 0; i < ds_list_size(_unit_list); i++) {
		var _current_unit = _unit_list[| i];
		if(_current_unit.health_state == UNIT_STATE.ACTIVE) {
			return _current_unit;
		}
	}
	if(!ds_list_empty(_target_list)) {
		return _target_list[| 0];
	}
	return noone;
	
}
#endregion

#endregion