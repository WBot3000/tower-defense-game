/*
	damage.gml
	
	This file contains the damage function, used for dealing damage to enemies and units.
	It also contains the function for checking to see if an entity can actually be attacked in the first place.
*/

/*
	Determine if a specified entity is a valid attack target
*/
function can_be_attacked(_entity_to_be_attacked) {
	if(!instance_exists(_entity_to_be_attacked)) { //Can't attack an entity that no longer exists.
		return false;
	}
	if(!object_is_ancestor(_entity_to_be_attacked, base_unit)) { //All entities that aren't units can always be attacked
		return true;
	}
	return _entity_to_be_attacked.health_state == UNIT_STATE.ACTIVE; //Don't attack knocked out units
}

/*
	Given an entity to damage, and a base damage value, calculate the amount of damage an attack should do.
*/
function deal_damage(_entity_to_damage, _damage_amount){
	var _true_damage_amount = _damage_amount;
	if(variable_instance_exists(_entity_to_damage, "defense_factor")) {
		_true_damage_amount /= _entity_to_damage.defense_factor
	}
	_entity_to_damage.current_health = max(_entity_to_damage.current_health - _true_damage_amount, 0);
	if(_entity_to_damage.current_health == 0 && object_is_ancestor(_entity_to_damage.object_index, base_target)) { //If a target reaches zero health, end the game
		var _game_state_manager = get_game_state_manager();
		_game_state_manager.lose_game();
	}
}