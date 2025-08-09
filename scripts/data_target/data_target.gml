/*
This file contains the entity data for targets.
For now, I'm not defining specific classes for each target, as all of them will be rather simple for now, only differing in a few stats
*/
function TargetData(_starting_health, _max_health = _starting_health) : EntityData() constructor {
	current_health = _starting_health;
	max_health = _max_health;
	
	static on_health_reached_zero = function() {
		var _game_state_manager = get_game_state_manager();
		_game_state_manager.lose_game();
	}
}