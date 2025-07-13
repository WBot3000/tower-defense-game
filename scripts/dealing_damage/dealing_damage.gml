/*
	damage.gml
	
	This file contains the damage function, used for dealing damage to enemies and units.
	It also contains the function for checking to see if an entity can actually be attacked in the first place.
*/

/*
	Determine if a specified entity is a valid attack target.
	TODO: Is this function needed? The main concern is attempting on perform actions that no longer exist, but if all the targeting/action functions are all run right after each other, this isn't a concern.
*/
function can_be_attacked(_entity_to_be_attacked) {
	if(_entity_to_be_attacked == noone || !instance_exists(_entity_to_be_attacked)) { //Can't attack an entity that no longer exists.
		return false;
	}
	return _entity_to_be_attacked.entity_data.health_state == HEALTH_STATE.ACTIVE; //Don't attack knocked out units
}

/*
	Given an entity to damage, and a base damage value, calculate the amount of damage an attack should do.
*/
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
}