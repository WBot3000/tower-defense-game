/*
This file contains code for the UI
*/

global.PAUSE_SCREEN = -1;

#region GUI Layer Macros
#macro GUI_TRANSITION "Transition"
#macro GUI_VICTORY_SCREEN "VictoryScreen"
#macro GUI_DEFEAT_SCREEN "DefeatScreen"
#macro GUI_OPTIONS_MENU "OptionsMenuBase"
#macro GUI_TITLE_SCREEN "StartMenu"
#macro GUI_LEVEL_SELECT "LevelSelect"
#macro GUI_IN_GAME "GameUI"
#endregion

//Set the UI that should be used for the selected room
function set_ui(_ui_macro) {
	//Mutually exclusive GUI layers
	var _screen_types = [GUI_IN_GAME, GUI_TITLE_SCREEN, GUI_LEVEL_SELECT, GUI_VICTORY_SCREEN, GUI_DEFEAT_SCREEN]
	for(var i = 0, len = array_length(_screen_types); i < len; ++i) {
		layer_set_visible(_screen_types[i], _screen_types[i] == _ui_macro);
	}
}


enum SLIDING_MENU_STATE {
	CLOSED,
	CLOSING,
	OPENING,
	OPEN
}

#macro SLIDING_MENU_MOVEMENT_SPEED 20

#region Transitions
//Yay globals... (Should try and figure out another way to do this)
global.UPCOMING_ROOM = undefined
global.CURRENT_TRANSITION = undefined
global.POST_TRANSITION_CALLBACK = function(){}
function transition_to_new_room(_transition, _new_room) {
	global.UPCOMING_ROOM = _new_room;
	if(global.CURRENT_TRANSITION != undefined) {
		layer_sequence_destroy(global.CURRENT_TRANSITION);
	}
	global.CURRENT_TRANSITION = layer_sequence_create(GUI_TRANSITION, 0, 0, _transition);
}

//Call on creation of the room you're transitioning into
function room_intro_transition(_transition, _post_transition_callback = function(){}) {
	if(global.CURRENT_TRANSITION != undefined) { return; }
	global.POST_TRANSITION_CALLBACK = _post_transition_callback;
	/*
	if(global.CURRENT_TRANSITION != undefined) {
		layer_sequence_destroy(global.CURRENT_TRANSITION);
	}*/
	global.CURRENT_TRANSITION = layer_sequence_create(GUI_TRANSITION, 0, 0, _transition);
}

function transition_room_transfer() {
	room_goto(global.UPCOMING_ROOM);
	layer_sequence_destroy(global.CURRENT_TRANSITION);
	global.CURRENT_TRANSITION = undefined;
}

function post_transition_callback() {
	var _callback = global.POST_TRANSITION_CALLBACK;
	_callback();
	layer_sequence_destroy(global.CURRENT_TRANSITION);
	global.CURRENT_TRANSITION = undefined;
	//global.POST_TRANSITION_CALLBACK = function(){};
}
#endregion


function start_menu_start_button_click() {
	//Create transition, then go to level select room
	transition_to_new_room(screen_wipe_out, LevelSelectScreen);
}

function info_button_click() {
	//Create transition, then go to info room
	transition_to_new_room(screen_wipe_out, LevelSelectScreen) //TODO: Replace with level info room
}

function quit_game_button_click() {
	//TODO: Maybe add confirmation popup?
	game_end();
}


function change_purchase_menu_page(_new_page_num) {
	//Don't go beyond defined pages
	var _last_page_num = array_length(purchase_menu_base.purchase_list) - 1;
	if(_new_page_num < 0 || _new_page_num > _last_page_num) {
		return;
	}
	purchase_menu_base.current_page = _new_page_num;
	purchase_menu_previous_page_button.enabled = (_new_page_num > 0);
	purchase_menu_next_page_button.enabled = (_new_page_num < _last_page_num);
	
	var _current_page_data = purchase_menu_base.purchase_list[purchase_menu_base.current_page];
	with(unit_purchase_button) {
		if(array_length(_current_page_data) <= button_number) {
			current_purchase_data = undefined;
			image_alpha = 0;
		}
		else {
			current_purchase_data = _current_page_data[button_number];
			image_alpha = 1;
		}
	}
}


#region Options Menu
function open_options_menu() {
	layer_set_visible(GUI_OPTIONS_MENU, true);
	layer_set_visible(OPTIONS_PAGE_AUDIO, true);
}

function close_options_menu() {
	layer_set_visible(GUI_OPTIONS_MENU, false);
	layer_set_visible(OPTIONS_PAGE_AUDIO, false);
	layer_set_visible(OPTIONS_PAGE_VISUAL, false);
	layer_set_visible(OPTIONS_PAGE_CONTROLS, false);
}

#region Options Menu Macros
#macro OPTIONS_PAGE_AUDIO "OptionsAudio"
#macro OPTIONS_PAGE_VISUAL "OptionsVisual"
#macro OPTIONS_PAGE_CONTROLS "OptionsControls"
#endregion

function change_options_menu_page(_page_macro) {
	layer_set_visible(OPTIONS_PAGE_AUDIO, OPTIONS_PAGE_AUDIO == _page_macro);
	layer_set_visible(OPTIONS_PAGE_VISUAL, OPTIONS_PAGE_VISUAL == _page_macro);
	layer_set_visible(OPTIONS_PAGE_CONTROLS, OPTIONS_PAGE_CONTROLS == _page_macro);
	if(instance_exists(options_menu_base)) {
		options_menu_base.current_page = _page_macro;
	}
}

function change_music_volume(_new_volume) {
	global.GAME_CONFIG_OPTIONS.music_volume = _new_volume;
	global.BACKGROUND_MUSIC_MANAGER.adjust_volume();
}

function change_sound_effects_volume(_new_volume) {
	global.GAME_CONFIG_OPTIONS.sound_effects_volume = _new_volume;
}

function toggle_fullscreen() {
	window_set_fullscreen(!window_get_fullscreen());
}
#endregion