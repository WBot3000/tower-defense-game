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
global.player_money = 500;

#endregion


#region Game Manager Initializations
/*
	Manager objects used to further control game state
	Certain managers have this object passed in as reference for coordination purposes. It allows managers to "communicate" with each other
*/
//Default game state is RUNNING
game_state_manager = new GameStateManager(self.id);

round_manager = new RoundManager(self.id, array_length(current_level_data.round_data), current_level_data.round_data);

purchase_manager = new PurchaseManager();

camera_controller = new CameraController();

//music_manager = new MusicManager(Music_PreRound);
global.BACKGROUND_MUSIC_MANAGER.set_music(Music_PreRound);
#endregion


#region Purchase Data Initialization

purchase_data = [
	global.DATA_PURCHASE_DIRT,
	global.DATA_PURCHASE_COBBLESTONE,
	global.DATA_PURCHASE_GOLD,
	
	global.DATA_PURCHASE_SAMPLE_GUNNER,
	global.DATA_PURCHASE_SAMPLE_BRAWLER,
	global.DATA_PURCHASE_SAMPLE_MORTAR,
	
	global.DATA_PURCHASE_SAMPLE_GUNNER,
	global.DATA_PURCHASE_SAMPLE_BRAWLER,
	global.DATA_PURCHASE_SAMPLE_MORTAR,
	
	global.DATA_PURCHASE_SAMPLE_GUNNER,
	global.DATA_PURCHASE_SAMPLE_BRAWLER,
	global.DATA_PURCHASE_SAMPLE_MORTAR,
	
	global.DATA_PURCHASE_SAMPLE_GUNNER,
	global.DATA_PURCHASE_SAMPLE_BRAWLER,
	global.DATA_PURCHASE_SAMPLE_MORTAR,
	
	global.DATA_PURCHASE_SAMPLE_GUNNER,
	global.DATA_PURCHASE_SAMPLE_BRAWLER,
	global.DATA_PURCHASE_SAMPLE_MORTAR,
	
	global.DATA_PURCHASE_SAMPLE_GUNNER,
	global.DATA_PURCHASE_SAMPLE_BRAWLER,
	global.DATA_PURCHASE_SAMPLE_MORTAR,
	
	global.DATA_PURCHASE_SAMPLE_GUNNER,
	global.DATA_PURCHASE_SAMPLE_BRAWLER,
]

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


//NOTE: Delete this once testing
gui_timer = 0;