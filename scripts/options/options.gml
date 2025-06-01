/*
This file contains the data structure for managing game options, such as controls, visuals, and audio.
*/

/*
	Contains all of the configurations alongside functions for changing them.
*/
function OptionsManager() constructor{
	//Controls Settings
	controls = {
		pause_game_key: "Q",
		open_shop_key: "E",
		open_unit_info_key: "F"
	}
	
	//Audio Settings
	music_volume = 100;
	sound_effects_volume = 100;
	
	//Visual Settings
	is_fullscreen = false;
}

global.GAME_CONFIG_SETTINGS = new OptionsManager();