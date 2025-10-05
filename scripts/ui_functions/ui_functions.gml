/*
This file contains code for the UI
*/

global.PAUSE_SCREEN = -1;

#region GUI Layer Macros
#macro GUI_TRANSITION "Transition"
#macro GUI_OPTIONS_MENU "OptionsMenuBase"
#macro GUI_TITLE_SCREEN "StartMenu"
#macro GUI_LEVEL_SELECT "LevelSelect"
#macro GUI_IN_GAME "GameUI"
#endregion

//Set the UI that should be used for the selected room
function set_ui(_ui_macro) {
	/*
	if (GUI_IN_GAME == _ui_macro) { 
		instance_activate_layer(GUI_IN_GAME)
	}
	else {
		instance_deactivate_layer(GUI_IN_GAME);
	}*/
	layer_set_visible(GUI_IN_GAME, GUI_IN_GAME == _ui_macro);
	/*
	if (GUI_TITLE_SCREEN == _ui_macro) { 
		instance_activate_layer(GUI_TITLE_SCREEN)
	}
	else {
		instance_deactivate_layer(GUI_TITLE_SCREEN);
	}*/
	layer_set_visible(GUI_TITLE_SCREEN, GUI_TITLE_SCREEN == _ui_macro);

	/*
	if (GUI_LEVEL_SELECT == _ui_macro) { 
		instance_activate_layer(GUI_LEVEL_SELECT)
	}
	else {
		instance_deactivate_layer(GUI_LEVEL_SELECT);
	}*/
	layer_set_visible(GUI_LEVEL_SELECT, GUI_LEVEL_SELECT == _ui_macro);
}


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


function change_purchase_menu_page(_new_page_num) {
	//Don't go beyond defined pages
	var _last_page_num = array_length(purchase_menu_base.purchase_list) - 1;
	if(_new_page_num < 0 || _new_page_num > _last_page_num) {
		return;
	}
	purchase_menu_base.current_page = _new_page_num;
	purchase_menu_previous_page_button.enabled = (_new_page_num > 0);
	purchase_menu_next_page_button.enabled = (_new_page_num < _last_page_num);
}


#region Selected Entity Menu
function initialize_selected_entity_picture() {
}
#endregion


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