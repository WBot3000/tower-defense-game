/*
This file contains functions that should be ran upon clicking 
*/

function start_menu_start_button_click() {
	//Create transition, then go to level select room
	transition_to_new_room(screen_wipe_out, LevelSelectScreen);
}

function options_button_click() {
	//Do any game pausing, then open up the options menu
}

function info_button_click() {
	//Create transition, then go to info room
	transition_to_new_room(screen_wipe_out, LevelSelectScreen) //TODO: Replace with level info room
}

function quit_game_button_click() {
	//TODO: Maybe add confirmation popup?
	game_end();
}