/*
This file contains code that does different things based on parameters provided when launching the exe

Currently just use to start the game muted because I'm lazy
*/

function command_line_parameters_on_game_start(){
	var _num_params = parameter_count();
	var _param_strings = []
	if(_num_params > 0) {
		for(var i = _num_params; i > 0; --i) {
			array_push(_param_strings, parameter_string(i));
		}
		
		if(array_contains(_param_strings, "muted")) {
			global.GAME_CONFIG_OPTIONS.music_volume = 0;
			global.GAME_CONFIG_OPTIONS.sound_effects_volume = 0;
		}
	}
}