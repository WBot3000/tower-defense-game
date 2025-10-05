/*
This file contains the data structure for managing game options, such as controls, visuals, and audio.
*/

/*
	Contains all of the configurations alongside functions for changing them.
*/
function OptionsManager() constructor {
	//Controls Settings
	controls = {
		pause_game_key: "Q",
		open_purchase_menu_key: "E",
		open_selected_entity_menu_key: "F"
	}
	
	//Audio Settings
	music_volume = 100;
	sound_effects_volume = 100;
	
	//Visual Settings (Probably don't have to actually store this, there's a built in function to get this value)
	//is_fullscreen = false;
}

global.GAME_CONFIG_OPTIONS = new OptionsManager();