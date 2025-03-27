/*
	game_state_control.gml
	
	This file contains the GameManager struct, which contains data and functions related to running the game.
	It also contains functions for fetching individual managers from a game controller object. This lets you reference managers inside other managers without having to do a bunch of nested parameter passing.
	TODO: Might end up containing several separate managers
*/


#region GameStateManager (Class)
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
	
	Controller object is passed so we don't have to fetch it every time we want to work with it.
*/
function GameStateManager(_controller_obj, _initial_state = GAME_STATE.RUNNING) constructor {
	controller_obj = _controller_obj
	state = _initial_state;
	
	static pause_game = function() {
		if(state == GAME_STATE.RUNNING) { //Shouldn't be able to pause Victory or Defeat states
			state = GAME_STATE.PAUSED;
			with(controller_obj) {
				instance_deactivate_all(true); //Keep the manager object alive, otherwise the game will just stop working
				if(game_ui != undefined) {
					game_ui.set_gui_paused();
				}
			}
		}
	}
	
	static resume_game = function() {
		state = GAME_STATE.RUNNING;
			with(controller_obj) {
				instance_activate_all();
				if(game_ui != undefined) {
					game_ui.set_gui_running();
				}
			}
	}
	
	static win_game = function() {
		if(state == GAME_STATE.RUNNING) { //Shouldn't be able to win game if it's paused, already won, or already lost.
			state = GAME_STATE.VICTORY;
			with(controller_obj) {
				event_user(0);
				if(game_ui != undefined) {
					game_ui.set_gui_end_results(true);
				}
			}
		}
	}
	
	static lose_game = function() {
		if(state == GAME_STATE.RUNNING) { //Shouldn't be lose game if it's paused, already won, or already lost.
			state = GAME_STATE.DEFEAT;
			with(controller_obj) {
				event_user(1);
				if(game_ui != undefined) {
					game_ui.set_gui_end_results(false);
				}
			}
		}
	}
}
#endregion


#region Manager Fetchers
/*
	The below functions all are used for transfering data between components
	Fetches a controller/manager if needed by an external object or another controller/manager.
*/
#region get_game_controller (Function)
function get_game_controller() {
	var _game_controller = instance_find(game_controller_base, 0);
	return _game_controller
}
#endregion


#region get_game_state_manager (Function)
//NOTE: You can also pass a controller object if you have one so that you don't have to fetch it. Should save a tiny bit of time.
function get_game_state_manager(_controller_obj = undefined) {
	if(_controller_obj == undefined) {
		_controller_obj = get_game_controller();
	}
	if(_controller_obj == noone || !variable_instance_exists(_controller_obj, "game_state_manager")) {
		return undefined;
	}
	return _controller_obj.game_state_manager;
}
#endregion


#region get_round_manager (Function)
//NOTE: You can also pass a controller object if you have one so that you don't have to fetch it. Should save a tiny bit of time.
function get_round_manager(_controller_obj = undefined) {
	if(_controller_obj == undefined) {
		_controller_obj = get_game_controller();
	}
	if(_controller_obj == noone || !variable_instance_exists(_controller_obj, "round_manager")) {
		return undefined;
	}
	return _controller_obj.round_manager;
}
#endregion


#region get_purchase_manager (Function)
//NOTE: You can also pass a controller object if you have one so that you don't have to fetch it. Should save a tiny bit of time.
function get_purchase_manager(_controller_obj = undefined) {
	if(_controller_obj == undefined) {
		_controller_obj = get_game_controller();
	}
	if(_controller_obj == noone || !variable_instance_exists(_controller_obj, "purchase_manager")) {
		return undefined;
	}
	return _controller_obj.purchase_manager;
}
#endregion


#region get_camera_controller (Function)
//NOTE: You can also pass a controller object if you have one so that you don't have to fetch it. Should save a tiny bit of time.
function get_camera_controller(_controller_obj = undefined) {
	if(_controller_obj == undefined) {
		_controller_obj = get_game_controller();
	}
	if(_controller_obj == noone || !variable_instance_exists(_controller_obj, "camera_controller")) {
		return undefined;
	}
	return _controller_obj.camera_controller;
}
#endregion


#region get_music_manager (Function)
//NOTE: You can also pass a controller object if you have one so that you don't have to fetch it. Should save a tiny bit of time.
function get_music_manager(_controller_obj = undefined) {
	if(_controller_obj == undefined) {
		_controller_obj = get_game_controller();
	}
	if(_controller_obj == noone || !variable_instance_exists(_controller_obj, "music_manager")) {
		return undefined;
	}
	return _controller_obj.music_manager;
}
#endregion


#region get_game_ui (Function)
//Even though this doesn't have manager in the name, basically acts like one.
//NOTE: You can also pass a controller object if you have one so that you don't have to fetch it. Should save a tiny bit of time.
function get_game_ui(_controller_obj = undefined) {
	if(_controller_obj == undefined) {
		_controller_obj = get_game_controller();
	}
	if(_controller_obj == noone || !variable_instance_exists(_controller_obj, "game_ui")) {
		return undefined;
	}
	return _controller_obj.game_ui;
}
#endregion
#endregion