//Ignore most of this for now.

/*
	data_enemy.gml
	
	This file contains data for all the different types of enemies in the game.
	Sometimes, we might need to refer to some stats that an enemy has before initializing any instances of that enemy (ex. looking at an enemy descriptions)
	This data can be used to refer to enemies in these instances.
	This data is also used when the corresponding enemy is created
*/

/*
	Data that all enemies should have
	max_health: The maximum amount of health this enemy normally has
	current_health: The health that the enemy is currently has. Normally initialized to the same value as max_health.
	monetary_value: The amount of money this enemy gives upon defeat
	movement_path: The path that the enemy follows. Usually given to the enemy by a spawner.
	movement_speed: How quickly the enemy moves along it's given path
	round_spawned_in: A pointer to the Round object that spawned the enemy. Needed to call back into the round when it gets destroyed
	enemy_buffs: An array of all the buffs/debuffs the enemy has
*/
function Enemy(_path_data, _round_spawned_in) : Combatant() constructor {
	
	path_data = _path_data;
	default_movement_speed = 1.5;
	
	round_spawned_in = _round_spawned_in
	monetary_value = 50;
	
	//Performs all actions a unit can do while active
	static while_active = function() {
		for(var i = 0; i < array_length(action_queue); ++i) {
			action_queue[i].execute();
			action_queue[i].update_params();
		}
	}
	
	
	//Called in the "dealing_damage" function once the entity's health reaches zero
	static on_health_reached_zero = function() {
		health_state = HEALTH_STATE.KNOCKED_OUT;
		for(var i = 0; i < array_length(action_queue); ++i) {
			action_queue[i].on_health_reached_zero();
		}
		with(inst) {
			path_end();
		}
		animation_controller.set_animation("ON_KO", 1, function(){ instance_destroy(inst, true) });
	}
	
	
	static while_knocked_out = function() {} //Can put anything here that should be done after the enemy has been defeated
}


/*
	Whether an enemy should be moving or attacking
*/
enum ENEMY_ATTACKING_STATE {
	NOT_ATTACKING,
	IN_ATTACK
}

//TODO: Currently implemented in path travel action, might be able to get rid of this
function get_enemy_path_direction(_enemy) {
	var _enemy_current_x = _enemy.x;//path_get_x(_enemy.path_data.default_path, _enemy.path_position);
	var _enemy_previous_x = path_get_x(_enemy.path_data.default_path, _enemy.path_positionprevious);
	
	if(_enemy_current_x > _enemy_previous_x) {
		return DIRECTION_RIGHT;
	}
	if(_enemy_current_x < _enemy_previous_x) {
		return DIRECTION_LEFT;
	}
	if(variable_instance_exists(_enemy.id, "direction_facing")) {
		return _enemy.direction_facing;
	}
	return undefined;
}