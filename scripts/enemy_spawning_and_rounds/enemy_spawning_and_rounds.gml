/*
	enemy_spawning_and_rounds.gml
	
	This file contains structs and functions relating to spawning enemies. It also contains the code for managing "rounds" of enemies.
	The main advantage of the Round Manager is that it allows multiple series of enemies to be called upon at varying times.
*/


#region EnemySpawningData (Class)
#macro ENEMY_SPAWN_END -1 //Makes spawn data a bit prettier. Doesn't have much of an actual function as of right now.
/*
	The "base" unit of an enemy spawn list. An Enemy Spawn List consists of all of the enemies that will be spawned on one path in one round.
	enemy_types: The list of enemies that should be spawned
	enemy_paths: The level paths of the spawned enemies. The length of this list should be equal to the length of enemy_set.
	time_until_next_spawn: The number of seconds until the next enemy spawn should occurs
	repeat_count: The amount of that enemy that this EnemySpawningData should be referenced
		- This is so you don't need to define multiple EnemySpawn for a simple pattern of the same enemy
	repeat_delay: The amount of seconds that should be waited in repeating this data
*/
function EnemySpawningData(_enemy_types, _enemy_paths, _time_until_next_spawn, _repeat_count, _repeat_delay) constructor {
	enemy_types = _enemy_types;
	enemy_paths = _enemy_paths
	//Might as well do conversions here. Might change this in the future
	time_until_next_spawn = seconds_to_roomspeed_frames(_time_until_next_spawn)
	repeat_count = _repeat_count;
	//Might as well do conversions here. Might change this in the future
	repeat_delay = seconds_to_roomspeed_frames(_repeat_delay)
}
#endregion


#region Round (Class)
/*
	Contains all of the code for actually spawning enemies. Every time a round starts, one of these is created.
	round_number: The number of this round (Round 1 = 1, Round 2 = 2, etc.)
	spawn_list: A list of EnemySpawningData that contains all of the enemies that'll be spawned within the round.
	timer_count: The amount of frames in between the last spawn and the next. The initial value is the amount of time before anything is spawned.
*/
function Round(_round_number, _spawn_list, _timer_count) constructor {
	round_number = _round_number;
	spawn_list = _spawn_list
	timer_count = _timer_count;
	//Variables to keep track of position in the list
	spawn_list_idx_ptr = 0;
	spawn_list_repeat_count = 0;
	spawn_timer = 0;
	
	//The enemies that this round has spawned. Used to keep track of when the round is over.
	currently_spawned_enemies = [];
	
	reward_count = 100; //The amount of money earned upon completion of a round (add this?)


	//Create the enemy pointed to in the spawn list, and add it's id to the currently_spawned_enemies list to keep track of round progress
	//Returns the spawned enemy in the event we need to do anything else to it
	static spawn_enemy = function(_enemy_type, _path_data) {
		var _new_enemy = instance_create_layer(_path_data.spawn_x, _path_data.spawn_y, ENEMY_LAYER, _enemy_type, 
			{
				path_data: _path_data,
				round_spawned_in: round_number,
			});
		array_push(currently_spawned_enemies, _new_enemy);
		return _new_enemy;
	};
	
	/*
		Used for removing enemies from the spawn queue.
		Also used to detect when a round is over (if we've reached the end of the spawn list, and the queue is empty, then congratulations, you've beaten the round.
		Returns true if the last enemy was destroyed
	*/
	static remove_enemy_from_spawned_list = function(_enemy_id) {
		var _enemy_index = array_get_index(currently_spawned_enemies, _enemy_id);
		if(_enemy_index == -1) {
			throw("Enemy " + string(_enemy_id) + " attempted to be removed from " + string(id) + ", where it isn't present."); //This should never happen in normal execution
		}
		array_delete(currently_spawned_enemies, _enemy_index, 1);
		if(array_length(currently_spawned_enemies) == 0 && spawn_list_idx_ptr >= array_length(spawn_list)) { //All enemies have been spawned and defeated. The round has been completed.
			return true;
		}
		return false;
	};
	
	/*
		Should be called in a spawn manager object's on step event.
		TODO: Think about whether incorporating time sources instead of the counter is worth it.
	*/
	static on_step = function() { //Should call in the step function
		//Don't do anything if you've went through the entire list
		//TODO: Return something when you want this function to stop being called. So this isn't called over and over again. Maybe a boolean?
		if(spawn_list_idx_ptr >= array_length(spawn_list)) {
			exit;
		}
		spawn_timer++;
		if(spawn_timer < timer_count) { //Guard clause to reduce nesting
			exit;
		}
		
		var _current_spawn_data = spawn_list[spawn_list_idx_ptr];
		for (var i = 0; i < array_length(_current_spawn_data.enemy_types); ++i) { //Spawn each enemy in the spawn data
			var _enemy_type = _current_spawn_data.enemy_types[i];
			var _path_data = _current_spawn_data.enemy_paths[i];
		    spawn_enemy(_enemy_type, _path_data);
			//show_debug_message("Enemy spawned");
		}
		
		spawn_list_repeat_count++;
		//All of the enemies in the current enemy spawn have been created. Move on to the next one in the list 
		if(_current_spawn_data.repeat_count < spawn_list_repeat_count) {
			spawn_list_repeat_count = 0;
			spawn_list_idx_ptr++;
			timer_count = _current_spawn_data.time_until_next_spawn;
		}
		else {
			timer_count = _current_spawn_data.repeat_delay;
		}
		spawn_timer = 0;			
	};
	
}
#endregion


#region RoundManager (Class)
/*
	The master controller of all rounds.
	This controller lets the game run multiple rounds at the same time.
	Should work fine as long as array_length(spawn_data) >= max_round
	controller_obj: The controller object this manager is created for.
	current_round: The most recent round spawned
	max_round: The final round of the game
	spawn_data: 2D array containing all of the enemies that should be spawned in this game
	extra_enemies: A list of extra enemies that have been spawned outside of the round structure. Mainly used for enemies spawning other enemies.
	
	all_rounds: Consists of an array that contains all of the round data for the level
	rounds_currently_running: Consists of an array of the rounds that are currently in progress
*/
function RoundManager(_controller_obj, _max_round = 0, _spawn_data = []) constructor {
	controller_obj = _controller_obj;
	game_state_manager = get_game_state_manager(controller_obj);
	current_round = 0;
	max_round = _max_round;
	
	spawn_data = _spawn_data
	
	all_rounds = [];
	rounds_currently_running = [];
	
	static start_round = function() {
		if(current_round >= max_round) { //Don't exceed max round;
			exit;
		}
		current_round++;
		var _new_round_data = new Round(current_round, spawn_data[current_round - 1], 0);
		array_push(all_rounds, _new_round_data);
		array_push(rounds_currently_running, _new_round_data);
	};
	
	
	static remove_enemy = function(_enemy_id, _round_number) {
		var _round = all_rounds[_round_number - 1] //Index will be less than the round number
		var _round_completed = _round.remove_enemy_from_spawned_list(_enemy_id);
		
		if(_round_completed) {
			var _round_index = array_get_index(rounds_currently_running, _round);
			if(_round_index == -1) {
				throw("Round " + string(_round) + " attempted to be removed from " + string(self) + ", where it isn't present."); //This should never happen in normal execution
			}
			array_delete(rounds_currently_running, _round_index, 1);
			global.player_money += _round.reward_count; //TODO: When/if you create a money manager, update this.
			if(array_length(rounds_currently_running) == 0 && current_round >= array_length(spawn_data)) { //All rounds have been spawned and defeated. The game has been completed.
				controller_obj.game_state_manager.win_game();
			}
		}
	}
	
	//This is suprisingly similar to the enemy destroy callback. I guess that makes sense. Both involve clearing out an instance that's no longer needed, and then checking a condition to see if a thing is completed.
	//TODO: Make this static in a similar way to the enemy defeated callback.
	/*
	on_round_finish_callback = function(_round_ptr) {
		var _round_index = array_get_index(rounds_currently_running, _round_ptr);
		if(_round_index == -1) {
			throw("Round " + string(_round_ptr) + " attempted to be removed from " + string(self) + ", where it isn't present."); //This should never happen in normal execution
		}
		array_delete(rounds_currently_running, _round_index, 1);
		global.player_money += _round_ptr.reward_count; //TODO: When you create a money manager, update this.
		if(array_length(rounds_currently_running) == 0 && array_length(extra_enemies) == 0 && current_round >= array_length(spawn_data)) { //All rounds have been spawned and defeated. The game has been completed.
			controller_obj.game_state_manager.win_game();
		}
	};*/
	
	static spawn_extra_enemy = function(_enemy_type, _path_data, _round_number) {
		var _round = all_rounds[_round_number - 1];
		//If a round has already been declared as "beaten", no new enemies from that round should be spawned. Don't want "zombie rounds".
		var _round_is_running = array_get_index(rounds_currently_running, _round) == -1 ? false : true;
		if(!_round_is_running) { 
			return noone;
		}
		
		return _round.spawn_enemy(_enemy_type, _path_data);
	}
	
	static on_step = function(_curr_game_state) {
		if(_curr_game_state == GAME_STATE.RUNNING) {
			for(var i = 0; i < array_length(rounds_currently_running); i++) { //Run each round
				rounds_currently_running[i].on_step();
			}
		}
	};
}
#endregion