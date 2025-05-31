/*
	menus_and_ui.gml

	ORIGINAL DESCRIPTION:
	This file contains macros, structs, and functions for creating the various menus and UI elements in the game.
	Certain menus have different options based on different contexts. These let you control these options easily.
	
	NEW DESCRIPTION:
	Since the file was broken up, this now just contains the UI components for the game rounds
*/

#region PauseButton (Class)
/*
	Defines a button that can be clicked to pause the game
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
	game_controller: Game controller that manages the game that will be paused
*/
function PauseButton(_x_pos, _y_pos) :
		Button(_x_pos, _y_pos, spr_pause_menu_toggle) constructor {	
	
	static on_released = function() {
		var _game_state_manager = get_game_state_manager();
		if(_game_state_manager != undefined) {
			_game_state_manager.pause_game();
		}
	}
}
#endregion


#region RoundStartButton (Class)
/*
	Defines a button that can be clicked to trigger a round.
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
*/
function RoundStartButton(_x_pos, _y_pos) :
		Button(_x_pos, _y_pos, spr_round_start_button_enabled, spr_round_start_button_disabled, spr_round_start_button_enabled) constructor {
	cached_round_manager = get_round_manager();
	
	static is_enabled = function() {
		cached_round_manager = cached_round_manager ?? get_round_manager();
		//If round manager doesn't exist, or we're on the final round, you shouldn't be able to trigger more rounds.
		return cached_round_manager != undefined && (cached_round_manager.max_round > cached_round_manager.current_round);
	}
	
	
	static on_released = function() {
		if(is_enabled()) {
			if(global.BACKGROUND_MUSIC_MANAGER.current_music == Music_PreRound) {
				global.BACKGROUND_MUSIC_MANAGER.fade_out_current_music(seconds_to_milliseconds(QUICK_MUSIC_FADING_TIME), Music_Round);
			}
			//Round manager MUST exist if is_enabled returns true, so we don't have to check again in here.
			cached_round_manager.start_round();
		}
	}
}
#endregion


#region Options Menu Classes

#region ExitOptionsMenuButton (Class)
/*
	The button that closes the Options menu.
	
	Argument Variables:
	All correspond to Data Variables.
	
	Data Variables:
	x_pos: The x-coordinate of the top-left of the header.
	y_pos: The y-coordinate of the top-left of the header.
*/
function ExitOptionsMenuButton(_x_pos, _y_pos) : 
	Button(_x_pos, _y_pos, spr_close_button, spr_close_button, spr_close_button) constructor {
	
	static on_released = function() {
		parent.deactivate();
		//TODO: Move this to the ACTUAL PauseMenuExitButton
		var _game_state_manager = get_game_state_manager();
		if(_game_state_manager != undefined) {
			_game_state_manager.resume_game();
		}
	}
}
#endregion


#region OptionsMenuAudioTab (Class)
function OptionsMenuAudioTab(_x_pos, _y_pos) :
	PopupMenuTab(_x_pos, _y_pos, "Audio") constructor {

		static on_released = function() {
			parent.set_to_audio_options();
		}
}
#endregion


#region OptionsMenuVisualsTab (Class)
function OptionsMenuVisualsTab(_x_pos, _y_pos) :
	PopupMenuTab(_x_pos, _y_pos, "Visuals") constructor {
		
		static on_released = function() {
			parent.set_to_visual_options();
		}
}
#endregion


#region OptionsMenuControlsTab (Class)
function OptionsMenuControlsTab(_x_pos, _y_pos) :
	PopupMenuTab(_x_pos, _y_pos, "Controls") constructor {
		
		static on_released = function() {
			parent.set_to_control_options();
		}
}
#endregion


#region MusicVolumeSlider (Class)
function MusicVolumeSlider(_x_pos_left, _x_pos_right, _y_pos) : Slider(_x_pos_left, _x_pos_right, _y_pos, "Music Volume") constructor {
	static on_step_parent = on_step;
	static on_step = function() {
		on_step_parent();
		global.GAME_CONFIG_SETTINGS.music_volume = current_value
		global.BACKGROUND_MUSIC_MANAGER.adjust_volume();
	}
}
#endregion


#region SoundEffectsVolumeSlider (Class)
function SoundEffectsVolumeSlider(_x_pos_left, _x_pos_right, _y_pos) : Slider(_x_pos_left, _x_pos_right, _y_pos, "Sound Effects Volume") constructor {
	static on_step_parent = on_step;
	static on_step = function() {
		on_step_parent();
		global.GAME_CONFIG_SETTINGS.sound_effects_volume = current_value
	}
}
#endregion


#region SetFullscreenToggle (Class)
/*
	Defines a switch that can be clicked to toggle the game to fullscreen or windowed
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
*/
function SetFullscreenToggle(_x_pos, _y_pos) :
		ToggleSwitch(_x_pos, _y_pos, "Set Fullscreen") constructor {	
	
	//When this toggle is created, we need to check if the game is already in full-screen mode.
	//Otherwise, if this toggle is in full-screen mode when its created, it will do the reverse of what it's supposed to do (fullscreen when unchecked, windowed when checked)
	is_toggled = window_get_fullscreen();
	
	static on_toggle = function() { window_set_fullscreen(true); }
	static on_untoggle = function() { window_set_fullscreen(false); }
}
#endregion


#region OptionsMenu (Class)
/*
	Defines all of the data for the Options Menu
	
	Argument Variables:
	_menu_width_percentage: The percentage of the screen's width that the pause menu should take up.
	_menu_height_percentage: The percentage of the screen's height that the pause menu should take up.
	(All other argument variables correspond with non-underscored data variables)
	
	Data Variables:
	pause_background: Sprite used to show all the enemies while the game is paused.
*/

function OptionsMenu(_menu_width_percentage, _menu_height_percentage) : PopupMenu(_menu_width_percentage, _menu_height_percentage, "Options") constructor {
	pause_background = -1;
	
	close_button = new ExitOptionsMenuButton(menu_width - 40, 8);
	close_button.activate();
	
	var _tab_width = sprite_get_width(spr_menu_tab);
	var _tab_y = sprite_get_height(spr_menu_tab) * -1;
	
	audio_tab = new OptionsMenuAudioTab(-4, _tab_y);
	audio_tab.activate();
	visuals_tab = new OptionsMenuVisualsTab(_tab_width, _tab_y);
	visuals_tab.activate();
	controls_tab = new OptionsMenuControlsTab(2*_tab_width, _tab_y);
	controls_tab.activate();
	
	music_volume_slider = new MusicVolumeSlider(16, menu_width - 16, 128);
	music_volume_slider.activate();
	
	sound_effects_volume_slider = new SoundEffectsVolumeSlider(16, menu_width - 16, 192);
	sound_effects_volume_slider.activate();
	
	fullscreen_toggle = new SetFullscreenToggle(160, 96);
	
	pause_game_key_config = new KeyConfig(160, 96, "pause_game_key", "Pause Game");
	open_shop_key_config = new KeyConfig(160, 128 + 16, "open_shop_key", "Open Shop");
	open_unit_info_key_config = new KeyConfig(160, 161 + 32, "open_unit_info_key", "Show Unit Info");
	
	
	children = [close_button, audio_tab, visuals_tab, controls_tab, music_volume_slider, sound_effects_volume_slider, fullscreen_toggle,
		pause_game_key_config, open_shop_key_config, open_unit_info_key_config];
	
	
	static set_to_audio_options = function() {
		music_volume_slider.activate();
		sound_effects_volume_slider.activate();
		
		fullscreen_toggle.deactivate();
		pause_game_key_config.deactivate();
		open_shop_key_config.deactivate();
		open_unit_info_key_config.deactivate();
	}
	
	static set_to_visual_options = function() {
		fullscreen_toggle.activate();
		
		music_volume_slider.deactivate();
		sound_effects_volume_slider.deactivate();
		pause_game_key_config.deactivate();
		open_shop_key_config.deactivate();
		open_unit_info_key_config.deactivate();
	}
	
	static set_to_control_options = function() {
		pause_game_key_config.activate();
		open_shop_key_config.activate();
		open_unit_info_key_config.activate();
		
		music_volume_slider.deactivate();
		sound_effects_volume_slider.deactivate();
		fullscreen_toggle.deactivate();
	}
	
	
	static clean_up = function() {
		if(pause_background != -1) {
			sprite_delete(pause_background);
		}
	}
}
#endregion

#endregion


#region Sliding Menu Variables (Etc.)
/*
	Unit Purchase Menu Macros and Enums
*/
//How many pixels the menu should move per frame
#macro SLIDING_MENU_MOVEMENT_SPEED 32

//Enums for Unit Purchase Menu state
enum SLIDING_MENU_STATE {
	CLOSED,
	CLOSING, //For closing animation
	OPENING, //For opening animation
	OPEN
}
#endregion


#region Unit Purchase Menu Classes
#macro PURCHASE_MENU_BPROW 3 //BPROW = Buttons Per Row
#macro PURCHASE_MENU_BPCOL 3 //BPCOL = Buttons Per Page
#macro PURCHASE_MENU_BPPAGE (PURCHASE_MENU_BPROW * PURCHASE_MENU_BPCOL) //BPPAGE = Buttons Per Page

#region UnitPurchaseButton (Class)
/*
	Defines a button for purchases in the Unit Selection Menu.
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
	purchase_data: The purchasing data that corresponds with the button.
*/
function UnitPurchaseButton(_x_pos, _y_pos, _purchase_data) : 
		Button(_x_pos, _y_pos, spr_unit_purchase_button_default, spr_unit_purchase_button_disabled, spr_unit_purchase_button_highlighted) constructor {
	
	purchase_data = _purchase_data;
	
	cached_game_state_manager = get_game_state_manager();
	
	
	static is_enabled = function() {
		return global.player_money >= purchase_data.price;
	}
	

	static draw_parent = draw;
	// _button_highlight_enabled lets you turn of the button highlighting while the game is paused
	static draw = function(_button_highlight_enabled = true) {
		draw_parent(x_pos, y_pos, _button_highlight_enabled && cached_game_state_manager != undefined && cached_game_state_manager.state == GAME_STATE.RUNNING);
		draw_sprite(object_get_sprite(purchase_data.unit), 0, x_pos + 8 + TILE_SIZE/2, y_pos + 4 + TILE_SIZE);
		draw_set_halign(fa_right);
		draw_text(x_pos + sprite_get_width(button_sprite_default) - 8, y_pos + 72, string(purchase_data.price));
		draw_set_halign(fa_left);
	}
	
	
	static on_released = function() {
		if(cached_game_state_manager == undefined || cached_game_state_manager.state != GAME_STATE.RUNNING) {
			return; //You should only be able to select units while the game is running
		}
		var _purchase_manager = get_purchase_manager();
		if(_purchase_manager != undefined) {
			_purchase_manager.set_selected_purchase(purchase_data);
		}
	}
}
#endregion


#region PreviousPagePurchaseMenuButton (Class)
/*
	Button for going to the purchase menu's previous page.
	
	Argument Variables:
	All correspond to data variables.
	
	Data Variables:
	x_pos: X coordinate of the button's top left corner in relation to the purchase menu
	y_pos: Y coordinate of the button's top left corner in relation to the purchase menu
*/
function PreviousPagePurchaseMenuButton(_x_pos, _y_pos) :
	Button(_x_pos, _y_pos, spr_page_left_default, spr_page_left_disabled) constructor {
	
	static is_enabled = function() {
		return parent.current_page > 0; //Parent is the Purchase Menu struct itself
	}
	
	static on_released = function() {
		if(is_enabled()) {
			for(var i = parent.current_page * PURCHASE_MENU_BPPAGE; i < (parent.current_page+1) * PURCHASE_MENU_BPPAGE && i < array_length(parent.purchase_buttons); ++i) {
				parent.purchase_buttons[i].deactivate();
			}
			parent.current_page--;
			for(var i = parent.current_page * PURCHASE_MENU_BPPAGE; i < (parent.current_page+1) * PURCHASE_MENU_BPPAGE && i < array_length(parent.purchase_buttons); ++i) {
				parent.purchase_buttons[i].activate();
			}
		}
	}
	
}
#endregion


#region NextPagePurchaseMenuButton (Class)
/*
	Button for going to the purchase menu's next page.
	
	Argument Variables:
	All correspond to data variables.
	
	Data Variables:
	x_pos: X coordinate of the button's top left corner in relation to the purchase menu
	y_pos: Y coordinate of the button's top left corner in relation to the purchase menu
*/
function NextPagePurchaseMenuButton(_x_pos, _y_pos) :
	Button(_x_pos, _y_pos, spr_page_right_default, spr_page_right_disabled) constructor {
	
	static is_enabled = function() {
		return array_length(parent.purchase_buttons) > (parent.current_page + 1) * PURCHASE_MENU_BPPAGE;
	}
	
	static on_released = function() {
		if(is_enabled()) {
			for(var i = parent.current_page * PURCHASE_MENU_BPPAGE; i < (parent.current_page+1) * PURCHASE_MENU_BPPAGE && i < array_length(parent.purchase_buttons); ++i) {
				parent.purchase_buttons[i].deactivate();
			}
			parent.current_page++;
			for(var i = parent.current_page * PURCHASE_MENU_BPPAGE; i < (parent.current_page+1) * PURCHASE_MENU_BPPAGE && i < array_length(parent.purchase_buttons); ++i) {
				parent.purchase_buttons[i].activate();
			}
		}
	}
	
}
#endregion


#region TogglePurchaseMenuButton (Class)
/*
	Defines a button to toggle the Unit Selection Menu between opened and closed.
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
	purchase_menu: Reference to the purchase menu that this button belongs to
*/
function TogglePurchaseMenuButton(_x_pos, _y_pos) :
	Button(_x_pos, _y_pos, spr_pointer_arrow_left) constructor {
	
	static on_released = function() {
		switch (parent.state) {
		    case SLIDING_MENU_STATE.OPEN:
		        parent.toggle_closed();
		        break;
			case SLIDING_MENU_STATE.CLOSED:
				parent.toggle_open();
		        break;
		    default:
		        break;
		}
	}
}
#endregion


#region UnitPurchaseMenu (Class)
/*
	Defines all the data for the Unit Purchase Menu.
	
	Argument Variables:
	_menu_width_percentage: A value from 0 to 1 representing what percentage of the screen's width the menu should take up.
	_purchase_data_list: The purchasing data array that corresponds with the buttons.
	(All other argument variables correspond with non-underscored data variables)
	
	Data Variables:
	state: Whether the menu is open, opening, closing, or closed.
	x_pos_open: Horizontal coordinate of the menu's top-left corner when the menu is open.
	x_pos_current: Current horizontal coordinate of the menu's top-left corner (useful for scrolling).
	y_pos: Vertical coordinate of the menu's top-right corner when the menu is open.
	purchase_buttons: All of the unit purchase buttons within the menu itself.
	toggle_button: Button that toggles the menu state
*/
//How much of the screen should the unit purchase menu take up while it is open
#macro PURCHASE_MENU_SCREEN_PERCENTAGE (2/7)

function UnitPurchaseMenu(_purchase_data_list) : UIComponent() constructor {
	state = SLIDING_MENU_STATE.CLOSED; //Whether the menu on the side is opened or closed

	x_pos_open = (1-PURCHASE_MENU_SCREEN_PERCENTAGE) * view_w;
	x_pos = view_w; //Window should start out closed

	menu_width = view_w - x_pos_open;
	menu_height = view_h*(1-UNIT_INFO_CARD_SCREEN_PERCENTAGE);
	
	
	current_page = 0;
	prev_page_button = new PreviousPagePurchaseMenuButton(64, menu_height - 40);
	prev_page_button.activate();
	next_page_button = new NextPagePurchaseMenuButton(menu_width - sprite_get_width(spr_page_right_default) - 64 , menu_height - 40);
	next_page_button.activate();
	
	toggle_button = new TogglePurchaseMenuButton(-32, (menu_height - sprite_get_width(spr_pointer_arrow_left))/2);
	toggle_button.activate();
	

	//Array that contains all of the button data. Kept seperate from UI elements so they can be iterated independently from them.
	//NOTE: You can technically just do the same thing with an offset, but I wanted to make purchase button iteration independent from all the other UI elements present in the menu.
	purchase_buttons = [];
	children = [prev_page_button, next_page_button, toggle_button];
	
	var _button_width = sprite_get_width(spr_unit_purchase_button_default);
	var _button_height = sprite_get_height(spr_unit_purchase_button_default);

	var _x_gap = (menu_width - PURCHASE_MENU_BPROW*_button_width) / (PURCHASE_MENU_BPROW + 1); //Gap in between buttons (also used as x_margins)
	var _button_x = _x_gap;
	var _button_y = TILE_SIZE;
	var _init_button_y = TILE_SIZE;
	
	var _activate_first_page = true; //For the first page of buttons, make sure to activate them.
	//Create buttons
	for(var i = 0; i < array_length(_purchase_data_list); ++i) {
		var _button = new UnitPurchaseButton(_button_x, _button_y, _purchase_data_list[i])
		array_push(purchase_buttons, _button);
		array_push(children, _button);
		
		if(_activate_first_page) {
			_button.activate();
		}
		
		_button_x += (_button_width + _x_gap);
		
		if(i % PURCHASE_MENU_BPROW == PURCHASE_MENU_BPROW - 1) { //Time to start a new row
			_button_x = _x_gap;
			_button_y += _button_height + 4;
			if(i % PURCHASE_MENU_BPPAGE == PURCHASE_MENU_BPPAGE - 1) { //Time to start a new page
				_button_y = _init_button_y;
				_activate_first_page = false; //Not on first page anymore, don't activate these buttons
			}
		}
	}
	
	
	static is_highlighted = function() {
		return (device_mouse_x_to_gui(0) >= x_pos && menu_height >= device_mouse_y_to_gui(0)) || 
			toggle_button.is_highlighted(x_pos, 0); 
	}
	
	
	static draw_parent = draw;
	static draw = function() {
		draw_rectangle_color(x_pos, 0, view_w, menu_height, c_silver, c_silver, c_silver, c_silver, false);
		
		draw_set_alignments(fa_center, fa_center);
		draw_text_color(x_pos + menu_width/2 , TILE_SIZE/2, "PURCHASE", c_black, c_black, c_black, c_black, 1);
		draw_set_alignments();
		
		draw_parent();
	}
	
	
	static toggle_open = function() {
		var _game_state_manager = get_game_state_manager();
		if(_game_state_manager && _game_state_manager.state != GAME_STATE.PAUSED) { //Don't do any toggling if the game is paused
			play_sound_effect(SFX_Menu_Open);
			state = SLIDING_MENU_STATE.OPENING;
		}
	}
	
	
	static toggle_closed = function() {
		var _game_state_manager = get_game_state_manager();
		if(_game_state_manager && _game_state_manager.state != GAME_STATE.PAUSED) {
			play_sound_effect(SFX_Menu_Close);
			state = SLIDING_MENU_STATE.CLOSING;
		}
	}
	
	
	//This function moves the menu based on its current state. Also accepts a menu toggle boolean
	//Shoud be called in a Step event.
	static on_step = function() {
		var _x_delta = 0;
		switch (state) {
			case SLIDING_MENU_STATE.CLOSED:
				if(keyboard_check_pressed(ord(global.GAME_CONFIG_SETTINGS.controls.open_shop_key))) {
					toggle_open();
				}
			    break;
			case SLIDING_MENU_STATE.CLOSING:
				_x_delta = min(SLIDING_MENU_MOVEMENT_SPEED, view_w - x_pos); //Move to the right, up to the right side of the screen
				move(_x_delta, 0);
				parent.pause_button.move(_x_delta, 0);
				if(x_pos >= view_w) {
					state = SLIDING_MENU_STATE.CLOSED;
				}
				break;
			case SLIDING_MENU_STATE.OPENING:
				_x_delta = max(SLIDING_MENU_MOVEMENT_SPEED * -1, x_pos_open - x_pos); //Move to the left, up to the open position
				move(_x_delta, 0);
				parent.pause_button.move(_x_delta, 0);
				if(x_pos <= x_pos_open) {
					state = SLIDING_MENU_STATE.OPEN;
				}
				break;
			case SLIDING_MENU_STATE.OPEN:
				if(keyboard_check_pressed(ord(global.GAME_CONFIG_SETTINGS.controls.open_shop_key))) {
					toggle_closed();
				}
				break;
			default:
			    break;
		}
	}
	
}
#endregion


#endregion


#region Unit Info Card Classes

#macro STAT_BUTTON_SIZE sprite_get_width(spr_stat_icon)

#region StatUpgradeButton (Class)
/*
	The button that should be clicked to purchase an upgrade
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal position of the left of the upgrade info (relative to the UnitInfoCard)
	y_pos: Vertical position of the top of the upgrade info (relative to the UnitInfoCard)
	stat_upgrade_data: Unit's upgrade data that should be displayed
	
	NOTE: All of these variables should be passed from the UnitInfoCardStatUpgrade
*/
function StatUpgradeButton(_x_pos, _y_pos, _stat_upgrade_data = undefined) :
	Button(_x_pos, _y_pos, spr_upgrade_purchase_default, spr_upgrade_purchase_disabled) constructor {

	stat_upgrade_data = _stat_upgrade_data;
	
	static draw_parent = draw;
	static draw = function() {		
		if(stat_upgrade_data == undefined) {
			draw_sprite(spr_blank_stat_icon, 0, x_pos, y_pos);
			return; //No drawing needed for a stat that doesn't exist
		}

		draw_parent();
		
		draw_set_alignments(fa_right, fa_bottom);
		if(stat_upgrade_data.current_level >= stat_upgrade_data.max_level) {
			draw_text_color(x_pos + sprite_get_width(button_sprite_default)*0.9,
				y_pos + sprite_get_height(stat_upgrade_data.upgrade_spr) - 4, "MAX", 
				c_white, c_white, c_white, c_white, 1);
		}
		else {
			draw_text_color(x_pos + sprite_get_width(button_sprite_default)*0.9, 
				y_pos + sprite_get_height(stat_upgrade_data.upgrade_spr) - 4, stat_upgrade_data.current_price, 
				c_white, c_white, c_white, c_white, 1);
		}
		draw_set_alignments();
	}
	
	static is_enabled = function() {
		return (stat_upgrade_data != undefined 
			&& global.player_money >= stat_upgrade_data.current_price 
			&& stat_upgrade_data.current_level < stat_upgrade_data.max_level);
	}
	
	static on_released = function() {
		if(stat_upgrade_data != undefined) {
			global.player_money -= stat_upgrade_data.current_price;
			stat_upgrade_data.on_upgrade();
		}
	}
	
}
#endregion


#region StatUpgradeDisplay (Class)
/*
	Used to display a stat upgrade button alongside its graphic.
	
	Argument Variables:
	
	Data Variables:
	x_pos: Horizontal position of the left of the upgrade info (relative to the UnitInfoCard)
	y_pos: Vertical position of the top of the upgrade info (relative to the UnitInfoCard)
	stat_upgrade_data: Unit's upgrade data that should be displayed
	(For draw_stat_level):
	stat_level: The level of the stat being displayed
*/
function draw_stat_level(_x_pos, _y_pos, _stat_level) {
	draw_set_alignments(fa_right, fa_bottom);
	//Draws the number to the right
	draw_text_color(_x_pos + STAT_BUTTON_SIZE*0.9,
		_y_pos + STAT_BUTTON_SIZE - 4,
		_stat_level,
		c_white, c_white, c_white, c_white, 1);
	draw_set_alignments();
}

function StatUpgradeDisplay(_x_pos, _y_pos) : UIComponent(_x_pos, _y_pos) constructor {
	stat_upgrade_data = undefined;
	selected_unit = noone;
	
	stat_upgrade_button = new StatUpgradeButton(0, STAT_BUTTON_SIZE);
	stat_upgrade_button.activate();
	
	children = [stat_upgrade_button];
	
	static draw_parent = draw;
	static draw = function() {
		if(selected_unit == noone) {
			return; //Nothing to draw
		}

		if(stat_upgrade_data != undefined) { //Draw blank space if you need to 
			draw_sprite(stat_upgrade_data.upgrade_spr, 0, 
				x_pos, y_pos);
			draw_stat_level(x_pos, y_pos, stat_upgrade_data.current_level)
		}
		else {
			draw_sprite(spr_blank_stat_icon, 0, x_pos, y_pos);
		}
		draw_parent();
	}
	
	
	static on_selected_unit_change = function(_new_stat_data, _new_selected_unit) {
		stat_upgrade_data = _new_stat_data;
		stat_upgrade_button.stat_upgrade_data = _new_stat_data;
		selected_unit = _new_selected_unit;
	}
}
#endregion


#region UnitUpgradeButton (Class)
/*
	Button clicked to upgrade a unit into a different one.
*/
function UnitUpgradeButton(_x_pos, _y_pos, _unit_upgrade_data = undefined, _selected_unit = noone) : 
		Button(_x_pos, _y_pos, spr_unit_purchase_button_default, spr_unit_purchase_button_disabled, spr_unit_purchase_button_highlighted) constructor {
			
	unit_upgrade_data = _unit_upgrade_data;
	selected_unit = _selected_unit;
	
	
	static is_enabled = function() {
		return (selected_unit != noone && unit_upgrade_data != undefined && global.player_money >= unit_upgrade_data.price &&
			selected_unit.stat_upgrades[0].current_level >= unit_upgrade_data.level_req_1 &&
			selected_unit.stat_upgrades[1].current_level >= unit_upgrade_data.level_req_2 &&
			selected_unit.stat_upgrades[2].current_level >= unit_upgrade_data.level_req_3)
	}
	
	
	static on_selected_unit_change = function(_new_upgrade_data, _new_selected_unit) {
		unit_upgrade_data = _new_upgrade_data;
		selected_unit = _new_selected_unit;
	}
	

	static draw_parent = draw;
	

	// _button_highlight_enabled lets you turn of the button highlighting while the game is paused
	static draw = function(_button_highlight_enabled = true) {
		if(selected_unit == noone) {
			return; //Nothing to draw
		}
		
		draw_parent(_button_highlight_enabled);
		if(unit_upgrade_data != undefined) {
			draw_sprite(object_get_sprite(unit_upgrade_data.upgrade_to), 0, x_pos + 8 + TILE_SIZE/2, y_pos + 4 + TILE_SIZE);
			draw_set_halign(fa_right);
			draw_text(x_pos + sprite_get_width(button_sprite_default) - 8, y_pos + 72, string(unit_upgrade_data.price));
			draw_set_halign(fa_left);
		}
	}
	
	static on_released = function() {
		if(unit_upgrade_data != undefined) {
			global.player_money -= unit_upgrade_data.price;
			with(selected_unit) {	
				instance_change(other.unit_upgrade_data.upgrade_to, false);
			}
		}
	}
}
#endregion


#region TargetingIndicator (Class)
/*
	Indicator that shows what kind of targeting a unit is currently using.
*/
#macro TARGETING_INDICATOR_WIDTH 96
#macro TARGETING_INDICATOR_HEIGHT 24
function TargetingIndicator(_x_pos, _y_pos) : UIComponent(_x_pos, _y_pos) constructor {
	selected_unit = noone;
	
	static is_highlighted = function() {
		var _mouse_x_gui = device_mouse_x_to_gui(0);
		var _mouse_y_gui = device_mouse_y_to_gui(0);
		
		return (_mouse_x_gui >= x_pos && _mouse_x_gui <= x_pos + TARGETING_INDICATOR_WIDTH &&
			_mouse_y_gui >= y_pos && _mouse_y_gui <= y_pos + TARGETING_INDICATOR_HEIGHT)
	}
	
	
	static draw = function() {
		if(selected_unit == noone || array_length(selected_unit.targeting_tracker.potential_targeting_types) == 0) {
			return;
		}

		var _targeting_type = selected_unit.targeting_tracker.get_current_targeting_type();
		
		draw_rectangle_color(x_pos, y_pos, 
			x_pos + TARGETING_INDICATOR_WIDTH, y_pos + TARGETING_INDICATOR_HEIGHT,
			c_ltgray, c_ltgray, c_ltgray, c_ltgray, false)
		draw_set_halign(fa_center);
		draw_text(x_pos + 48, y_pos, _targeting_type.targeting_name);
		draw_set_halign(fa_left);
	}
}
#endregion


#region SellButton (Class)
/*
	Button clicked to sell a unit for cash back
*/
function SellButton(_x_pos, _y_pos, _selected_unit = noone) :
		Button(_x_pos, _y_pos, spr_sell_button_default, spr_sell_button_disabled, spr_sell_button_default) constructor {

	selected_unit = _selected_unit;
	
	static is_enabled = function() {
		return selected_unit != noone;
	}
	
	//_x_offset and _y_offset are the origins of the menu
	// _button_highlight_enabled lets you turn of the button highlighting while the game is paused
	static draw = function(_x_offset, _y_offset, _button_highlight_enabled = true) {
		if(selected_unit == noone) {
			return; //Nothing to draw
		}
		
		draw_sprite(button_sprite_default, 0, x_pos, y_pos);
		draw_set_alignments(fa_right, fa_center);
		draw_text(x_pos + sprite_get_width(button_sprite_default) - 8, y_pos + sprite_get_height(button_sprite_default)/2, string(selected_unit.sell_price));
		draw_set_alignments();
	}
	
	static on_released = function() {
		if(selected_unit != noone) {
			//Since the origin of units is centre-bottom, check one point above the origin for the tile. Otherwise, we accidentally mark the tile below as free for placement.
			var _tile = instance_position(selected_unit.x, selected_unit.y - 1, placeable_tile);
			_tile.placed_unit = noone;
			global.player_money += selected_unit.sell_price;
			instance_destroy(selected_unit);
			parent.on_selected_unit_change(noone); //Don't want this menu referencing a unit that doesn't exist anymore
		}
	}
}
	
#endregion


#region ToggleInfoCardButton (Class)
/*
	Defines a button to toggle the Unit Info Card between opened and closed.
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
*/
function ToggleInfoCardButton(_x_pos, _y_pos) :
	Button(_x_pos, _y_pos, spr_pointer_arrow_up) constructor {
	
	static on_released = function() {
		switch (parent.state) {
		    case SLIDING_MENU_STATE.OPEN:
		        parent.toggle_closed();
		        break;
			case SLIDING_MENU_STATE.CLOSED:
				parent.toggle_open();
		        break;
		    default:
		        break;
		}
	}
		
}
#endregion


#region UnitInfoCard (Class)
#macro UNIT_INFO_CARD_SCREEN_PERCENTAGE (1/4)
/*
	Defines all the data for the Unit Info Card.
	
	Argument Variables:
	_menu_height_percentage: How much screen space the menu should take up.
	(All other argument variables correspond with non-underscored data variables)
	
	Data Variables:
	state: Whether the menu is open, opening, closing, or closed.
	selected_unit: The field unit most recently clicked on or purchased.
	x_pos: Horizontal coordinate of the menu's top-right corner when the menu is open.
	y_pos_open: Vertical coordinate of the menu's top-left corner when the menu is open.
	stat_upgrade_buttons: Contains all the buttons for stat upgrades
	unit_upgrade_button_(1,2,3): Buttons for unit upgrades
	targeting_indicator: Targeting indicator that displays the targeting type the unit is currently using
	sell_button: Button for selling the unit in the unit info card.
	toggle_button: Button for opening and closing the unit info card.
*/

function UnitInfoCard() : UIComponent() constructor {
	state = SLIDING_MENU_STATE.CLOSED; //Whether the menu on the bottom is opened or closed
	selected_unit = noone;
	cached_game_state_manager = get_game_state_manager();
	
	y_pos_open = (1-UNIT_INFO_CARD_SCREEN_PERCENTAGE) * view_h; //NOTE: Is an absolute position
	y_pos = view_h; //Hack since this absolute and relative coordinates are the same.
	
	//Stat Upgrade Info
	stat_upgrade_button_1 = new StatUpgradeDisplay(TILE_SIZE*4.5, TILE_SIZE/2);
	stat_upgrade_button_1.activate();
	stat_upgrade_button_2 = new StatUpgradeDisplay(TILE_SIZE*5.25, TILE_SIZE/2);
	stat_upgrade_button_2.activate();
	stat_upgrade_button_3 = new StatUpgradeDisplay(TILE_SIZE*6, TILE_SIZE/2);
	stat_upgrade_button_3.activate();
	stat_upgrade_button_4 = new StatUpgradeDisplay(TILE_SIZE*6.75, TILE_SIZE/2);
	stat_upgrade_button_4.activate();
	//For iterating through the stat upgrade buttons
	stat_upgrade_buttons = [stat_upgrade_button_1, stat_upgrade_button_2, stat_upgrade_button_3, stat_upgrade_button_4];
	
	//Unit Upgrade Info
	unit_upgrade_button_1 = new UnitUpgradeButton(TILE_SIZE*8, TILE_SIZE/2, undefined, noone);
	unit_upgrade_button_1.activate();
	unit_upgrade_button_2 = new UnitUpgradeButton(TILE_SIZE*9.5, TILE_SIZE/2, undefined, noone);
	unit_upgrade_button_2.activate();
	unit_upgrade_button_3 = new UnitUpgradeButton(TILE_SIZE*11, TILE_SIZE/2, undefined, noone);
	unit_upgrade_button_3.activate();
	
	//Targeting Indicator
	targeting_indicator = new TargetingIndicator(TILE_SIZE*2.5, TILE_SIZE*1.5);
	targeting_indicator.activate();
	
	//Sell Button
	sell_button = new SellButton(TILE_SIZE*13, TILE_SIZE/4, noone);
	sell_button.activate();
	
	//Menu Toggle Button
	toggle_button = new ToggleInfoCardButton((view_w - sprite_get_width(spr_pointer_arrow_up))/2,  -32);
	toggle_button.activate();
	
	children = [stat_upgrade_button_1, stat_upgrade_button_2, stat_upgrade_button_3, stat_upgrade_button_4,
		unit_upgrade_button_1, unit_upgrade_button_2, unit_upgrade_button_3,
		targeting_indicator, sell_button, toggle_button];
	
	//Called when the selected unit is changed
	static on_selected_unit_change = function(_new_selected_unit) {
		selected_unit = _new_selected_unit;
		sell_button.selected_unit = selected_unit
		targeting_indicator.selected_unit = selected_unit;
		
		if(_new_selected_unit != noone) {
			stat_upgrade_button_1.on_selected_unit_change(selected_unit.stat_upgrades[0], selected_unit);
			stat_upgrade_button_2.on_selected_unit_change(selected_unit.stat_upgrades[1], selected_unit);
			stat_upgrade_button_3.on_selected_unit_change(selected_unit.stat_upgrades[2], selected_unit);
			stat_upgrade_button_4.on_selected_unit_change(selected_unit.stat_upgrades[3], selected_unit);
			unit_upgrade_button_1.on_selected_unit_change(selected_unit.unit_upgrade_1, selected_unit);
			unit_upgrade_button_2.on_selected_unit_change(selected_unit.unit_upgrade_2, selected_unit);
			unit_upgrade_button_3.on_selected_unit_change(selected_unit.unit_upgrade_3, selected_unit);
		}
		else {
			stat_upgrade_button_1.on_selected_unit_change(undefined, noone);
			stat_upgrade_button_2.on_selected_unit_change(undefined, noone);
			stat_upgrade_button_3.on_selected_unit_change(undefined, noone);
			stat_upgrade_button_4.on_selected_unit_change(undefined, noone);
			unit_upgrade_button_1.on_selected_unit_change(undefined, noone);
			unit_upgrade_button_2.on_selected_unit_change(undefined, noone);
			unit_upgrade_button_3.on_selected_unit_change(undefined, noone);
		}
	}

	
	static is_highlighted = function() {
		//Need to include check for toggle button, since it peaks past the normal boundaries of the menu
		return device_mouse_y_to_gui(0) >= y_pos || toggle_button.is_highlighted(); 
	}
	
	
	static draw_parent = draw;
	static draw = function() {		
		draw_rectangle_color(0, y_pos, view_w, view_h, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
		draw_parent(0, 0);
		if(selected_unit != noone) {
			draw_sprite(selected_unit.sprite_index, 0, TILE_SIZE, y_pos + 5*TILE_SIZE/4);
		}
		
		//Draw any necessary highlights. This is done after all of the other drawing so that they'll always be on top.
		for(var i = 0; i < array_length(stat_upgrade_buttons); i++) {
			var _mouse_x_gui = device_mouse_x_to_gui(0);
			var _mouse_y_gui = device_mouse_y_to_gui(0);
			var _region_highlighted = _mouse_x_gui >= stat_upgrade_buttons[i].x_pos && _mouse_x_gui <= stat_upgrade_buttons[i].x_pos + STAT_BUTTON_SIZE &&
				_mouse_y_gui >= stat_upgrade_buttons[i].y_pos && _mouse_y_gui <= stat_upgrade_buttons[i].y_pos + STAT_BUTTON_SIZE
					
			if(stat_upgrade_buttons[i].stat_upgrade_data != undefined && _region_highlighted) { //Need more than just standard highlight since this should include the icon along with the button
				draw_highlight_info(stat_upgrade_buttons[i].stat_upgrade_data.title, 
				stat_upgrade_buttons[i].stat_upgrade_data.description);
				break; //Only need to draw one highlight
			}
		}
		
	}
	
	
	static toggle_open = function() {
		var _game_state_manager = get_game_state_manager();
		if(_game_state_manager && _game_state_manager.state != GAME_STATE.PAUSED) { //Don't do any toggling if the game is paused
			play_sound_effect(SFX_Menu_Open);
			state = SLIDING_MENU_STATE.OPENING;
		}
	}
	
	
	static toggle_closed = function() {
		var _game_state_manager = get_game_state_manager();
		if(_game_state_manager && _game_state_manager.state != GAME_STATE.PAUSED) { //Don't do any toggling if the game is paused
			play_sound_effect(SFX_Menu_Close);
			state = SLIDING_MENU_STATE.CLOSING;
		}
	}
	
	
	//This function moves the menu based on its current state. Also accepts a menu toggle boolean
	//Shoud be called in a Step event.
	static on_step = function() {
		var _y_delta = 0;
		switch (state) {
			case SLIDING_MENU_STATE.CLOSED:
				if(keyboard_check_pressed(ord(global.GAME_CONFIG_SETTINGS.controls.open_unit_info_key))) {
					toggle_open();
				}
			    break;
			case SLIDING_MENU_STATE.CLOSING:
				_y_delta = min(SLIDING_MENU_MOVEMENT_SPEED, view_h - y_pos);
				move(0, _y_delta);
				parent.round_start_button.move(0, _y_delta);
				if(y_pos >= view_h) {
					state = SLIDING_MENU_STATE.CLOSED;
				}
				break;
			case SLIDING_MENU_STATE.OPENING:
				_y_delta = max(SLIDING_MENU_MOVEMENT_SPEED * -1, y_pos_open - y_pos);
				move(0, _y_delta);
				parent.round_start_button.move(0, _y_delta);
				if(y_pos <= y_pos_open) {
					state = SLIDING_MENU_STATE.OPEN;
				}
				break;
			case SLIDING_MENU_STATE.OPEN:
				if(keyboard_check_pressed(ord(global.GAME_CONFIG_SETTINGS.controls.open_unit_info_key))) {
					toggle_closed();
				}
				break;
			default:
			    break;
		}
	}
}
#endregion

#endregion


#region GameInfoDisplay (Class)
/*
	Used for displaying basic game info (Round number, current money, current defense health)
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	controller_obj: Game controller object that manages game state.
*/
#macro GAME_INFO_DISPLAY_WIDTH TILE_SIZE*3
#macro GAME_INFO_DISPLAY_HEIGHT TILE_SIZE*1.5

function GameInfoDisplay(_controller_obj) : UIComponent() constructor {
	controller_obj = _controller_obj;
	
	
	static is_highlighted = function() {		
		var _view_x = camera_get_view_x(view_camera[0]);
		var _view_y = camera_get_view_y(view_camera[0]);
		
		//Only need two checks because this component is in the top left corner of the screen
		return (device_mouse_x_to_gui(0) - _view_x <= GAME_INFO_DISPLAY_WIDTH && device_mouse_y_to_gui(0) - _view_y <= GAME_INFO_DISPLAY_HEIGHT);
	}
	
	
	static draw = function() {
		//Get necessary information from managers
		//TODO: Same cache stuff as mentioned 
		var _game_state_manager = get_game_state_manager(controller_obj);
		var _round_manager = get_round_manager(controller_obj);
		
		//Draw background
		draw_rectangle_color(0, 0, GAME_INFO_DISPLAY_WIDTH, GAME_INFO_DISPLAY_HEIGHT, c_silver, c_silver, c_silver, c_silver, false);
		
		//Draw basic game stats
		if(_game_state_manager != undefined && _game_state_manager.state== GAME_STATE.VICTORY) {
			draw_text_color(TILE_SIZE*(1/3), TILE_SIZE*(1/3), "Victory!", c_black, c_black, c_black, c_black, 1);
		}
		else if(_game_state_manager != undefined && _game_state_manager.state == GAME_STATE.DEFEAT) {
			draw_text_color(TILE_SIZE*(1/3), TILE_SIZE*(1/3), "Defeat...", c_black, c_black, c_black, c_black, 1);
		}
		else if(_round_manager != undefined) {
			draw_text_color(TILE_SIZE*(1/3), TILE_SIZE*(1/3), "Round: " + string(_round_manager.current_round), c_black, c_black, c_black, c_black, 1);
		}
		else { //Fallback in the event we have no manager data. Should never actually show up in real play.
			draw_text_color(TILE_SIZE*(1/3), TILE_SIZE*(1/3), "Round: ???", c_black, c_black, c_black, c_black, 1);
		}
		draw_text_color(TILE_SIZE*(1/3), TILE_SIZE, "Money: " + string(global.player_money), c_black, c_black, c_black, c_black, 1);
	};
}
#endregion


#region End Results Card Classes

#region EndResultsHeader (Class)
/*
	Draws the "Victory" or "Game Over" on the End Results card
	
	Argument Variables:
	All correspond to Data Variables.
	
	Data Variables:
	x_pos: The x-coordinate of the top-left of the header.
	y_pos: The y-coordinate of the top-left of the header.
	header_sprite: Either the "Victory" sprite or the "Game Over" sprite.
*/
function EndResultsHeader(_x_pos, _y_pos) : UIComponent(_x_pos, _y_pos) constructor {
	header_sprite = spr_game_over;
	
	static set_to_victory = function() {
		header_sprite = spr_victory;
	}
	
	static draw = function() {
		draw_sprite(header_sprite, 0, x_pos, y_pos);
	}
	
}

#endregion


#region RestartLevelButton (Class)
/*
	The button that restarts the level.
	
	Argument Variables:
	All correspond to Data Variables.
	
	Data Variables:
	x_pos: The x-coordinate of the top-left of the header.
	y_pos: The y-coordinate of the top-left of the header.
*/
function RestartLevelButton(_x_pos, _y_pos) :
	Button(_x_pos, _y_pos, spr_restart_button) constructor {
		
	static on_released = function() {
		audio_stop_all();
		room_restart();
	}
}
#endregion


#region BackToLevelSelectButton (Class)
/*
	The button that takes the player back to the Level Select screen.
	
	Argument Variables:
	All correspond to Data Variables.
	
	Data Variables:
	x_pos: The x-coordinate of the top-left of the header.
	y_pos: The y-coordinate of the top-left of the header.
	
	TODO: Technically has the same functionality as the one on the title screen, just looks different.
	Should I even be defining all of these buttons like this, or should I just pass parameters into the base button function?
*/
function BackToLevelSelectionButton(_x_pos, _y_pos) :
	Button(_x_pos, _y_pos, spr_back_to_menu_button) constructor {
		
	static on_released = function() {
		audio_stop_all();
		room_goto(LevelSelectScreen);
	}
}
#endregion


#region EndResultsCard (Class)
/*
	TODO: Comment
	TODO: Can turn this into a popup menu of sorts probably
*/
function EndResultsCard(_menu_width_percentage, _menu_height_percentage) : UIComponent() constructor {
	
	var _view_w = camera_get_view_width(view_camera[0]);
	var _view_h = camera_get_view_height(view_camera[0]);
	
	x1 = (_view_w/2) - (_menu_width_percentage/2 * _view_w); //From middle point, go to the left by the percentage amount
	y1 = (_view_h/2) - (_menu_height_percentage/2 * _view_h); //From middle point, go up by the percentage amount
	x2 = (_view_w/2) + (_menu_width_percentage/2 * _view_w); //From middle point, go to the right by the percentage amount
	y2 = (_view_h/2) + (_menu_height_percentage/2 * _view_h); //From middle point, go down by the percentage amount
	
	
	header = new EndResultsHeader((_view_w - sprite_get_width(spr_game_over)) / 2, 64);
	
	restart_level_button = new RestartLevelButton(x1 + 256, 256);
	back_to_level_select_button = new BackToLevelSelectionButton(x2 - sprite_get_width(spr_back_to_menu_button) - 256, 256);
	
	
	static draw = function() {
		draw_rectangle_color(x1, y1, x2, y2, c_white, c_white, c_white, c_white, false);
		header.draw();
		restart_level_button.draw();
		back_to_level_select_button.draw();
	}
	
	
	static is_highlighted = function() {
		var _mouse_x_gui = device_mouse_x_to_gui(0);
		var _mouse_y_gui = device_mouse_y_to_gui(0);
		return _mouse_x_gui >= x1 && _mouse_x_gui <= x2 && _mouse_y_gui >= y1 && _mouse_y_gui <= y2;
	}
	
	
	static on_released = function() {
		if(restart_level_button.is_highlighted()) {
			restart_level_button.on_released();
		}
		else if(back_to_level_select_button.is_highlighted()) {
			back_to_level_select_button.on_released();
		}
	}
}
#endregion

#endregion


#region GameUI (Class)
/*
	Used for managing the entire UI as a unit. Allows you to enable and disable parts of the UI as needed
	TODO: Finish comment
*/
#macro PAUSE_BUTTON_X (camera_get_view_width(view_camera[0]) - TILE_SIZE*1.5) //Pause button is one "tile" away from right side of the screen by default (if not moved by a side menu)
#macro PAUSE_BUTTON_Y TILE_SIZE*0.5 //Pause button is one "tile" away from the top of the screen

#macro ROUND_START_BUTTON_X TILE_SIZE //Round start button is one "tile" away from the left of the screen
#macro ROUND_START_BUTTON_Y (camera_get_view_height(view_camera[0]) - (TILE_SIZE*1.5)) //Round start button is one and a half "tiles" away from the bottom of the screen
/*
	In charge of drawing UI elements to the screen
	
	Argument Variables:
	_purchase_data: The purchase data needed for the purchase menu
	(All other argument variables correspond with non-underscored data variables)
	
	controller_obj: The controller object this manager is created for.
	
	TODO: Finish this comment
*/
function GameUI(_controller_obj, _purchase_data) : UIComponent() constructor {
	//Manager Info
	//controller_obj = _controller_obj;
	
	//Pure Display Elements (no interactivity)
	game_info_display = new GameInfoDisplay(_controller_obj);
	pause_background = -1; //Used in conjunction with the pause menu in order to continue showing all the instances on screen after they're deactivated
	//NOTE: pause_background IS NOT a UI element, so don't treat it like one.
	
	//Menus
	options_menu = new OptionsMenu((1/2), (1/2));
	//NOTE: In the older code, the height was just window_get_height(). See how this changes things.
	purchase_menu = new UnitPurchaseMenu(_purchase_data);
	unit_info_card = new UnitInfoCard();
	end_results_card = new EndResultsCard((3/4), (3/4));
	
	//Buttons
	pause_button = new PauseButton(PAUSE_BUTTON_X, PAUSE_BUTTON_Y);
	round_start_button = new RoundStartButton(ROUND_START_BUTTON_X, ROUND_START_BUTTON_Y);
	
	children = [game_info_display,
		pause_button, round_start_button,
		purchase_menu, unit_info_card, options_menu, end_results_card];
		
	active = true //We can just do this here instead of calling activate/deactivate, since this UI should always be active
	
	
	static set_gui_running = function() {
		if(pause_background != -1) {
			sprite_delete(pause_background);
			pause_background = -1;
		}
		
		game_info_display.activate();
		purchase_menu.activate();
		unit_info_card.activate();
		pause_button.activate();
		round_start_button.activate();
		
		options_menu.deactivate();
		end_results_card.deactivate();
	}
	
	
	static set_gui_paused = function() {
		if(pause_background != -1) {
			sprite_delete(pause_background);
			pause_background = -1;
		}
		pause_background = sprite_create_from_surface(application_surface, 0, 0, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), false, false, 0, 0);
		
		game_info_display.activate();
		purchase_menu.activate();
		unit_info_card.activate();
		options_menu.activate();
		
		pause_button.deactivate();
		round_start_button.deactivate();
		end_results_card.deactivate();
	}
	
	
	static set_gui_end_results = function(gameWon) {
		if(pause_background != -1) { //This should never be true (since you can't go from PAUSED -> VICTORY), but juuuuust in case...
			sprite_delete(pause_background);
			pause_background = -1;
		}
		
		if(gameWon) { //So we can use this for both victory and loss
			end_results_card.header.set_to_victory();
		}
		end_results_card.activate();
		
		game_info_display.activate();
		purchase_menu.activate();
		unit_info_card.activate();
		
		pause_button.deactivate();
		round_start_button.deactivate();	
	}
	
	
	static draw_parent = draw;
	
	static draw = function() {
		if(pause_background != -1) {
			draw_sprite(pause_background, 0, 0, 0);
		}
		draw_parent();
	}
	
	
	static clean_up = function() {
		if(pause_background != -1) {
			sprite_delete(pause_background);
			pause_background = -1;
		}
	}
}
#endregion