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

//Fetches the game controller, and returns 


//Fetches a game controller in the event an instance needs to refer to it
/*
function get_game_controller() {
	var _game_controller = instance_find(game_controller_, 1);
	return _game_controller
}