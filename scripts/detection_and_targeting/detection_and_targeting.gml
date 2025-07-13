/*
	detection_and_targeting.gml
	
	This file contains structs and functions relating to how units target enemies, including
	- Detection ranges, used for things like:
		-Unit attack range
		-Persistent projectile damage range
	- Unit targeting functions
*/

#region Ranges
//NOTE: Ranges are based on the center of the unit's 64x64 sprite, not it's bounding box. This is so range location isn't based on sprite.

#region Range (Class)
/*
	Base "range" from which all other ranges can derive from. Largely used as an interface.
	unit: the id of the unit object that uses this range
*/
function Range(_unit) constructor {
	unit = _unit; //TOOD: Change this to "entity" wherever needed (because these are used for enemies too)
	
	static draw_range = function(){};
	static get_entities_in_range = function(){};
	static move_range = function(){};
}
#endregion


#region CircularRange (Class)
/*
	For units with a circular viewing range (think most towers from Bloons Tower Defense 6)
	origin_x: x-coordinate of the circle's origin (relative to the unit's center)
	origin_y: y-coordinate of the circle's origin (relative to the unit's center)
	radius: How far the unit can "see"
*/
function CircularRange(_unit, _origin_x, _origin_y, _radius) : Range(_unit) constructor {
	origin_x = _origin_x;
	origin_y = _origin_y;
	radius = _radius;
	
	static draw_range = function() {
		draw_set_alpha(0.125)
		draw_circle_color(origin_x + unit.x, origin_y + unit.y - TILE_SIZE/2, radius, c_white, c_white, false);
		draw_set_alpha(1)
	}
	
	/*
		Detect...
		All of a certain type of entity(s) (obj = _entity_type[x])
		Within it's radius (first three arguments)
		Using boundary boxes for speed increase (prec = false)
		While not targeting yourself (notme = true)
	*/
	static get_entities_in_range = function(_entity_types, _storage_list) {
		for(var i = 0, len = array_length(_entity_types); i < len; ++i) {
			collision_circle_list(origin_x + get_bbox_center_x(unit), origin_y + get_bbox_center_y(unit), radius, _entity_types[i], false, true, _storage_list, false);
		}
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
	x1: x-coordinate of the rectangle's top-left (relative to entity)
	y1: y-coordinate of the rectangle's top-left (relative to entity)
	x2: x-coordinate of the rectangle's bottom-right (relative to entity)
	y2: y-coordinate of the rectangle's bottom-right (relative to entity)
*/
function RectangularRange(_unit, _x1, _y1, _x2, _y2) : Range(_unit) constructor {
	x1 = _x1;
	y1 = _y1;
	x2 = _x2;
	y2 = _y2;
	
	static draw_range = function() {
		draw_set_alpha(0.125)
		draw_rectangle_color(x1 + unit.x, y1 + unit.y - TILE_SIZE/2, x2 + unit.x, y2 + unit.y - TILE_SIZE/2, c_white, c_white, c_white, c_white, false);
		draw_set_alpha(1)
	}
	
	/*
		Detect...
		All of a certain type of entity (obj = _entity_types[x])
		Within it's radius (first three arguments)
		Using boundary boxes for speed increase (prec = false)
		While not targeting yourself (notme = true)
	*/
	static get_entities_in_range = function(_entity_types, _storage_list) {
		var _center_x = get_bbox_center_x(inst);
		var _center_y = get_bbox_center_y(inst);
		
		for(var i = 0, len = array_length(_entity_types); i < len; ++i) {
			collision_rectangle_list(x1 + _center_x, y1 + _center_y, x2 + _center_x, y2 + _center_y, _entity_types[i], false, true, _storage_list, false);
		}
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
	origin_x = 0;//get_bbox_center_x(_unit);
	origin_y = 0;//get_bbox_center_y(_unit);
	radius = max((_unit.bbox_right - _unit.bbox_left)/2, (_unit.bbox_bottom - _unit.bbox_top)/2) * 1.5; //So that melee units have just a bit more range.
}
#endregion


#region GlobalRange (Class)
/*
	A RectangularRange for enemies that can see the entire level at once.
	Doesn't draw anything because creating a big white rectangle over the entire level sounds unpleasant.
*/
function GlobalRange(_unit) : RectangularRange(_unit, 0, 0, 0, 0) constructor {
	x1 = -1*_unit.x;
	y1 = -1*_unit.y;
	x2 = room_width - _unit.x;
	y2 = room_height - _unit.y;
	static draw_range = function(){};
}

/*
	Because the global ranges for detecting a certain thing aren't location-dependent, two global ranges meant to find the same thing are essentially identical, and two entity lists utilizing them are as well.
	So instead of creating a different ds_list for each unit/enemy that uses it, just one for each kind of target is created, and can then be refererenced.
	NOTE: Remember not to delete these once a unit/enemy using them is deleted, they're meant to persist for the lifetime of the game.
*/
global.ALL_ENEMIES_LIST = ds_list_create();
global.ALL_UNITS_LIST = ds_list_create();
#endregion


#endregion


#region Unit Targeting

#region TargetingParams (Class)
/*
	A struct that specifies what kinds of entities should be included or excluded from targeting.
	By default, all entities picked up by a range will be considered valid targets for an action.
	The functions determine the method for picking out an entity, while this acts as a "filter".
	NOTE: This doesn't filter out entities based on their type, as you can just specify what kind of entities should be detected when using the ranges.
*/
function TargetingParams(_dont_target_knocked_out = false, _dont_target_attackable = false, _dont_target_buffs = [], _only_target_buffs = []) constructor {
	dont_target_knocked_out = _dont_target_knocked_out;
	dont_target_attackable = _dont_target_attackable;
	dont_target_buffs = _dont_target_buffs;
	only_target_buffs = _only_target_buffs;
	
	static is_entity_valid_target = function(_entity) {
		//TODO: Add checking for buffs (before other checks)
		if(dont_target_attackable && can_be_attacked(_entity)) {
			return false;
		}
		if(dont_target_knocked_out && _entity.entity_data.health_state == HEALTH_STATE.KNOCKED_OUT) {
			return false;
		}
		return true;
	}
}
#endregion


#region targeting_function_builder (Function)
/*
	Create new kinds of targeting using this function. Prevents inconsistencies from arising between the different targeting functions.
	The _entity_to_value_fn should return a numerical value. The targeting function will pick the entity that satisfies the targeting parameters and generates the largest value.
	If you want to pick the target with the smallest value instead, just multiply the result by -1 in the _entity_to_value_fn
	
	NOTE: Not all targeting functions need to use this. For example, the default enemy targeter just chooses the first entity in the list
*/
function targeting_fn_builder(_entity_to_value_fn) {
	var _fn = function(_unit, _entity_list, _targeting_params) {
		var _selected_entity = noone;
		var _selected_entity_value = -1;
		for(var i = 0, len = ds_list_size(_entity_list); i < len; ++i) {
			if(!_targeting_params.is_entity_valid_target(_entity_list[| i])) { //Filter out inelligible entities
				continue;
			}
			
			if(_selected_entity == noone) {
				_selected_entity = _entity_list[| i];
				_selected_entity_value = entity_to_value_fn(_unit, _selected_entity);
			}
			else {
				var _new_value = entity_to_value_fn(_unit, _entity_list[| i]);
				if(_new_value > _selected_entity_value) {
					_selected_entity = _entity_list[| i];
					_selected_entity_value = _new_value;
				}
			}
		}
		return _selected_entity;
	}
	
	//Need the method function to pass the outer value to the inner function, as seen here: https://forum.gamemaker.io/index.php?threads/inherit-struct-with-variable-parameter-as-parameter.91799/
	return method({entity_to_value_fn: _entity_to_value_fn}, _fn);
}


#region target_close (Function)
/*
	Calculates the squared distance between the targeter and the targetee
*/
function target_value_close(_targeter, _targetee) {
	return sqr(_targeter.x - _targetee.x) + sqr(_targeter.y - _targetee.y);
}
#endregion


#region target_first (Function)
/*
	Given an enemy list, selects the enemy closest to the wall.
	Currently only takes into account enemies that have paths.
*/
function target_value_first(_targeter, _targetee) {
	if(_targetee.path_index != -1 && _targetee.path_index != pth_dummypath) {
		return _targetee.path_position * -1;
	}
	return 101; //Since path_position can be between 0-100, the pathless targetee will never be prioritized over one with a path
}
#endregion


#region target_last (Function)
/*
	Given an enemy list, selects the enemy furthest from the wall.
	Currently only takes into account enemies that have paths.
*/
function target_value_last(_targeter, _targetee) {
	if(_targetee.path_index != -1 && _targetee.path_index != pth_dummypath) {
		return _targetee.path_position;
	}
	return -1;
}
#endregion


#region target_healthy (Function
/*
	Given an enemy list, selects the enemy with the most amount of health
	NOTE: Currently doesn't take into account health buffs/debuffs
*/
function target_value_healthiest(_targeter, _targetee) {
	return _targetee.entity_data.current_health;
}
#endregion


#region target_weak (Function)
/*
	Given an enemy list, selects the enemy with the least amount of health
	NOTE: Currently doesn't take into account health buffs/debuffs
*/
function target_value_weakest(_targeter, _targetee) {
	return _targetee.entity_data.current_health * -1;
}
#endregion


#region TargetingTypes (Class)
/*
	Struct containing info regarding different targeting types units can select from
	
	Argument Variables:
	All correspond to Data Variables
	
	Data Variables:
	identifier: An internal id used to reference a specific targeting type
	targeting_name: The string value that the targeting type is referred to in the targeting menu
	targeting_fn: The function used to select a target from a list of enemies.
*/
function TargetingType(/*_identifier,*/ _targeting_name, _targeting_fn) constructor {
	targeting_name = _targeting_name;
	targeting_fn = _targeting_fn;
}


global.TARGETING_CLOSE = new TargetingType("Close", targeting_fn_builder(target_value_close) );
global.TARGETING_FIRST = new TargetingType("Far Along", targeting_fn_builder(target_value_first) );
global.TARGETING_LAST = new TargetingType("At Back", targeting_fn_builder(target_value_last) );
global.TARGETING_HEALTHY = new TargetingType("Healthiest", targeting_fn_builder(target_value_healthiest) );
global.TARGETING_WEAK = new TargetingType("Weakest", targeting_fn_builder(target_value_weakest) );

//Enemy targeting, allows the enemies to use the same targeting mechanisms as the units.
//NOTE: The display names are never shown, so make them whatever you want
global.ENEMY_TARGETING_DEFAULT = new TargetingType("", enemy_target_default);
#endregion


#region TargetingTracker (Class)
/*
	Used to keep track of a unit's current targeting option, as well as changing said option.
	
	Argument Variables:
	All correspond to Data Variables
	
	Data Variables:
	potential_targeting_types: A list of all the targeting types a unit can use. Should all be globals labeled TARGETING_[TARGETINGTYPE]
	currently_selected_idx: Index into the potential_targeting_type list that 
*/
function TargetingTracker(_potential_target_types) constructor {
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
	
	//Lets you switch targeting type
	//Pass the global targeting type into this function
	static set_targeting_type = function(_targeting_type) {
		for (var i = array_length(potential_targeting_types) - 1; i >= 0; --i) {
		   if(potential_targeting_types[i] == _targeting_type) {
			   currently_selected_idx = i;
			   return;
		   }
		}
		//TODO: Throw? Or nah
		show_debug_message("Targeting type " + _identifier + " not found in targeting tracker " + string(self.id) + ". Targeting type not changed."); 
	}
}
#endregion

#endregion


#region Enemy Targeting

#region enemy_target_default (Function)
//NOTE: With this function, the enemy selection is determined by the order of the input list, unlike all the other ones
//NOTE 2: Currently, this doesn't do anything with _enemy, it just takes it as an argument because all of the other 
function enemy_target_default(_enemy, _entity_list) {
	for(var i = 0, len = ds_list_size(_entity_list); i < len; ++i) {
		var _current_entity = _entity_list[| i];
		if(can_be_attacked(_current_entity)) {
			return _current_entity;
		}
	}
	return noone;
}
#endregion

#endregion

#endregion