/*
	damage.gml
	
	This file contains the damage function, used for dealing damage to enemies and units.
*/

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

/*
	Function used for when an enemy deals damage to a target object.
	If the enemy reduces the target's HP to zero, the game should be considered lost.
*/
/*
function damage_target(_target_to_damage, _damage_amount) {
	_target_to_damage.current_health = max(_target_to_damage.current_health -_damage_amount, 0); //Prevents targets from having negative health;
	if(_target_to_damage.current_health == 0) { //Lose game
		var _game_state_manager = get_game_state_manager();
		_game_state_manager.lose_game();
	}
}*/