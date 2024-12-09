/*
	This file contains structs and functions relating to how units target enemies, including
	- Detection ranges, used for things like:
		-Unit attack range
		-Persistent projectile damage range
	- Unit targeting functions
*/

/*
	Ranges
*/

/*
	Base "range" from which all other ranges can derive from. Largely used as an interface.
	unit: the id of the unit object that uses this range
*/
function Range(_unit) constructor {
	unit = _unit;
	
	static draw_range = function(){};
	static get_entities_in_range = function(){};
}

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
		draw_set_alpha(0.25)
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
}

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
		draw_set_alpha(0.25)
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
}

/*
	Persistent hitboxes are used for when you want to do something to entities within a hitbox every so often.
	Originated from a need to damage enemies within an explosion hitbox
	- Damanging them every frame would be excessive
	Not strictly necesary if you just plan on inflicting the effect every frame.
	
	TODO: Think about using time sources for this too.
	- Just using current time like this will break upon pausing the game. Time sources can be paused, so this issue goes away easily without having to manage multiple timers
	TODO: Enable different effects for different kinds of entities?
	- Specify this relationship using another struct
	
	range: The range used to detect what entities should be affected by the specified effect.
	effect: A function that's applied to any entities in the range if they aren't on cooldown.
	- Effect takes entity as an argument
	- This effect will be called on every entity will be found, so make sure this function will work 
	cooldown: The amount of time that should be waited before applying the effect again.
	explosion_timer: The number of frames the hitbox has been active for.
	entities_on_cooldown: A struct that contains all of the entities that shouldn't be affected by the effect on the current frame.
	entity_trigger_times: A 2D array that contains all of the times the effect was last applied to.
	- While it's somewhat redundant to have both this and entities_on_cooldown, the purpose is to save time by leveraging the advantages of both structs and arrays.
		- When checking if the entity is on cooldown, we can just use the struct instead of iterating through the array multiple times.
		- When removing entities from cooldown, we can just check the beginning of the array (it'll be sorted from earliest added to latest), instead of having to turn struct into an array each time.
*/
function PersistentHitbox(_range, _effect, _cooldown) constructor {
	range = _range;
	effect = _effect;
	cooldown = _cooldown;
	
	explosion_timer = 0;
	entities_on_cooldown = {};
	entity_trigger_times = [];
	
	//Arguments come from the "get_entities_in_range" function for the Range.
	//Currently assumes that each entity instance handles it's own list. TODO: Determine whether this is good or should be changed.
	static on_step = function(_entity_type, _storage_list, _ordered = false) {
		range.get_entities_in_range(_entity_type, _storage_list, _ordered);
		//var _curr_time = current_time; //All entities should be "marked" at the same time, which is why this is stored in a variable instead of referenced each time.
		
		//You can do this because the trigger times are in order from earliest started to most recently started.
		while(array_length(entity_trigger_times) > 0) {
			var _time_difference = milliseconds_to_seconds(explosion_timer - entity_trigger_times[0][1]);
			if(_time_difference < cooldown) { //Cooldown hasn't expired yet, so none of the later cooldowns on the list will have expired either.
				break;
			}
			var _removed_entity_id_hash =  entity_trigger_times[0][0]
			array_shift(entity_trigger_times) //Otherwise effect can be activated for this entity again.
			struct_set_from_hash(entities_on_cooldown, _removed_entity_id_hash, undefined);
		}
		
		for(var i = 0; i < ds_list_size(_storage_list); ++i) {
			var _added_entity_id = _storage_list[| i]
			//Optimization. Faster than just directly accessing 
			var _added_entity_id_hash = variable_get_hash(_added_entity_id);
			var _is_on_cooldown = struct_get_from_hash(entities_on_cooldown, _added_entity_id_hash);
			if(_is_on_cooldown == undefined) { //Call effect on enemy
				effect(_added_entity_id);
				//Add hash instead of entity id so we don't have to recalculate it later.
				//NOTE: This would have to be changed if we ever wanted to display the cooldown list to the player, but tbh that's very unlikely
				array_push(entity_trigger_times, [_added_entity_id_hash, explosion_timer]);
				struct_set_from_hash(entities_on_cooldown, _added_entity_id_hash, true);
			}
		}
		
		explosion_timer++;
	}
	
}



/*
	Unit Targeting
*/

/*
	What kind of targeting a unit is using
	CLOSEST_TO_UNIT: Attack the enemy that's physically closest to the unit. Equivalent to BTD6's "Close"
	CLOSEST_TO_WALL: Attack the enemy that's closest to the wall. Equivalent to BTD6's "First"
	FURTHEST_FROM_WALL: Attack the enemy that's furthest from the wall. Equivalent to BTD6's "Last"
*/
enum TARGETING_TYPE {
	CLOSEST_TO_UNIT,	//Close
	CLOSEST_TO_WALL,	//First
	FURTHEST_FROM_WALL	//Last
}


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