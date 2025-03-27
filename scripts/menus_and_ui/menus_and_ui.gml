/*
	menus_and_ui.gml

	This file contains macros, structs, and functions for creating the various menus and UI elements in the game.
	Certain menus have different options based on different contexts. These let you control these options easily.

	TODO: Maybe make an Activatable object that handles all instances that can be activated and de-activated?
*/

#region Basic UI Components

#region Button (Class)
/*
	Defines a parent class for a button.
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
	button_sprite_default: The default sprite of the button.
	button_sprite_disabled: The sprite of the button while it can't be clicked. Should be the same dimensions as the default sprite.
	button_sprite_highlighted: The highlighted sprite of the button. Should be the same dimensions as the default sprite.
	
	Control Variables:
	active: Whether or not the button should appear on screen and can be clicked on
	
	NOTE 1: "Enabled" refers to whether or not the button can be clicked to perform an action. "Active" refers to whether or not the button is rendered at all.
*/
function Button(_x_pos, _y_pos, _button_sprite_default, _button_sprite_disabled = _button_sprite_default, _button_sprite_highlighted = _button_sprite_default) constructor {
	x_pos = _x_pos;
	y_pos = _y_pos;
	button_sprite_default = _button_sprite_default;
	button_sprite_disabled = _button_sprite_disabled;
	button_sprite_highlighted = _button_sprite_highlighted;
	
	active = false;
	
	
	//Determines whether or not a button should be clickable or not.
	//Basically always overridden, mainly just here for completion's sake;
	//NOTE: Shouldn't accept any parameters.
	static is_enabled = function() {
		return true;
	}
	
	//Basically just a wrapper for activating the button
	static activate = function() {
		active = true;
	}
	
	//Basically just a wrapper for deactivating the button
	static deactivate = function() {
		active = false;
	}
	
	
	//_x_offset and _y_offset are for buttons that are a part of menus. They allow you to define the coordinates in relation to the menu instead of to the entire screen.
	static is_highlighted = function(_x_offset = 0, _y_offset = 0) {
		var _absolute_x_pos = x_pos + _x_offset
		var _absolute_y_pos = y_pos + _y_offset
		
		//TODO: Passable view_camera index? And maybe rename these variables? Not sure.
		var _view_x = device_mouse_x_to_gui(0);
		var _view_y = device_mouse_y_to_gui(0);
		return (_view_x >= _absolute_x_pos && _view_x <= _absolute_x_pos + sprite_get_width(button_sprite_default)
			&& _view_y >= _absolute_y_pos && _view_y <= _absolute_y_pos + sprite_get_height(button_sprite_default));
	}
	
	
	//_x_offset and _y_offset are for buttons that are a part of menus. They allow you to define the coordinates in relation to the menu instead of to the entire screen.
	// _button_highlight_enabled lets you turn of the button highlighting while the game is paused
	static draw = function(_x_offset = 0, _y_offset = 0, _button_highlight_enabled = true) {
		var _draw_x_pos = x_pos + _x_offset;
		var _draw_y_pos = y_pos + _y_offset;
		
		var _spr;
		if(!is_enabled()) {
			_spr = button_sprite_disabled;
		}
		else if(_button_highlight_enabled && is_highlighted(_x_offset, _y_offset)) {
			_spr = button_sprite_highlighted;
		}
		else {
			_spr = button_sprite_default;
		}
		draw_sprite(_spr, 0, _draw_x_pos, _draw_y_pos);
	}
	
	static on_click = function(){};
}
#endregion


#region PillBar (Class)
/*
	Argument Variables:
	_starting_segment: Which segment should the pill bar initially be highlighted up to when it is created. Should correspond with a "default option"
	(All other argument variables correspond with non-underscored data variables)
	
	Used for creating "pill bars", segmented sliders that can be used to select a range of values
	x_pos: X-coordinate of the top left of the bar.
	y_pos: Y-coordinate of the top left of the bar.
	num_segments: The number of segments this pill bar should have.
	current_segment: The modifier that the pill bar is set to. Values can be from 0 to num_segments.
*/
#macro PILL_WIDTH sprite_get_width(spr_pill_button_light)
#macro PILL_HEIGHT sprite_get_height(spr_pill_button_light)
#macro PILL_GAP sprite_get_width(spr_pill_button_light) / 4

function PillBar(_x_pos, _y_pos, _num_segments, _starting_segment = _num_segments) constructor {
	x_pos = _x_pos;
	y_pos = _y_pos;
	num_segments = _num_segments;
	current_segment = _starting_segment;
	
	static draw = function() {
		var pill_x_pos = x_pos;
		for(var i = 0; i < num_segments; ++i) {
			if(i < current_segment) {
				draw_sprite(spr_pill_button_light, 0, pill_x_pos, y_pos);
			}
			else {
				draw_sprite(spr_pill_button_dark, 0, pill_x_pos, y_pos);
			}
			pill_x_pos += (PILL_WIDTH + PILL_GAP);
		}
	}
	
	
	//Returns the segment that the menu should be set to.
	static on_click = function() {
		var _pill_x_pos = x_pos;
		var _click_x = device_mouse_x_to_gui(0);
		var _click_y = device_mouse_y_to_gui(0);
		for (var i = 0; i < num_segments; ++i) {
		    if((_click_x >= _pill_x_pos) && (_click_x <= _pill_x_pos + PILL_WIDTH)
				&& (_click_y >= y_pos) && (_click_y <= y_pos + PILL_HEIGHT)) {
					if(i + 1 == current_segment) { //If you click on the current rightmost segment, "un-select it"
						current_segment = i;	
					}
					else {
						current_segment = i+1;
					}
			}
			_pill_x_pos += (PILL_WIDTH + PILL_GAP);
		}
		return current_segment;
	}
}
#endregion


#region UIManager (Class)
/*
	Parent class for all of the various UI managers in the game.
	
	Argument Variables:
	
	Data Variables:
	ui_elements: A list of all of the UI elements contained within this UIManager
		- The elements should be arranged from back (drawn last) to front (drawn first).
		- If none of your UI elements overlap, the order won't make a difference, but if they do, elements in front will be selected "first"
*/
//TODO: I can honestly use a component like this for all UI components, not just the top level ones, makes iterating through sub-elements easier.
function UIManager() constructor {
	//Getting viewport dimensions	(TODO: Not sure if I need to keep this, or if I can just fetch these from the appropriate functions when I need to.
	view_w =  camera_get_view_width(view_camera[0]);
	view_h = camera_get_view_height(view_camera[0]);
	
	ui_elements = [];
	
	static gui_element_highlighted = function() {
		//Array is searched from end to beginning so that elements drawn in the front are checked before elements drawn in the back
		for(var i = array_length(ui_elements) - 1; i >= 0; i--) {
			if(ui_elements[i].active && ui_elements[i].is_highlighted()) {
				return ui_elements[i];
			}
		}
		return undefined;
	}
	
	static draw = function() {
		for(var i = 0; i < array_length(ui_elements); i++) {
			if(ui_elements[i].active) {
				ui_elements[i].draw();
			}
		}
	}
}
#endregion

#endregion


#region Start Menu UI

#region LevelSelectButton (Class)
/*
	Defines a button that can be clicked to take you to a level select screen
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
*/
function LevelSelectButton(_x_pos, _y_pos) :
	Button(_x_pos, _y_pos, spr_play_game_button) constructor {
		
		static on_click = function() {
			room_goto(LevelSelectScreen);
		}
}
#endregion


#region QuitGameButton (Class)
/*
	Defines a button that can be clicked to exit the game
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
*/
function QuitGameButton(_x_pos, _y_pos) :
	Button(_x_pos, _y_pos, spr_quit_game_button) constructor {
		
		static on_click = function() {
			game_end();
		}
}
#endregion


#region StartMenuUI (Class)
/*
	Used for managing the entire UI as a unit. Allows you to enable and disable parts of the UI as needed
*/
#macro PLAY_BUTTON_X ((camera_get_view_width(view_camera[0]) - sprite_get_width(spr_play_game_button)) / 2)
#macro PLAY_BUTTON_Y TILE_SIZE*2

#macro QUIT_BUTTON_X ((camera_get_view_width(view_camera[0]) - sprite_get_width(spr_play_game_button)) / 2)
#macro QUIT_BUTTON_Y TILE_SIZE*4.5

/*
	In charge of drawing UI elements to the screen
	
	Argument Variables:
	_purchase_data: The purchase data needed for the purchase menu
	(All other argument variables correspond with non-underscored data variables)
	
	Data Variables:
	controller_obj: The controller object this manager is created for.
	
	TODO: Finish this comment
	TODO: Should I make a parent UI object for different UI types (GameUI, StartMenuUI, etc.)
		- Would simplify a decent amount of code.
*/
function StartMenuUI() : UIManager() constructor {		
	//Buttons
	start_button = new LevelSelectButton(PLAY_BUTTON_X, PLAY_BUTTON_Y);
	start_button.activate();
	
	quit_button = new QuitGameButton(QUIT_BUTTON_X, QUIT_BUTTON_Y);
	quit_button.activate();
	
	ui_elements = [start_button, quit_button];
	
	
	static draw_parent = draw;
	
	static draw = function() {
		draw_parent();
		draw_text(TILE_SIZE, view_h - (TILE_SIZE/2), "Music + Sound Effects by Eric Matyas, www.soundimage.org");
	}
}
#endregion

#endregion


#region Level Selection Menu UI

#region LevelCard (Class)
/*
	Draws a level card that can be clicked on to select a level
	
	Argument Variables:
	Correspond to data variables
	
	Data Variables:
	x_pos: X-coordinate of the level card
	y_pos: Y-coordinate of the level card
	level_data: The data of the level that this card corresponds to (global.DATA_LEVEL_MAIN_[LEVELNAME])
*/
function LevelCard(_x_pos, _y_pos, _level_data) :
	Button(_x_pos, _y_pos, spr_level_select_base) constructor {
		
		level_data = _level_data;
		
		static draw_parent = self.draw;
		
		static draw = function(_x_offset = 0, _y_offset = 0) {
			shader_set(shader_levelcards);
			shader_set_uniform_f_array( shader_get_uniform(shader_levelcards, "cardColor"),
				level_data.card_color);
			draw_parent(_x_offset, _y_offset);
			shader_reset();
			draw_sprite(level_data.level_portrait, 1,
				x_pos + _x_offset + 16, y_pos + _y_offset + 16)
			draw_text_color(x_pos + _x_offset + 16, y_pos + _y_offset + 100, level_data.level_name,
				c_black, c_black, c_black, c_black, 1)
		}
		
		static on_click = function() {
			room_goto(level_data.level_room);
		}
}
#endregion


#region LevelSelectUI
/*
	Handles the UI for the Level Selection Menu
*/
function LevelSelectUI() : UIManager() constructor {
	//Buttons (NOTE: Positions don't use enums since these are more than likely temporary)
	button_samplelevel1 = new LevelCard(TILE_SIZE * 0.5, TILE_SIZE, global.DATA_LEVEL_MAIN_SAMPLELEVEL1);
	button_samplelevel1.activate();
	
	button_samplelevel2 = new LevelCard(TILE_SIZE * 5.5, TILE_SIZE, global.DATA_LEVEL_MAIN_SAMPLELEVEL2);
	button_samplelevel2.activate();
	
	button_samplelevel3 = new LevelCard(TILE_SIZE * 10.5, TILE_SIZE, global.DATA_LEVEL_MAIN_SAMPLELEVEL3);
	button_samplelevel3.activate();
	
	ui_elements = [button_samplelevel1, button_samplelevel2, button_samplelevel3];
}
#endregion

#endregion


#region In-Game UI

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
	
	static on_click = function() {
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
	
	
	static on_click = function() {
		if(is_enabled()) {
			var _music_manager = get_music_manager(); //TODO: Cache this too? Main issue with caching is outdated references, but that really shouldn't be an issue here
			if(_music_manager != undefined && _music_manager.current_music == Music_PreRound) {
				_music_manager.fade_out_current_music(seconds_to_milliseconds(QUICK_MUSIC_FADING_TIME), Music_Round);
			}
			//Round manager MUST exist if is_enabled returns true, so we don't have to check again in here.
			cached_round_manager.start_round();
		}
	}
}
#endregion


#region Pause Menu Classes

#region ExitPauseMenuButton (Class)
/*
	TODO: Write this and other comments
*/
function ExitPauseMenuButton(_x_pos, _y_pos) : 
	Button(_x_pos, _y_pos, spr_close_button, spr_close_button, spr_close_button) constructor {
	
	static on_click = function() {
		var _game_state_manager = get_game_state_manager();
		if(_game_state_manager != undefined) {
			_game_state_manager.resume_game();
		}
	}
}
#endregion


#region PauseMenu (Class)
/*
	Defines all of the data for the Pause Menu
	
	Argument Variables:
	_menu_width_percentage: The percentage of the screen's width that the pause menu should take up.
	_menu_height_percentage: The percentage of the screen's height that the pause menu should take up.
	(All other argument variables correspond with non-underscored data variables)
	
	Data Variables:
	pause_background: Sprite used to show all the enemies while the game is paused.
	x1: Left boundary
	y1: Upper boundary
	x2: Right boundary
	y2: Lower boundary
	music_manager: The manager of the game's music
	volume_options: The pill bar that controls the volume of the game's music
*/

//Enums for paused menu open state
enum PAUSE_MENU_STATE {
	PAUSE_OPEN,
	PAUSE_CLOSED
}

#macro NUM_VOLUME_PILLS 10
function PauseMenu(_menu_width_percentage, _menu_height_percentage) constructor {
	pause_background = -1;
	
	var _view_w = camera_get_view_width(view_camera[0]);
	var _view_h = camera_get_view_height(view_camera[0]);
	
	x1 = (_view_w/2) - (_menu_width_percentage/2 * _view_w); //From middle point, go to the left by the percentage amount
	y1 = (_view_h/2) - (_menu_height_percentage/2 * _view_h); //From middle point, go up by the percentage amount
	x2 = (_view_w/2) + (_menu_width_percentage/2 * _view_w); //From middle point, go to the right by the percentage amount
	y2 = (_view_h/2) + (_menu_height_percentage/2 * _view_h); //From middle point, go down by the percentage amount
	
	close_button = new ExitPauseMenuButton(x2 - 40, y1 + 8);
	close_button.activate();
	
	//TODO: Might want to move pill bar stuff into it's own class
	/*
		Gross math equation that basically says
		- From the center of the pause menu [(_x1 + _x2) / 2]
		- Move the pill bar [-]
		- Half of it's length to the left [(NUM_VOLUME_PILLS * (PILL_WIDTH + PILL_GAP - 1)) / 2]
	*/
	var _volume_options_x = ((x1 + x2) / 2) - ((NUM_VOLUME_PILLS * (PILL_WIDTH + PILL_GAP - 1)) / 2);
	volume_options = new PillBar(_volume_options_x, y1 + 96, NUM_VOLUME_PILLS, NUM_VOLUME_PILLS);
	
	//Used for determining whether or not to render
	active = false;
	
	
	//Basically just a wrapper for activating the button
	static activate = function() {
		active = true;
	}
	
	
	//Basically just a wrapper for deactivating the button
	static deactivate = function() {
		active = false;
	}
	
	
	static is_highlighted = function() {
		var _mouse_x_gui = device_mouse_x_to_gui(0);
		var _mouse_y_gui = device_mouse_y_to_gui(0);
		return _mouse_x_gui >= x1 && _mouse_x_gui <= x2 && _mouse_y_gui >= y1 && _mouse_y_gui <= y2;
	}
	
	
	static on_click = function() {
		if(close_button.is_highlighted()) {
			close_button.on_click();
		}
		else {
			//TODO: Can probably merge first two lines in pill bar
			//TODO: Sometimes, the pill bar glitches out, not sure why. To be honest, I'm probably just gonna replace it with a slider
			var _selected_pill = volume_options.on_click();
			volume_options.current_segment = _selected_pill;
			var _music_manager = get_music_manager();
			if(_music_manager != undefined) {
				_music_manager.set_volume(volume_options.current_segment / volume_options.num_segments);
			}
		}
	}
	
	
	static draw = function() {
		draw_rectangle_color(x1, y1, x2, y2, c_black, c_black, c_black, c_black, false);
		draw_set_halign(fa_center);
		draw_text_color((x1 + x2) / 2, y1 + 32, "PAUSED", c_white, c_white, c_white, c_white, 1);
		close_button.draw();
		draw_text_color((x1 + x2) / 2, y1 + 64, "Music Volume", c_white, c_white, c_white, c_white, 1);
		volume_options.draw();
		draw_set_halign(fa_left);
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
	x_pos = _x_pos;
	y_pos = _y_pos;
	purchase_data = _purchase_data;
	
	
	static is_enabled = function() {
		return global.player_money >= purchase_data.price;
	}
	

	static draw_parent = draw;
	
	//_x_offset and _y_offset are the origins of the menu
	// _button_highlight_enabled lets you turn of the button highlighting while the game is paused
	static draw = function(_x_offset, _y_offset, _button_highlight_enabled = true) {
		var _draw_x_pos = x_pos + _x_offset;
		var _draw_y_pos = y_pos + _y_offset;
		
		draw_parent(_x_offset, _y_offset);
		draw_sprite(object_get_sprite(purchase_data.unit), 0, _draw_x_pos + 8, _draw_y_pos + 4);
		draw_set_halign(fa_right);
		draw_text(_draw_x_pos + sprite_get_width(button_sprite_default) - 8, _draw_y_pos + 72, string(purchase_data.price));
		draw_set_halign(fa_left);
	}
}
#endregion


#region PreviousPagePurchaseMenuButton (Class)
/*
	TODO: Comment
*/
function PreviousPagePurchaseMenuButton(_x_pos, _y_pos, _purchase_menu) :
	Button(_x_pos, _y_pos, spr_page_left_default, spr_page_left_disabled) constructor {
	x_pos = _x_pos;
	y_pos = _y_pos;
	purchase_menu = _purchase_menu;
	
	static is_enabled = function() {
		return purchase_menu.current_page > 0;
	}
	
	static on_click = function() {
		if(is_enabled()) {
			purchase_menu.current_page--;
		}
	}
	
}
#endregion


#region NextPagePurchaseMenuButton (Class)
/*
	TODO: Comment
*/
function NextPagePurchaseMenuButton(_x_pos, _y_pos, _purchase_menu) :
	Button(_x_pos, _y_pos, spr_page_right_default, spr_page_right_disabled) constructor {
	x_pos = _x_pos;
	y_pos = _y_pos;
	purchase_menu = _purchase_menu;
	
	static is_enabled = function() {
		return array_length(purchase_menu.purchase_buttons) > (purchase_menu.current_page + 1) * PURCHASE_MENU_BPPAGE;
	}
	
	static on_click = function() {
		if(is_enabled()) {
			purchase_menu.current_page++;
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
function TogglePurchaseMenuButton(_x_pos, _y_pos, _purchase_menu) :
	Button(_x_pos, _y_pos, spr_pointer_arrow_left) constructor {
	purchase_menu = _purchase_menu;
	
	static on_click = function() {
		switch (purchase_menu.state) {
		    case SLIDING_MENU_STATE.OPEN:
		        purchase_menu.toggle_closed();
		        break;
			case SLIDING_MENU_STATE.CLOSED:
				purchase_menu.toggle_open();
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
//NOTE: I don't think this is used right now
#macro PURCHASE_MENU_SCREEN_PERCENTAGE (2/7)

function UnitPurchaseMenu(_menu_width_percentage, _y_pos, _purchase_data_list) constructor {
	state = SLIDING_MENU_STATE.CLOSED; //Whether the menu on the side is opened or closed
	menu_width_percentage = _menu_width_percentage;
	
	var _view_w = camera_get_view_width(view_camera[0]);
	x_pos_open = (1-menu_width_percentage) * _view_w;
	x_pos_current = _view_w; //Window should start out closed
	y_pos = _y_pos;

	//Array that contains all of the button data.
	purchase_buttons = [];
	
	menu_width = _view_w - x_pos_open;
	var _button_width = sprite_get_width(spr_unit_purchase_button_default);
	var _button_height = sprite_get_height(spr_unit_purchase_button_default);

	var _x_gap = (menu_width - PURCHASE_MENU_BPROW*_button_width) / (PURCHASE_MENU_BPROW + 1); //Gap in between buttons (also used as x_margins)
	var _button_x = _x_gap;
	var _button_y = TILE_SIZE;
	var _init_button_y = TILE_SIZE;
	//Create buttons
	for(var i = 0; i < array_length(_purchase_data_list); ++i) {
		array_push(purchase_buttons, new UnitPurchaseButton(_button_x, _button_y, _purchase_data_list[i]));
		_button_x += (_button_width + _x_gap);
		
		if(i % PURCHASE_MENU_BPROW == PURCHASE_MENU_BPROW - 1) { //Time to start a new row
			_button_x = _x_gap;
			_button_y += _button_height + 4;
			if(i % PURCHASE_MENU_BPPAGE == PURCHASE_MENU_BPPAGE - 1) { //Time to start a new page
				_button_y = _init_button_y;
			}
		}
	}
	
	current_page = 0;
	prev_page_button = new PreviousPagePurchaseMenuButton(64 ,y_pos - 40, self);
	next_page_button = new NextPagePurchaseMenuButton(menu_width - sprite_get_width(spr_page_right_default) - 64 , y_pos - 40, self);
	
	toggle_button = new TogglePurchaseMenuButton(-32, (y_pos - sprite_get_width(spr_pointer_arrow_left))/2, self);
	
	
	active = false;
	
	
	//Basically just a wrapper for activating the button
	static activate = function() {
		active = true;
	}
	
	
	//Basically just a wrapper for deactivating the button
	static deactivate = function() {
		active = false;
	}
	
	
	static is_highlighted = function() {
		//mouse_x is based on room position, not camera position, so need to correct selection
		//TODO: Passable view_camera index?
		var _view_x = camera_get_view_x(view_camera[0]);
		var _view_y = camera_get_view_y(view_camera[0]);

		return (mouse_x - _view_x >= x_pos_current && y_pos >= mouse_y - _view_y) || 
			toggle_button.is_highlighted(x_pos_current, 0); 
	}
	
	
	static draw = function() {
		var _game_state_manager = get_game_state_manager();
		var _view_w = camera_get_view_width(view_camera[0]);
		
		draw_rectangle_color(x_pos_current, 0, _view_w, y_pos, c_silver, c_silver, c_silver, c_silver, false);
		toggle_button.draw(x_pos_current, 0);
		prev_page_button.draw(x_pos_current, 0);
		next_page_button.draw(x_pos_current, 0);
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		draw_text_color(x_pos_current + menu_width/2 , TILE_SIZE/2, "PURCHASE",
			c_black, c_black, c_black, c_black, 1);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		
		//current_page * PURCHASE_MENU_BPPAGE is the index of the first button on the current page
		//(current_page+1) * PURCHASE_MENU_BPPAGE is the index of the first button on the NEXT page
		//The i < array_length(purchase_buttons) exists so, on the last page, if there are less than PURCHASE_MENU_BPPAGE buttons, the loop will stop at the last one, instead of trying to access non-existent buttons
		for(var i = current_page * PURCHASE_MENU_BPPAGE; i < (current_page+1) * PURCHASE_MENU_BPPAGE && i < array_length(purchase_buttons); ++i) {
			purchase_buttons[i].draw(x_pos_current, 0, _game_state_manager != undefined && _game_state_manager.state == GAME_STATE.RUNNING);
		}
		//shader_reset();
	}
	
	
	static toggle_open = function() {
		audio_play_sound(SFX_Menu_Open, 1, false); //TODO: Add volume control
		state = SLIDING_MENU_STATE.OPENING;
	}
	
	
	static toggle_closed = function() {
		audio_play_sound(SFX_Menu_Close, 1, false) //TODO: Add volume control
		state = SLIDING_MENU_STATE.CLOSING;
	}
	
	
	//This function moves the menu based on its current state. Also accepts a menu toggle boolean
	//Shoud be called in a Step event.
	//Returns the number of pixels the menu has moved, so that any other UI elements can be moved along with it.
	static move_menu = function(_menu_toggle_pressed) {
		var _x_pos_old = x_pos_current;
		switch (state) {
			case SLIDING_MENU_STATE.CLOSED:
				if(_menu_toggle_pressed) {
					toggle_open();
				}
			    break;
			case SLIDING_MENU_STATE.CLOSING:
				x_pos_current = min(x_pos_current + SLIDING_MENU_MOVEMENT_SPEED, camera_get_view_width(view_camera[0]));
				if(x_pos_current >= camera_get_view_width(view_camera[0])) {
					state = SLIDING_MENU_STATE.CLOSED;
				}
				break;
			case SLIDING_MENU_STATE.OPENING:
				x_pos_current = max(x_pos_current - SLIDING_MENU_MOVEMENT_SPEED, x_pos_open);
				if(x_pos_current <= x_pos_open) {
					state = SLIDING_MENU_STATE.OPEN;
				}
				break;
			case SLIDING_MENU_STATE.OPEN:
				if(_menu_toggle_pressed) {
					toggle_closed();
				}
				break;
			default:
			    break;
		}
		
		//Will be 0 if menu hasn't moved, positive if the menu is closing, and negative if the menu is opening
		return x_pos_current - _x_pos_old;
	}
	
	
	static on_click = function() {
		if(toggle_button.is_highlighted(x_pos_current, 0)) { //Not checking for if enabled, since it will always be enabled if this menu is enabled
			toggle_button.on_click();
			return;
		}
		if(prev_page_button.is_highlighted(x_pos_current, 0)) { //is_enabled check is in the on_click function
			prev_page_button.on_click();
			return;
		}
		if(next_page_button.is_highlighted(x_pos_current, 0)) { //is_enabled check is in the on_click function
			next_page_button.on_click();
			return;
		}
		
		var _purchase_manager = get_purchase_manager();
		if(_purchase_manager != undefined) {
			for(var i = current_page * PURCHASE_MENU_BPPAGE; i < (current_page+1) * PURCHASE_MENU_BPPAGE && i < array_length(purchase_buttons); ++i) {
				if(purchase_buttons[i].is_highlighted(x_pos_current, 0)) {
					_purchase_manager.set_selected_purchase(purchase_buttons[i].purchase_data);
				}
			}
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
	
	static draw = function(_x_offset, _y_offset) {
		//TODO: Figure out how to get the inheritance actually working properly
		var _draw_x_pos = x_pos + _x_offset;
		var _draw_y_pos = y_pos + _y_offset;
		
		if(stat_upgrade_data == undefined) {
			draw_sprite(spr_blank_stat_icon, 0, _draw_x_pos, _draw_y_pos);
			return; //No number for a stat that doesn't exist
		}
		
		draw_parent(_x_offset, _y_offset);
		
		
		draw_set_halign(fa_right);
		draw_set_valign(fa_right);
		if(stat_upgrade_data.current_level >= stat_upgrade_data.max_level) {
			draw_text_color(_draw_x_pos + sprite_get_width(button_sprite_default)*0.9,
				_draw_y_pos + sprite_get_height(stat_upgrade_data.upgrade_spr) - 4, "MAX", 
				c_white, c_white, c_white, c_white, 1);
		}
		else {
			draw_text_color(_draw_x_pos + sprite_get_width(button_sprite_default)*0.9, 
				_draw_y_pos + sprite_get_height(stat_upgrade_data.upgrade_spr) - 4, stat_upgrade_data.current_price, 
				c_white, c_white, c_white, c_white, 1);
		}
		
		draw_set_halign(fa_left);
		draw_set_valign(fa_left);
	}
	
	static is_enabled = function() {
		return (stat_upgrade_data != undefined 
			&& global.player_money >= stat_upgrade_data.current_price 
			&& stat_upgrade_data.current_level < stat_upgrade_data.max_level);
	}
	
	static on_click = function() {
		if(stat_upgrade_data != undefined) {
			global.player_money -= stat_upgrade_data.current_price;
			stat_upgrade_data.on_upgrade();
		}
	}
	
}
#endregion


#region StatUpgradeDisplay (Class)
/*
	Used to display all of the stat upgrade buttons 
	
	Argument Variables:
	
	Data Variables:
	x_pos: Horizontal position of the left of the upgrade info (relative to the UnitInfoCard)
	y_pos: Vertical position of the top of the upgrade info (relative to the UnitInfoCard)
	//unit: The unit whose stats are being displayed
*/
function draw_stat_level(_x_pos, _y_pos, _stat_level) {
	draw_set_halign(fa_right);
	draw_set_valign(fa_right);
	//Draws the number to the right
	draw_text_color(_x_pos + STAT_BUTTON_SIZE*0.9,
		_y_pos + STAT_BUTTON_SIZE - 4,
		_stat_level,
		c_white, c_white, c_white, c_white, 1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_left);
}

function StatUpgradeDisplay(_x_pos, _y_pos/*, _unit*/) constructor {
	x_pos = _x_pos;
	y_pos = _y_pos;
	selected_unit = noone;
	
	buttons = [new StatUpgradeButton(x_pos, y_pos + STAT_BUTTON_SIZE), new StatUpgradeButton(x_pos + STAT_BUTTON_SIZE, y_pos + STAT_BUTTON_SIZE),
		new StatUpgradeButton(x_pos + STAT_BUTTON_SIZE*2, y_pos + STAT_BUTTON_SIZE), new StatUpgradeButton(x_pos + STAT_BUTTON_SIZE*3, y_pos + STAT_BUTTON_SIZE)];
	
	
	static draw = function(_x_offset, _y_offset) {
		var _draw_x_pos = x_pos + _x_offset;
		var _draw_y_pos = y_pos + _y_offset;
		for(var i = 0; i < array_length(buttons); i++) {
			if(selected_unit.stat_upgrades[i] != undefined) {
				draw_sprite(selected_unit.stat_upgrades[i].upgrade_spr, 0, 
					_draw_x_pos + (STAT_BUTTON_SIZE * i), _draw_y_pos);
				draw_stat_level(_draw_x_pos + (STAT_BUTTON_SIZE * i), _draw_y_pos, selected_unit.stat_upgrades[i].current_level)
			}
			else {
				draw_sprite(spr_blank_stat_icon, 0, _draw_x_pos + (STAT_BUTTON_SIZE * i), _draw_y_pos);
			}
			buttons[i].draw(_x_offset, _y_offset);
		}
	}
	
	
	static on_unit_changed = function(_new_unit) {
		selected_unit = _new_unit;
		var _new_upgrades = _new_unit == noone ? [undefined, undefined, undefined, undefined] : _new_unit.stat_upgrades;
		for(var i = 0; i < array_length(buttons); i++) {
			buttons[i].stat_upgrade_data = _new_upgrades[i];
		}
	}
	
	
	static get_button_clicked = function(_x_offset, _y_offset) {
		for(var i = 0; i < array_length(buttons); i++) {
			if(buttons[i].is_enabled() && buttons[i].is_highlighted(_x_offset, _y_offset)) {
				return buttons[i];
			}
		}
		return undefined;
	}
	
}
#endregion


#region UnitUpgradeButton (Class)
/*
	Button clicked to upgrade a unit into a different one.
*/
function UnitUpgradeButton(_x_pos, _y_pos, _unit_upgrade_data = undefined, _selected_unit = noone) : 
		Button(_x_pos, _y_pos, spr_unit_purchase_button_default, spr_unit_purchase_button_disabled, spr_unit_purchase_button_highlighted) constructor {
	x_pos = _x_pos;
	y_pos = _y_pos;
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
	

	//static draw_parent = method(self, draw); //TODO: For some reason, the bind method was causing all of the button backgrounds to appear in the first section. Need to figure out why.
	
	//_x_offset and _y_offset are the origins of the menu
	// _button_highlight_enabled lets you turn of the button highlighting while the game is paused
	static draw = function(_x_offset, _y_offset, _button_highlight_enabled = true) {
		var _draw_x_pos = x_pos + _x_offset;
		var _draw_y_pos = y_pos + _y_offset;
		
		if(unit_upgrade_data == undefined) {
			draw_sprite(button_sprite_disabled, 0, _draw_x_pos, _draw_y_pos);
			return; //Nothing else to draw
		}
		
		var _spr;
		if(!is_enabled()) {
			_spr = button_sprite_disabled;
		}
		else if(_button_highlight_enabled && is_highlighted(_x_offset, _y_offset)) {
			_spr = button_sprite_highlighted;
		}
		else {
			_spr = button_sprite_default;
		}
		draw_sprite(_spr, 0, _draw_x_pos, _draw_y_pos);
		draw_sprite(object_get_sprite(unit_upgrade_data.upgrade_to), 0, _draw_x_pos + 8, _draw_y_pos + 4);
		draw_set_halign(fa_right);
		draw_text(_draw_x_pos + sprite_get_width(button_sprite_default) - 8, _draw_y_pos + 72, string(unit_upgrade_data.price));
		draw_set_halign(fa_left);
	}
	
	static on_click = function() { //TODO: Need to finish??? Not actually sure.
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
function TargetingIndicator(_x_pos, _y_pos) constructor {
	x_pos = _x_pos;
	y_pos = _y_pos;
	selected_unit = noone;
	
	static draw = function(_x_offset, _y_offset) {
		if(selected_unit == noone || array_length(selected_unit.targeting_tracker.potential_targeting_types) == 0) {
			return;
		}
		var _draw_x_pos = x_pos + _x_offset;
		var _draw_y_pos = y_pos + _y_offset;
		var _targeting_type = selected_unit.targeting_tracker.get_current_targeting_type();
		
		draw_rectangle_color(_draw_x_pos, _draw_y_pos, _draw_x_pos + 96, _draw_y_pos + 24,
			c_ltgray, c_ltgray, c_ltgray, c_ltgray, false)
		draw_set_halign(fa_center);
		draw_text(_draw_x_pos + 48, _draw_y_pos, _targeting_type.targeting_name);
		draw_set_halign(fa_left);
	}
}
#endregion


#region SellButton (Class)
/*
	Button clicked to sell a unit for cash back
	Currently takes in a reference to the parent unit info card, as that needs to get updated when a unit is sold.
	TODO: Find a better way to do this (some sort of event listener pattern or whatever)
*/
function SellButton(_unit_info_card, _x_pos, _y_pos, _selected_unit = noone) :
		Button(_x_pos, _y_pos, spr_sell_button_default, spr_sell_button_disabled, spr_sell_button_default) constructor {
	unit_info_card = _unit_info_card;
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
		
		var _draw_x_pos = x_pos + _x_offset;
		var _draw_y_pos = y_pos + _y_offset;
		
		draw_sprite(button_sprite_default, 0, _draw_x_pos, _draw_y_pos);
		draw_set_halign(fa_right);
		draw_set_valign(fa_center);
		draw_text(_draw_x_pos + sprite_get_width(button_sprite_default) - 8, _draw_y_pos + sprite_get_height(button_sprite_default)/2, string(selected_unit.sell_price));
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}
	
	static on_click = function() {
		if(selected_unit != noone) {
			var _tile = instance_position(selected_unit.x, selected_unit.y, placeable_tile);
			_tile.placed_unit = noone;
			global.player_money += selected_unit.sell_price;
			instance_destroy(selected_unit);
			unit_info_card.on_selected_unit_change(noone); //Don't want this menu referencing a unit that doesn't exist anymore
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
	//TODO: Add stat icons and the like
*/
//#macro TOGGLE_INFO_CARD_BUTTON_X ((camera_get_view_width(view_camera[0]) - sprite_get_width(spr_pointer_arrow_up)) / 2)
//#macro TOGGLE_INFO_CARD_BUTTON_Y (camera_get_view_height(view_camera[0]) - (TILE_SIZE*0.5))

function UnitInfoCard(_menu_height_percentage, _x_pos) constructor {
	state = SLIDING_MENU_STATE.CLOSED; //Whether the menu on the bottom is opened or closed
	selected_unit = noone;
	
	var _view_w = camera_get_view_width(view_camera[0]);
	var _view_h = camera_get_view_height(view_camera[0]);
	y_pos_open = (1-_menu_height_percentage) * _view_h;
	y_pos_current = _view_h; //Window should start out closed
	x_pos = _x_pos;
	
	active = false;
	
	//Stat Upgrade Info
	stat_upgrade_buttons = new StatUpgradeDisplay(TILE_SIZE * 4.5, TILE_SIZE/2);
	
	//Unit Upgrade Info
	unit_upgrade_button_1 = new UnitUpgradeButton(TILE_SIZE*8, TILE_SIZE/2, undefined, noone);
	unit_upgrade_button_2 = new UnitUpgradeButton(TILE_SIZE*9.5, TILE_SIZE/2, undefined, noone);
	unit_upgrade_button_3 = new UnitUpgradeButton(TILE_SIZE*11, TILE_SIZE/2, undefined, noone);
	
	//Targeting Indicator
	targeting_indicator = new TargetingIndicator(TILE_SIZE*2.5, TILE_SIZE*1.5);
	
	//Sell Button
	sell_button = new SellButton(self, TILE_SIZE*13, TILE_SIZE/4, noone);
	
	//Menu Toggle Button
	toggle_button = new ToggleInfoCardButton((_view_w - sprite_get_width(spr_pointer_arrow_up))/2, 
		-32, self);
	
	
	//Basically just a wrapper for activating the button
	static activate = function() {
		active = true;
	}
	
	
	//Basically just a wrapper for deactivating the button
	static deactivate = function() {
		active = false;
	}
	
	
	//Called when the selected unit is changed
	static on_selected_unit_change = function(_new_selected_unit) {
		selected_unit = _new_selected_unit;
		stat_upgrade_buttons.on_unit_changed(selected_unit);
		sell_button.selected_unit = selected_unit
		targeting_indicator.selected_unit = selected_unit;
		
		if(_new_selected_unit != noone) {
			unit_upgrade_button_1.on_selected_unit_change(selected_unit.unit_upgrade_1, selected_unit);
			unit_upgrade_button_2.on_selected_unit_change(selected_unit.unit_upgrade_2, selected_unit);
			unit_upgrade_button_3.on_selected_unit_change(selected_unit.unit_upgrade_3, selected_unit);
		}
		else {
			unit_upgrade_button_1.on_selected_unit_change(undefined, noone);
			unit_upgrade_button_2.on_selected_unit_change(undefined, noone);
			unit_upgrade_button_3.on_selected_unit_change(undefined, noone);
		}
	}

	
	static is_highlighted = function() {
		//mouse_y is based on room position, not camera position, so need to correct selection
		//TODO: Passable view_camera index?
		var _view_y = camera_get_view_y(view_camera[0]);
		//Need to include check for toggle button, since it peaks past the normal boundaries of the menu
		return mouse_y - _view_y >= y_pos_current || toggle_button.is_highlighted(0, y_pos_current); 
	}
	
	
	// _button_highlight_enabled lets you turn of the button highlighting while the game is paused
	static draw = function() {
		var _game_state_manager = get_game_state_manager();
		var _button_highlight_enabled = (_game_state_manager != undefined && _game_state_manager.state == GAME_STATE.RUNNING);
		
		var _view_h = camera_get_view_height(view_camera[0]);
		
		draw_rectangle_color(0, y_pos_current, x_pos, _view_h, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
		toggle_button.draw(0, y_pos_current);
		if(selected_unit != noone) {
			draw_sprite(selected_unit.sprite_index, 0, TILE_SIZE/2, y_pos_current + TILE_SIZE/4);
			draw_set_halign(fa_middle);
			draw_text_color(TILE_SIZE, y_pos_current + TILE_SIZE*1.25, 
				selected_unit.unit_name, c_white, c_white, c_white, c_white, 1);
			draw_text_color(TILE_SIZE, y_pos_current + TILE_SIZE*1.6, 
				string(selected_unit.current_health) + "/" + string(selected_unit.max_health), c_white, c_white, c_white, c_white, 1);
			draw_set_halign(fa_left);
			stat_upgrade_buttons.draw(0, y_pos_current);
			unit_upgrade_button_1.draw(0, y_pos_current, _button_highlight_enabled);
			unit_upgrade_button_2.draw(0, y_pos_current, _button_highlight_enabled);
			unit_upgrade_button_3.draw(0, y_pos_current, _button_highlight_enabled);
			targeting_indicator.draw(0, y_pos_current);
			sell_button.draw(0, y_pos_current);
			
			//Draw any necessary highlights. This is done after all of the other drawing so that they'll always be on top.
			for(var i = 0; i < array_length(stat_upgrade_buttons.buttons); i++) {
				var _mouse_x_gui = device_mouse_x_to_gui(0);
				var _mouse_y_gui = device_mouse_y_to_gui(0);
				var _region_highlighted = _mouse_x_gui >= stat_upgrade_buttons.buttons[i].x_pos && _mouse_x_gui <= stat_upgrade_buttons.buttons[i].x_pos + STAT_BUTTON_SIZE &&
					_mouse_y_gui >= stat_upgrade_buttons.buttons[i].y_pos + y_pos_current - STAT_BUTTON_SIZE && _mouse_y_gui <= stat_upgrade_buttons.buttons[i].y_pos + y_pos_current + STAT_BUTTON_SIZE
					
				if(stat_upgrade_buttons.buttons[i].stat_upgrade_data != undefined && _region_highlighted) { //Need more than just standard highlight since this should include the icon along with the button
					draw_highlight_info(stat_upgrade_buttons.buttons[i].stat_upgrade_data.title, 
					stat_upgrade_buttons.buttons[i].stat_upgrade_data.description);
					break; //Only need to draw one highlight
				}
			}
		}
	}
	
	
	static toggle_open = function() {
		audio_play_sound(SFX_Menu_Open, 1, false); //TODO: Add volume control
		state = SLIDING_MENU_STATE.OPENING;
	}
	
	
	static toggle_closed = function() {
		audio_play_sound(SFX_Menu_Close, 1, false) //TODO: Add volume control
		state = SLIDING_MENU_STATE.CLOSING;
	}
	
	
	//This function moves the menu based on its current state. Also accepts a menu toggle boolean
	//Shoud be called in a Step event.
	//Returns the number of pixels the menu has moved, so that any other UI elements can be moved along with it.
	static move_menu = function(_menu_toggle_pressed) {
		var _y_pos_old = y_pos_current;
		switch (state) {
			case SLIDING_MENU_STATE.CLOSED:
				if(_menu_toggle_pressed) {
					toggle_open();
				}
			    break;
			case SLIDING_MENU_STATE.CLOSING:
				y_pos_current = min(y_pos_current + SLIDING_MENU_MOVEMENT_SPEED, camera_get_view_height(view_camera[0]))
				if(y_pos_current >= camera_get_view_height(view_camera[0])) {
					state = SLIDING_MENU_STATE.CLOSED;
				}
				break;
			case SLIDING_MENU_STATE.OPENING:
				y_pos_current = max(y_pos_current - SLIDING_MENU_MOVEMENT_SPEED, y_pos_open)
				if(y_pos_current <= y_pos_open) {
					state = SLIDING_MENU_STATE.OPEN;
				}
				break;
			case SLIDING_MENU_STATE.OPEN:
				if(_menu_toggle_pressed) {
					toggle_closed();
				}
				break;
			default:
			    break;
		}
		
		//Will be 0 if menu hasn't moved, positive if the menu is closing, and negative if the menu is opening
		return y_pos_current - _y_pos_old;
	}
	
	
	//TODO: This works differently from the unit purchase menu
	// In that menu, the selection returns a unit type, this one actually performs the purchase
	// Determine which method is better and do it.
	//TODO: Make this code nicer. To many else ifs
	static on_click = function() {
		var _selected_button = stat_upgrade_buttons.get_button_clicked(0, y_pos_current); //Checks all the stat upgrade buttons
		
		if(_selected_button == undefined) {	//No dedicated struct for all the other buttons, so these are all just checked here for now.
			if(unit_upgrade_button_1.is_enabled() &&
				unit_upgrade_button_1.is_highlighted(0, y_pos_current)) {
				_selected_button = unit_upgrade_button_1;
			}
			else if(unit_upgrade_button_2.is_enabled() &&
				unit_upgrade_button_2.is_highlighted(0, y_pos_current)) {
				_selected_button = unit_upgrade_button_2;
			}
			else if(unit_upgrade_button_3.is_enabled() &&
				unit_upgrade_button_3.is_highlighted(0, y_pos_current)) {
				_selected_button = unit_upgrade_button_3;
			}
			else if(sell_button.is_enabled() &&
				sell_button.is_highlighted(0, y_pos_current)) {
				_selected_button = sell_button;
			}
			else if(toggle_button.is_enabled() &&
				toggle_button.is_highlighted(0, y_pos_current)) {
				_selected_button = toggle_button;
			}
		}
		
		if(_selected_button != undefined) {
			_selected_button.on_click();
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
	unit_info_card: Reference to the Unit Info Card this button belongs to.
*/
function ToggleInfoCardButton(_x_pos, _y_pos, _unit_info_card) :
	Button(_x_pos, _y_pos, spr_pointer_arrow_up) constructor {
	unit_info_card = _unit_info_card;
	
	static on_click = function() {
		switch (unit_info_card.state) {
		    case SLIDING_MENU_STATE.OPEN:
		        unit_info_card.toggle_closed();
		        break;
			case SLIDING_MENU_STATE.CLOSED:
				unit_info_card.toggle_open();
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

function GameInfoDisplay(_controller_obj) constructor {
	controller_obj = _controller_obj;
	
	active = false;
	
	
	//Basically just a wrapper for activating the button
	static activate = function() {
		active = true;
	}
	
	
	//Basically just a wrapper for deactivating the button
	static deactivate = function() {
		active = false;
	}
	
	
	static is_highlighted = function() {		
		var _view_x = camera_get_view_x(view_camera[0]);
		var _view_y = camera_get_view_y(view_camera[0]);
		
		//Only need two checks because this component is in the top left corner of the screen
		return (mouse_x - _view_x <= GAME_INFO_DISPLAY_WIDTH && mouse_y - _view_y <= GAME_INFO_DISPLAY_HEIGHT);
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
	TODO: Comment
*/
function EndResultsHeader(_x_pos, _y_pos) constructor {
	x_pos = _x_pos;
	y_pos = _y_pos;
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
	TODO: Comment
*/
function RestartLevelButton(_x_pos, _y_pos) :
	Button(_x_pos, _y_pos, spr_restart_button) constructor {
		
	static on_click = function() {
		audio_stop_all();
		room_restart();
	}
}
#endregion


#region BackToLevelSelectButton (Class)
/*
	TODO: Comment
	
	TODO: Technically has the same functionality as the one on the title screen, just looks different.
	Should I even be defining all of these buttons like this, or should I just pass parameters into the base button function?
*/
function BackToLevelSelectionButton(_x_pos, _y_pos) :
	Button(_x_pos, _y_pos, spr_back_to_menu_button) constructor {
		
	static on_click = function() {
		audio_stop_all();
		room_goto(LevelSelectScreen);
	}
}
#endregion


#region EndResultsCard (Class)
/*
	TODO: Comment
*/
function EndResultsCard(_menu_width_percentage, _menu_height_percentage) constructor {
	
	var _view_w = camera_get_view_width(view_camera[0]);
	var _view_h = camera_get_view_height(view_camera[0]);
	
	x1 = (_view_w/2) - (_menu_width_percentage/2 * _view_w); //From middle point, go to the left by the percentage amount
	y1 = (_view_h/2) - (_menu_height_percentage/2 * _view_h); //From middle point, go up by the percentage amount
	x2 = (_view_w/2) + (_menu_width_percentage/2 * _view_w); //From middle point, go to the right by the percentage amount
	y2 = (_view_h/2) + (_menu_height_percentage/2 * _view_h); //From middle point, go down by the percentage amount
	
	active = false;
	
	header = new EndResultsHeader((_view_w - sprite_get_width(spr_game_over)) / 2, 64);
	
	restart_level_button = new RestartLevelButton(x1 + 256, 256);
	back_to_level_select_button = new BackToLevelSelectionButton(x2 - sprite_get_width(spr_back_to_menu_button) - 256, 256);
	
	static activate = function() {
		active = true;
	}
	
	
	static deactivate = function() {
		active = false;
	}
	
	
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
	
	
	static on_click = function() {
		if(restart_level_button.is_highlighted()) {
			restart_level_button.on_click();
		}
		else if(back_to_level_select_button.is_highlighted()) {
			back_to_level_select_button.on_click();
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

//#macro TOGGLE_PURCHASE_MENU_BUTTON_X (camera_get_view_width(view_camera[0]) - (TILE_SIZE*0.5))
//#macro TOGGLE_PURCHASE_MENU_BUTTON_Y ((camera_get_view_height(view_camera[0]) - sprite_get_height(spr_pointer_arrow_left)) / 2)
/*
	In charge of drawing UI elements to the screen
	
	Argument Variables:
	_purchase_data: The purchase data needed for the purchase menu
	(All other argument variables correspond with non-underscored data variables)
	
	controller_obj: The controller object this manager is created for.
	
	TODO: Finish this comment
*/
function GameUI(_controller_obj, _purchase_data) : UIManager() constructor {
	//Manager Info
	//controller_obj = _controller_obj;
	
	//Pure Display Elements (no interactivity)
	game_info_display = new GameInfoDisplay(_controller_obj);
	pause_background = -1; //Used in conjunction with the pause menu in order to continue showing all the instances on screen after they're deactivated
	//NOTE: pause_background IS NOT a UI element, so don't treat it like one.
	
	//Menus
	pause_menu = new PauseMenu((1/2), (1/2));
	//NOTE: In the older code, the height was just window_get_height(). See how this changes things.
	purchase_menu = new UnitPurchaseMenu(PURCHASE_MENU_SCREEN_PERCENTAGE, 
		view_h*(1-UNIT_INFO_CARD_SCREEN_PERCENTAGE), _purchase_data);
	unit_info_card = new UnitInfoCard(UNIT_INFO_CARD_SCREEN_PERCENTAGE, view_w);
	end_results_card = new EndResultsCard((3/4), (3/4));
	
	//Buttons
	pause_button = new PauseButton(PAUSE_BUTTON_X, PAUSE_BUTTON_Y);
	round_start_button = new RoundStartButton(ROUND_START_BUTTON_X, ROUND_START_BUTTON_Y);
	
	ui_elements = [game_info_display,
		pause_button, round_start_button,
		purchase_menu, unit_info_card, pause_menu, end_results_card];
	
	
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
		
		pause_menu.deactivate();
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
		pause_menu.activate();
		
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

#endregion