/*
	damage.gml
	
	This file contains the damage function, used for dealing damage to enemies and units.

	Currently just a wrapper around setting and max functions
	
	NOTE:
	Because this is such a nothing-burger file, I'm not even bothering with any sort of regioning as of right now.
	
	TODO: No clue if I want to keep this or not.
		The reason this exists in the first place is because entity health being less than zero caused issues with the health bar and health regeneration.
		But having negative health might be useful somewhere? Who knows.
*/
function deal_damage(entity_to_damage, damage_amount){
	entity_to_damage.current_health -= max(damage_amount, 0);
}

/*
	Function used for when an enemy deals damage to a target object.
	If the enemy reduces the target's HP to zero, the game should be considered lost.
*/
function damage_target(_target_to_damage, _damage_amount) {
	_target_to_damage.current_health = max(_target_to_damage.current_health -_damage_amount, 0); //Prevents targets from having negative health;
	if(_target_to_damage.current_health == 0) { //Lose game
		var _game_state_manager = get_game_state_manager();
		_game_state_manager.lose_game();
	}
}