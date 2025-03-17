/// @description Create game state, round data, money data, and wall data

//If this controller wasn't provided with any level data, throw an error
if(!variable_instance_exists(self.id, "current_level_data")) {
	throw("No level data provided for game controller object " + string(self.id));
}

#region Global Variable Initializations
/*
	Global variables used to control game state
	Since these persist for the lifetime of the entire game, you need to make sure no funky side effects occur as a result.
	Ideally, you want to use as few of these as possible, and put more stuff on the level-scoped managers down below.
*/
global.player_money = 200;

global.defense_health = current_level_data.defense_health;
#endregion


#region Game Manager Initializations
/*
	Manager objects used to further control game state
	Certain managers have this object passed in as reference for coordination purposes. It allows managers to "communicate" with each other
*/
//Default game state is RUNNING
game_state_manager = new GameStateManager(self.id);

round_manager = new RoundManager(self.id, array_length(current_level_data.round_data), current_level_data.round_data);

camera_controller = new CameraController();

music_manager = new MusicManager(Music_PreRound);
#endregion


#region Purchase Data Initialization
//Data for purchases. Not really sure what to do with this just yet. Might make it it's own manager?
purchase_data = [
	global.DATA_PURCHASE_SAMPLE_GUNNER,
	global.DATA_PURCHASE_SAMPLE_BRAWLER,
	global.DATA_PURCHASE_SAMPLE_MORTAR,
]

//Which unit the user has selected (make this more sophisticated)
purchase_selected = undefined;
#endregion


#region GUI Data
game_ui = new GameUI(self.id, purchase_data);
/*
	Different game states use different sets of GUI elements 
	(ex. when the game is paused, the pause menu needs to be drawn)
	So to handle this, the GUI needs to be set to running mode.
	Normally, the Game State Manager handles this, but here is done manually the first time (since the Game State Manager is created before the GUI).
*/
game_ui.set_gui_running();
#endregion