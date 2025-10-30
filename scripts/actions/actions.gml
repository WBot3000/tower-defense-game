/*
This file contains functions that detail specific entity behaviors.

NOTE: All actions should implicitly take the actor (the instance the function is called in) as the last parameter
*/

#region Attacking Functions

//Determines whether an entity is a valid target for attacking or not based on normal circumstances
function can_be_attacked(_entity_to_be_attacked, _actor = other) {
	if(_entity_to_be_attacked == noone || !instance_exists(_entity_to_be_attacked)) { //Can't attack an entity that no longer exists.
		return false;
	}
	return _entity_to_be_attacked.health_state == HEALTH_STATE.ACTIVE; //Don't attack knocked out units
}


//Use this if you want an entity to pick out another entity(ies) based on their targeting tracker. Returns the entities selected
//NOTE: If there are less entities than specified by _num_entities_returned, the rest of the array will NOT be culled. It's the responsibility of the calling code to handle this however it sees fit.

#macro RETURN_ALL_ENTITIES -1 //Used for when you need all the valid entities picked up. This basically turns the function into a filtered sorter.
function get_entities_using_targeting_tracker(_entity_list, _target_filter_fn, _num_entities_returned = 1, _actor = other) {
	var _entities = undefined;
	with(_actor) {
		var _targeting_type = targeting_tracker.get_current_targeting_type();
		_entities = _targeting_type.targeting_fn(self, _entity_list, _target_filter_fn, _num_entities_returned);
	}
	return _entities;
}


//Given an entity to damage, and a base damage value, calculate the amount of damage an attack should do. Returns the total amount of damage done.
//TODO: Take into account buffs/debuffs
function deal_damage(_entity_to_damage, _damage_amount, _ignore_defense = false, _actor = self){
	var _attack_multiplier = variable_instance_exists(_actor, "stat_multipliers") ? _actor.stat_multipliers[STATS.ATTACK_POWER] : 1;
	var _true_damage_amount = _damage_amount * _attack_multiplier;
	
	with(_entity_to_damage) {
		if(variable_struct_exists(entity_data, "defense_factor") && !_ignore_defense) {
			var _defense_multiplier = variable_instance_exists(_entity_to_damage, "stat_multipliers") ? _entity_to_damage.stat_multipliers[STATS.DEFENSE] : 1;
			_true_damage_amount /= (entity_data.defense_factor * _defense_multiplier);
		}
		current_health = max(current_health - _true_damage_amount, 0);
	}
	
	return _true_damage_amount;
}


//Create a projectile at (x_start, y_start), directed at the target specified. Returns the id of the projectile created.
//NOTE: The actual behavior of the projectile is determined within the projectile's code. This just does proper initialization.
function shoot_projectile(_projectile, _target, _projectile_data, _actor = other) {
	var _vector = instances_vector_to_get_components(_actor, _target, true);
	//show_debug_message(_vector);
	var _projectile_stat_multipliers = [];
	//Projectiles spawned when an entity has certain modifiers should keep those modifiers, even if the entity's modifiers end up changing (hence why this isn't just a shallow reference)
	array_copy(_projectile_stat_multipliers, 0, _actor.stat_multipliers, 0, STATS.LENGTH);
	
	return instance_create_layer(get_bbox_center_x(_actor), get_bbox_center_y(_actor), PROJECTILE_LAYER, _projectile,
				{
					target: _target, //Needed for homing projectiles
					x_speed: _vector[VEC_X] * _projectile_data.travel_speed,
					y_speed: _vector[VEC_Y] * _projectile_data.travel_speed,
					data: _projectile_data, //NOTE: Also includes travel speed not broken up + normalized
					stat_multipliers: _projectile_stat_multipliers
				});
	
}

#endregion


#region Movement Functions
//TODO: Blocking functions will have to change because of potential for enemies to move backwards along their paths
//Run on each step of an enemy that can be blocked. Will allow the entity to be stalled by entities that can block
function blocked_check(_actor = other) {
	with(_actor) {
		if(!blocked) {
			var _unit_at_position = instance_place(x, y, base_unit);
			if(_unit_at_position != noone && _unit_at_position.entity_data.can_block && _unit_at_position.health_state == HEALTH_STATE.ACTIVE) {
				path_speed = 0;
				array_push(_unit_at_position.blocking_list, self);
			}
		}
	}
}

//So we don't have to run the blocked_check function on every single frame, entities that contain instead contain a list that contains all of the entities that they are blocking
//When this entity shouldn't block anymore (whether it has been knocked out or sold), run this function to allow those enemies to move again.

//Currently, there's no function for periodically releasing defeated enemies from a blocking list. Might want to implement that so the lists don't get too huge.
function release_enemies_from_block(_actor = other) {
	with(_actor) {
		for (var i = 0, len = array_length(blocking_list); i < len; ++i) {
			var _entity_blocked = blocking_list[i];
			_entity_blocked.path_speed = _entity_blocked.entity_data.default_movement_speed * _entity_blocked.stat_multipliers[STATS.MOVEMENT_SPEED];
		}
	}
}


//End knockback state, return to normal moving state (for path-based enemies)
function end_path_knockback(_actor = other) {
	with(_actor) {
		knockback_timer = 0;
		frames_to_knockback = 0;
		movement_state = MOVEMENT_STATE.UNIMPEDED;
		path_speed = entity_data.default_movement_speed * stat_multipliers[STATS.MOVEMENT_SPEED]
	}
}
#endregion


#region Summoning Functions
function create_tile_aligned_instance(_x_pos, _y_pos, _layer, _object, _data_passed) {
	var tile_at_position = instance_position(_x_pos, _y_pos, base_tile);
	if(tile_at_position != noone) {
		//x-offset and y-offset used so this works no matter where the placed object's sprite origin is located
		var _obj_sprite = object_get_sprite(_object)
		instance_create_layer(tile_at_position.x + sprite_get_xoffset(_obj_sprite), tile_at_position.y + sprite_get_yoffset(_obj_sprite), _layer, _object, _data_passed)
	}
	else {
		/*throw*/ show_debug_message("No tile present at location (" + string(_x_pos) + ", " + string(_y_pos) + ")!")
	}
}
#endregion


#region Miscellaneous Functions

//Used to set the sprite direction of units and enemies
function set_facing_direction(_direction, _actor = other) {
	with(_actor) {
		direction_facing = _direction;
		image_xscale = _direction;
	}
}


//Used to heal an entity (prevents unintentional overheal)
function heal_entity(_entity_to_heal, _amount_to_heal, _actor = other) {
	with(_entity_to_heal) {
		current_health = min(entity_data.max_health, current_health + _amount_to_heal)
	}
}


//Standard stuff that happens when an enemy is defeated
function standard_on_enemy_defeat_actions(_enemy = other) {
	with(_enemy) {
		health_state = HEALTH_STATE.KNOCKED_OUT;
		part_particles_create(global.PARTICLE_SYSTEM, get_bbox_center_x(self), get_bbox_center_y(self),
			global.PARTICLE_ENEMYDEATH, 1);
		path_end();
		instance_destroy(self, true);
	}
}


//Standard KO stuff that should apply to most units that get knocked out
function standard_on_ko_actions(_actor = other) {
	with(_actor) {
		animation_controller.set_animation("ON_KO"); //TODO: Write better code for chaining animations together
		health_state = HEALTH_STATE.KNOCKED_OUT;
		broadcast_hub.broadcast_event("entity_knocked_out");
	}
}


//Used for knocked-out units. Returns true if the entity has recovered and is back in it's normal state, returns false otherwise
function standard_recover_from_ko_actions(_actor = other) {
	var _recovered = false;
	with(_actor) {
		var _amount_to_recover = entity_data.recovery_rate / seconds_to_roomspeed_frames(1);
		current_health = min(entity_data.max_health, current_health + _amount_to_recover);
		if(current_health >= entity_data.max_health) {
			animation_controller.set_animation("ON_RESTORE");
			health_state = HEALTH_STATE.ACTIVE;
			broadcast_hub.broadcast_event("entity_revived");
			_recovered = true;
		}
	}
	return _recovered;
}

#endregion