/// @description Create game state, round data, money data, and wall data

//If this controller wasn't provided with any level data, throw an error
if(!variable_instance_exists(self.id, "current_level_data")) {
	throw("No level data provided for game controller instance " + string(self.id));
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
game_state_manager = new GameStateManager(self.id);

round_manager = new RoundManager(self.id, array_length(current_level_data.round_data), current_level_data.round_data);

purchase_manager = new PurchaseManager();

selected_entity_manager = new SelectedEntityManager();

camera_controller = new CameraController();

/*
	TODO: 
	Currently, several of these managers reference each other using fetching functions.
	In order to make sure the reference isn't undefined, either:
	1) Each time a manager is needed in another one, there is an attempt to fetch it
		(b/c when first initialized, these will be undefined, as the game_controller doesn't actually "exist" yet)
		(can cache them to prevent unnecessary fetches, but would still need to prevent the "fetch" code from running afterwards
	2) All the managers are defined in a strict order, so that ones that rely on other managers are declared after those other managers are declared
		(NOTE: This means that managers can't have any circular references (ex. round_manager references camera_controller, camera_controller references round_manager)
	To remove some instructions being done on each frame, potentially put these in an array, attempt to fetch all needed managers here, and then remove them from array when fetching is done so the code isn't run when it isn't needed
	Not doing this now since it might be overkill, but do want to keep this in mind
*/

#endregion


#region Camera Level-Start Movement Initialization
//NOTE: Make sure all the targets are initialized BEFORE this controller, otherwise this won't work properly
with(base_target) {
	other.camera_controller.add_instance_location_to_sequence(self)
}
//Go back to starting camera position once you've seen all the targets in the level
camera_controller.add_location_to_sequence(camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), 0);
#endregion


#region Purchase Data Initialization

purchase_data = [
	global.DATA_PURCHASE_DIRT,
	global.DATA_PURCHASE_COBBLESTONE,
	global.DATA_PURCHASE_GOLD,
	
	global.DATA_PURCHASE_CLOUD,
]

#endregion

//Fade out music from the Level Select screen
global.BACKGROUND_MUSIC_MANAGER.fade_out_current_music(seconds_to_roomspeed_frames(2));


#region GUI Data
game_ui = new GameUI(self.id, purchase_data);
/*
	Different game states use different sets of GUI elements 
	(ex. when the game is paused, the pause menu needs to be drawn)
	So to handle this, the GUI needs to be set to running mode.
	Normally, the Game State Manager handles this, but here is done manually the first time (since the Game State Manager is created before the GUI).
*/

transition_effect = new SwipeTransition()
//TODO: Uh oh, is this starting to become callback hell? I don't wanna rewrite Javascript async though.
//NOTE: Didn't do checks in callback functions because we KNOW these things exist at this point. If they don't, something's seriously gone wrong
transition_effect.transition_in(function() { //Callback after transition
		//This will kick off the camera's movement at the beginning of the level
		var _camera_controller = get_camera_controller();
		camera_controller.start_current_sequence(CAM_NUM_SECONDS_HANGING_DEFAULT/2,
			function() { //Callback after camera auto sequence
				/*
				var _game_state_manager = get_game_state_manager();
				_game_state_manager.resume_game();*/
				var _game_ui = get_game_ui();
				_game_ui.set_gui_intro();
			});
	});
#endregion