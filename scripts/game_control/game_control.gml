/*
This file contains the GameManager struct, which contains data and functions related to running the game
Will probably contain several separate managers
*/

/*
	Enums for different game states
	RUNNING: Game is running, enemies should move
	PAUSED: Game is paused, units and enemies shouldn't move or attack
	VICTORY: Game has been won
	DEFEAT: Game has been lost (might be able to merge into a single end condition with victory)
	UNDEFINED: Game state returned when there's no valid game controller. Should never be set to.
*/
enum GAME_STATE {
	RUNNING,
	PAUSED,
	VICTORY,
	DEFEAT,
	UNDEFINED
}


/*
	GameManager controls the game state machine
*/
function GameStateManager(initial_state = GAME_STATE.RUNNING) constructor {
	state = initial_state;
	
	static pause_game = function() {
		if(state == GAME_STATE.RUNNING) { //Shouldn't be able to pause Victory or Defeat states
			state = GAME_STATE.PAUSED;
		}
	}
	
	static resume_game = function() {
		state = GAME_STATE.RUNNING;
	}
	
	static win_game = function() {
		if(state == GAME_STATE.RUNNING) { //Shouldn't be able to win game if it's paused, already won, or already lost.
			state = GAME_STATE.VICTORY;
		}
	}
	
	static lose_game = function() {
		if(state == GAME_STATE.RUNNING) { //Shouldn't be lose to win game if it's paused, already won, or already lost.
			state = GAME_STATE.DEFEAT;
		}
	}
}



/*
	The below functions all are used for transfering data between components
	Fetches a game controller in the event an instance needs to refer to a property of game_state.
*/
function get_game_controller() {
	var _game_controller = instance_find(game_controller_base, 1);
	return _game_controller
}


function get_round_manager() {
	var _game_controller = get_game_controller();
	if(_game_controller == noone) {
		return noone;
	}
	return _game_controller.round_manager;
}


function get_camera_controller() {
	var _game_controller = get_game_controller();
	if(_game_controller == noone) {
		return noone;
	}
	return _game_controller.camera_controller;
}

