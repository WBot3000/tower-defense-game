/*
This file contains functions that detail specific entity behaviors.
*/

#region Attacking Functions

//Determines whether an entity is a valid target for attacking or not based on normal circumstances
function can_be_attacked(_entity_to_be_attacked) {
	if(_entity_to_be_attacked == noone || !instance_exists(_entity_to_be_attacked)) { //Can't attack an entity that no longer exists.
		return false;
	}
	return _entity_to_be_attacked.entity_data.health_state == HEALTH_STATE.ACTIVE; //Don't attack knocked out units
}


//Use this if you want an entity to pick out another entity based on their targeting tracker. Returns the enemy selected
function get_entity_using_targeting_tracker(_entity_list, _targeting_params, _targeter = other) {
	var _entity = noone;
	with(_targeter) {
		var _targeting_type = targeting_tracker.get_current_targeting_type();
		_entity = _targeting_type.targeting_fn(self, _entity_list, _targeting_params);
	}
	return _entity;
}


//Given an entity to damage, and a base damage value, calculate the amount of damage an attack should do. Returns the total amount of damage done.
//TODO: Take into account buffs/debuffs
function deal_damage(_entity_to_damage, _damage_amount){
	var _true_damage_amount = _damage_amount;
	var _entity_data = _entity_to_damage.entity_data;
	
	if(variable_struct_exists(_entity_data, "defense_factor")) {
		_true_damage_amount /= _entity_data.defense_factor
	}
	_entity_data.current_health = max(_entity_data.current_health - _true_damage_amount, 0);
	if(_entity_data.current_health == 0) {
		_entity_data.on_health_reached_zero();
	}
	
	return _true_damage_amount;
}


//Create a projectile at (x_start, y_start), directed at the target specified. Returns the id of the projectile created.
//NOTE: The actual behavior of the projectile is determined within the projectile's code. This just does proper initialization.
function shoot_projectile(_projectile, _target, _projectile_data, _shooter = other) {
	var _vector = instances_vector_to_get_components(_shooter, _target, true);
	
	return instance_create_layer(get_bbox_center_x(_shooter), get_bbox_center_y(_shooter), PROJECTILE_LAYER, _projectile,
				{
					target: _target, //Needed for homing projectiles
					x_speed: _vector[VEC_X] * _projectile_data.travel_speed,
					y_speed: _vector[VEC_Y] * _projectile_data.travel_speed,
					data: _projectile_data //NOTE: Also includes travel speed not broken up + normalized
				});
	
}

#endregion


#region Movement Functions
#endregion


#region Miscellaneous Functions

//Used to set the sprite direction of units and enemies
function set_facing_direction(_direction, _entity = other) {
	with(_entity) {
		direction_facing = _direction;
		image_xscale = _direction;
	}
}


//Standard KO stuff that should apply to most units that get knocked out
function standard_on_ko_actions(_entity = other) {
	with(_entity) {
		animation_controller.set_animation("ON_KO"); //TODO: Write code for chaining animations together
		health_state = UNIT_STATE.KNOCKED_OUT;
	}
}


//Used for knocked-out units. Returns true if the entity has recovered and is back in it's normal state, returns false otherwise
function standard_recover_from_ko_actions(_entity = other) {
	var _recovered = false;
	with(_entity) {
		var _amount_to_recover = entity_data.recovery_rate / seconds_to_roomspeed_frames(1);
		current_health = min(entity_data.max_health, current_health + _amount_to_recover);
		if(current_health >= entity_data.max_health) {
			animation_controller.set_animation("ON_RESTORE");
			health_state = HEALTH_STATE.ACTIVE;
			_recovered = true;
		}
	}
	return _recovered;
}

#endregion