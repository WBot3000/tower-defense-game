/*
	menus_and_ui.gml

	This file contains macros, structs, and functions for creating the various menus and UI elements in the game.
	Certain menus have different options based on different contexts. These let you control these options easily.

	TODO: Maybe make an Activatable object that handles all instances that can be activated and de-activated?
*/

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
		
		//mouse_x is based on room position, not camera position, so need to correct selection
		//TODO: Passable view_camera index?
		var _view_x = camera_get_view_x(view_camera[0]);
		var _view_y = camera_get_view_y(view_camera[0]);
		return (mouse_x - _view_x >= _absolute_x_pos && mouse_x - _view_x <= _absolute_x_pos + sprite_get_width(button_sprite_default)
			&& mouse_y - _view_y >= _absolute_y_pos && mouse_y - _view_y <= _absolute_y_pos + sprite_get_height(button_sprite_default));
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
	x_pos = _x_pos;
	y_pos = _y_pos;
	
	
	static on_click = function() {
		//TODO: Where the fuck does this game controller come from?
		//Is it because it's called in a variable with the game controller?
		//No, it's just because this isn't actually called
		//game_controller.game_state = GAME_STATE.PAUSED;
		//game_ui.set_gui_paused();
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
	controller_obj: Game controller object that manages game state.
*/
function RoundStartButton(_x_pos, _y_pos, _controller_obj) :
		Button(_x_pos, _y_pos, spr_round_start_button_enabled, spr_round_start_button_disabled, spr_round_start_button_enabled) constructor {
	x_pos = _x_pos;
	y_pos = _y_pos;
	controller_obj = _controller_obj;

	
	
	static is_enabled = function() {
		var _round_manager = get_round_manager(controller_obj); //TODO: Implement a cache system for this and other instances like this so we don't have to fetch the manager EVERY time this function is called.
		if(_round_manager == undefined ) {
			return false;
		}
		//If we're on the final round, you shouldn't be able to trigger more rounds.
		if(_round_manager.current_round >= _round_manager.max_round) {
			return false;
		}
		return true;
	}
	
	
	//Also not used
	static on_click = function() {
		if(is_enabled()) {
			//Round manager MUST exist if is_enabled returns true, so we don't have to check again in here.
			var _round_manager = get_round_manager(controller_obj);
			_round_manager.start_round();
		}
	}
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
		var pill_x_pos = x_pos;
		var camera_x = camera_get_view_x(view_camera[0]);
		var camera_y = camera_get_view_y(view_camera[0]);
		for (var i = 0; i < num_segments; ++i) {
		    if((mouse_x - camera_x >= pill_x_pos) && (mouse_x - camera_x <= pill_x_pos + PILL_WIDTH)
				&& (mouse_y - camera_y >= y_pos) && (mouse_y - camera_y <= y_pos + PILL_HEIGHT)) {
					if(i + 1 == current_segment) { //If you click on the current rightmost segment, "un-select it"
						current_segment = i;	
					}
					else {
						current_segment = i+1;
					}
			}
			pill_x_pos += (PILL_WIDTH + PILL_GAP);
		}
		return current_segment;
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
function PauseMenu(_menu_width_percentage, _menu_height_percentage/*, _music_manager*/) constructor {
	pause_background = -1;
	
	var _view_w = camera_get_view_width(view_camera[0]);
	var _view_h = camera_get_view_height(view_camera[0]);
	
	x1 = (_view_w/2) - (_menu_width_percentage/2 * _view_w); //From middle point, go to the left by the percentage amount
	y1 = (_view_h/2) - (_menu_height_percentage/2 * _view_h); //From middle point, go up by the percentage amount
	x2 = (_view_w/2) + (_menu_width_percentage/2 * _view_w); //From middle point, go to the right by the percentage amount
	y2 = (_view_h/2) + (_menu_height_percentage/2 * _view_h); //From middle point, go down by the percentage amount
	
	//music_manager = _music_manager;
	
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
		create_pause_background();
		active = true;
	}
	
	
	//Basically just a wrapper for deactivating the button
	static deactivate = function() {
		active = false;
		if(pause_background != -1) {
			free_pause_background();
		}
	}
	
	
	static create_pause_background = function() {
		if(pause_background != -1) {
			free_pause_background();
		}
		pause_background = sprite_create_from_surface(application_surface, 0, 0, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), false, false, 0, 0);
	}
	
	
	static free_pause_background = function() {
		sprite_delete(pause_background);
		pause_background = -1;
	}
	
	
	static draw_paused_bg = function() {
		draw_sprite(pause_background, 0, 0, 0);
	}
	
	static draw_menu = function() {
		draw_rectangle_color(x1, y1, x2, y2, c_black, c_black, c_black, c_black, false);
		draw_set_halign(fa_center);
		draw_text_color((x1 + x2) / 2, y1 + 32, "PAUSED", c_white, c_white, c_white, c_white, 1);
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

#region UnitPurchaseButton (Class)
/*
	Defines a clickable button for the Unit Selection Menu.
	
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
		if(global.player_money < purchase_data.price) {
			return false;
		}
		return true;
	}
	

	//static draw_parent = method(self, draw); //TODO: For some reason, the bind method was causing all of the button backgrounds to appear in the first section. Need to figure out why.
	
	//_x_offset and _y_offset are the origins of the menu
	// _button_highlight_enabled lets you turn of the button highlighting while the game is paused
	static draw = function(_x_offset, _y_offset, _button_highlight_enabled = true) {
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
		draw_sprite(object_get_sprite(purchase_data.unit), 0, _draw_x_pos + 8, _draw_y_pos + 4);
		draw_set_halign(fa_right);
		draw_text(_draw_x_pos + sprite_get_width(button_sprite_default) - 8, _draw_y_pos + 72, string(purchase_data.price));
		draw_set_halign(fa_left);
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
	buttons: All of the unit purchase buttons within the menu itself.
*/
#macro PURCHASE_MENU_BPR 3 //BPR = Buttons Per Row

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
	buttons = [];
	
	var _menu_width = _view_w - x_pos_open;
	var _button_width = sprite_get_width(spr_unit_purchase_button_default);

	var _button_x = 0;
	var _button_y = 0;
	var _x_gap = (_menu_width - PURCHASE_MENU_BPR*_button_width) / (PURCHASE_MENU_BPR + 1); //Gap in between buttons (also used as x_margins)
	//Create buttons
	for(var i = 0; i < array_length(_purchase_data_list); ++i) {
		if(i % PURCHASE_MENU_BPR == 0) { //Start of a new row
			_button_x = _x_gap;
			_button_y += _button_width;
		}
	
		array_push(buttons, new UnitPurchaseButton(_button_x, _button_y, _purchase_data_list[i]));
		_button_x += (_button_width + _x_gap);
	}
	
	
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

		return mouse_x - _view_x >= x_pos_current && y_pos >= mouse_y - _view_y; 
	}
	
	
	// _button_highlight_enabled lets you turn of the button highlighting while the game is paused
	static draw = function(_button_highlight_enabled = true) {
		var _view_w = camera_get_view_width(view_camera[0]);
		
		draw_rectangle_color(x_pos_current, 0, _view_w, y_pos, c_silver, c_silver, c_silver, c_silver, false);
		for(var i = 0; i < array_length(buttons); ++i) {
			buttons[i].draw(x_pos_current, 0, _button_highlight_enabled);
		}
	}
	
	
	//This function moves the menu based on its current state. Also accepts a menu toggle boolean
	//Shoud be called in a Step event.
	//Returns the number of pixels the menu has moved, so that any other UI elements can be moved along with it.
	static move_menu = function(_menu_toggle_pressed) {
		var _x_pos_old = x_pos_current;
		switch (state) {
			case SLIDING_MENU_STATE.CLOSED:
				if(_menu_toggle_pressed) {
					state = SLIDING_MENU_STATE.OPENING;
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
					state = SLIDING_MENU_STATE.CLOSING;
				}
				break;
			default:
			    break;
		}
		
		//Will be 0 if menu hasn't moved, positive if the menu is closing, and negative if the menu is opening
		return x_pos_current - _x_pos_old;
	}
	
	
	static select_purchase = function() {
		for(var i = 0; i < array_length(buttons); ++i) {
			if(buttons[i].is_highlighted(x_pos_current, 0)) {
				return buttons[i].purchase_data;
			}
		}
		return undefined;
	}
	
}
#endregion

#endregion


#region Unit Info Card Classes

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
	
	
	static draw = function(_x_offset, _y_offset) {
		//TODO: Figure out how to get the inheritance actually working properly
		var _draw_x_pos = x_pos + _x_offset;
		var _draw_y_pos = y_pos + _y_offset;
		
		if(stat_upgrade_data == undefined) {
			draw_sprite(spr_blank_stat_icon, 0, _draw_x_pos, _draw_y_pos);
			return; //No number for a stat that doesn't exist
		}
		
		var _spr;
		if(!is_enabled()) {
			_spr = button_sprite_disabled;
		}
		else if(/*_button_highlight_enabled &&*/ is_highlighted(_x_offset, _y_offset)) {
			_spr = button_sprite_highlighted;
		}
		else {
			_spr = button_sprite_default;
		}
		draw_sprite(_spr, 0, _draw_x_pos, _draw_y_pos);
		
		
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


#region UnitInfoCardStatUpgrade [OLD] (Class)
/*
	Defines the area where the unit stats and upgrades are.
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal position of the left of the upgrade info (relative to the UnitInfoCard)
	y_pos: Vertical position of the top of the upgrade info (relative to the UnitInfoCard)
	stat_upgrade_data: Unit's upgrade data that should be displayed
	purchase_upgrade_button: The button clicked on to purchase the upgrade
*/
function UnitInfoCardStatUpgrade(_x_pos, _y_pos, _stat_upgrade_data) constructor {
	x_pos = _x_pos;
	y_pos = _y_pos;
	stat_upgrade_data = _stat_upgrade_data;
	
	purchase_button = new StatUpgradeButton(
		x_pos + TILE_SIZE, //TILE_SIZE used because that should be the same size as all of the upgrade data images
		y_pos, stat_upgrade_data)
	

	static on_selected_unit_change = function(_new_upgrade_data) {
		stat_upgrade_data = _new_upgrade_data;
		purchase_button.stat_upgrade_data = stat_upgrade_data;
	}
	
	
	static draw = function(_x_offset, _y_offset) {
		var _draw_x_pos = x_pos + _x_offset;
		var _draw_y_pos = y_pos + _y_offset;
		
		draw_sprite(stat_upgrade_data.upgrade_spr, 0, _draw_x_pos, _draw_y_pos);
		//draw_sprite(spr_upgrade_level, 0, _draw_x_pos + sprite_get_width(upgrade_data.upgrade_spr), _draw_y_pos);
		draw_set_halign(fa_right);
		draw_set_valign(fa_right);
		//Draws the number centered
		draw_text_color(_draw_x_pos + sprite_get_width(stat_upgrade_data.upgrade_spr)*0.9,
			_draw_y_pos + sprite_get_height(stat_upgrade_data.upgrade_spr) - 4,
			stat_upgrade_data.current_level,
			c_white, c_white, c_white, c_white, 1);
		draw_set_halign(fa_left);
		draw_set_valign(fa_left);
		//Draws the purchase button
		purchase_button.draw(_x_offset, _y_offset);
	}
	
}
#endregion


#region UnitStatSquare (Class)
/*
	Used to display all of the stats that a unit has, as well as what levels they currently are.
	
	Argument Variables:
	
	Data Variables:
	x_pos: Horizontal position of the left of the upgrade info (relative to the UnitInfoCard)
	y_pos: Vertical position of the top of the upgrade info (relative to the UnitInfoCard)
	unit: The unit whose stats are being displayed
*/
function UnitStatSquare(_x_pos, _y_pos, _unit) constructor {
	x_pos = _x_pos;
	y_pos = _y_pos;
	unit = _unit;
	
	static draw = function(_x_offset, _y_offset) {
		if(unit == noone) {
			return;
		}
		
		var _draw_x_pos = x_pos + _x_offset;
		var _draw_y_pos = y_pos + _y_offset;
		
		//Top-left: Stat 1
		if(unit.stat_upgrade_1 != undefined) {
			draw_sprite(unit.stat_upgrade_1.upgrade_spr, 0, _draw_x_pos, _draw_y_pos);
			draw_set_halign(fa_right);
			draw_set_valign(fa_right);
			//Draws the number centered
			draw_text_color(_draw_x_pos + sprite_get_width(unit.stat_upgrade_1.upgrade_spr)*0.9,
				_draw_y_pos + sprite_get_height(unit.stat_upgrade_1.upgrade_spr) - 4,
				unit.stat_upgrade_1.current_level,
				c_white, c_white, c_white, c_white, 1);
			draw_set_halign(fa_left);
			draw_set_valign(fa_left);
		}
		else {
			draw_sprite(spr_blank_stat_icon, 0, _draw_x_pos, _draw_y_pos);
		}
		
		//Top-right: Stat 2
		//NOTE: Currently assumes icons are tile-sized, which might not always hold true
		if(unit.stat_upgrade_2 != undefined) {
			draw_sprite(unit.stat_upgrade_2.upgrade_spr, 0, _draw_x_pos + TILE_SIZE, _draw_y_pos);
			draw_set_halign(fa_right);
			draw_set_valign(fa_right);
			//Draws the number centered
			draw_text_color(_draw_x_pos + TILE_SIZE + sprite_get_width(unit.stat_upgrade_2.upgrade_spr)*0.9,
				_draw_y_pos + sprite_get_height(unit.stat_upgrade_2.upgrade_spr) - 4,
				unit.stat_upgrade_2.current_level,
				c_white, c_white, c_white, c_white, 1);
			draw_set_halign(fa_left);
			draw_set_valign(fa_left);
		}
		else {
			draw_sprite(spr_blank_stat_icon, 0, _draw_x_pos + TILE_SIZE, _draw_y_pos);
		}
		
		//Bottom-left: Stat 3
		//NOTE: Currently assumes icons are tile-sized, which might not always hold true
		if(unit.stat_upgrade_3 != undefined) {
			draw_sprite(unit.stat_upgrade_3.upgrade_spr, 0, _draw_x_pos, _draw_y_pos + TILE_SIZE);
			draw_set_halign(fa_right);
			draw_set_valign(fa_right);
			//Draws the number centered
			draw_text_color(_draw_x_pos + sprite_get_width(unit.stat_upgrade_3.upgrade_spr)*0.9,
				_draw_y_pos + TILE_SIZE + sprite_get_height(unit.stat_upgrade_3.upgrade_spr) - 4,
				unit.stat_upgrade_3.current_level,
				c_white, c_white, c_white, c_white, 1);
			draw_set_halign(fa_left);
			draw_set_valign(fa_left);
		}
		else {
			draw_sprite(spr_blank_stat_icon, 0, _draw_x_pos, _draw_y_pos + TILE_SIZE);
		}
		
		//Bottom-right: Stat 2
		//NOTE: Currently assumes icons are tile-sized, which might not always hold true
		if(unit.stat_upgrade_4 != undefined) {
			draw_sprite(unit.stat_upgrade_4.upgrade_spr, 0, _draw_x_pos + TILE_SIZE, _draw_y_pos + TILE_SIZE);
			draw_set_halign(fa_right);
			draw_set_valign(fa_right);
			//Draws the number centered
			draw_text_color(_draw_x_pos + TILE_SIZE + sprite_get_width(unit.stat_upgrade_4.upgrade_spr)*0.9,
				_draw_y_pos + TILE_SIZE + sprite_get_height(unit.stat_upgrade_4.upgrade_spr) - 4,
				unit.stat_upgrade_4.current_level,
				c_white, c_white, c_white, c_white, 1);
			draw_set_halign(fa_left);
			draw_set_valign(fa_left);
		}
		else {
			draw_sprite(spr_blank_stat_icon, 0, _draw_x_pos + TILE_SIZE, _draw_y_pos + TILE_SIZE);
		}
	}
	
}
#endregion


#region UnitStatUpgradeSquare (Class)
/*
	Used to display all of the stat upgrade buttons 
	
	Argument Variables:
	
	Data Variables:
	x_pos: Horizontal position of the left of the upgrade info (relative to the UnitInfoCard)
	y_pos: Vertical position of the top of the upgrade info (relative to the UnitInfoCard)
	unit: The unit whose stats are being displayed
*/
function UnitStatUpgradeSquare(_x_pos, _y_pos, _unit) constructor {
	x_pos = _x_pos;
	y_pos = _y_pos;
	
	stat_upgrade_button_1 = new StatUpgradeButton(x_pos, y_pos);
	stat_upgrade_button_2 = new StatUpgradeButton(x_pos + TILE_SIZE, y_pos);
	stat_upgrade_button_3 = new StatUpgradeButton(x_pos, y_pos + TILE_SIZE);
	stat_upgrade_button_4 = new StatUpgradeButton(x_pos + TILE_SIZE, y_pos + TILE_SIZE);
	
	
	static draw = function(_x_offset, _y_offset) {
		stat_upgrade_button_1.draw(_x_offset, _y_offset);
		stat_upgrade_button_2.draw(_x_offset, _y_offset);
		stat_upgrade_button_3.draw(_x_offset, _y_offset);
		stat_upgrade_button_4.draw(_x_offset, _y_offset);
	}
	
	
	static on_unit_changed = function(_new_unit) {
		if(_new_unit != noone) {
			stat_upgrade_button_1.stat_upgrade_data = _new_unit.stat_upgrade_1;
			stat_upgrade_button_2.stat_upgrade_data = _new_unit.stat_upgrade_2;
			stat_upgrade_button_3.stat_upgrade_data = _new_unit.stat_upgrade_3;
			stat_upgrade_button_4.stat_upgrade_data = _new_unit.stat_upgrade_4;
		}
		else {
			stat_upgrade_button_1.stat_upgrade_data = undefined;
			stat_upgrade_button_2.stat_upgrade_data = undefined;
			stat_upgrade_button_3.stat_upgrade_data = undefined;
			stat_upgrade_button_4.stat_upgrade_data = undefined;
		}
		
	}
	
	
	static get_button_clicked = function(_x_offset, _y_offset) {
		if(stat_upgrade_button_1.is_enabled() &&
			stat_upgrade_button_1.is_highlighted(_x_offset, _y_offset)) {
			return stat_upgrade_button_1;
		}
		else if(stat_upgrade_button_2.is_enabled() &&
			stat_upgrade_button_2.is_highlighted(_x_offset, _y_offset)) {
			return stat_upgrade_button_2;
		}
		else if(stat_upgrade_button_3.is_enabled() &&
			stat_upgrade_button_3.is_highlighted(_x_offset, _y_offset)) {
			return stat_upgrade_button_3;
		}
		else if(stat_upgrade_button_4.is_enabled() &&
			stat_upgrade_button_4.is_highlighted(_x_offset, _y_offset)) {
			return stat_upgrade_button_4;
		}
		else {
			return undefined;
		}
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
			selected_unit.stat_upgrade_1.current_level >= unit_upgrade_data.level_req_1 &&
			selected_unit.stat_upgrade_2.current_level >= unit_upgrade_data.level_req_2 &&
			selected_unit.stat_upgrade_3.current_level >= unit_upgrade_data.level_req_3)
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
function UnitInfoCard(_menu_height_percentage, _x_pos) constructor {
	state = SLIDING_MENU_STATE.CLOSED; //Whether the menu on the bottom is opened or closed
	selected_unit = noone;
	
	var _view_h = camera_get_view_height(view_camera[0]);
	y_pos_open = (1-_menu_height_percentage) * _view_h;
	y_pos_current = _view_h; //Window should start out closed
	x_pos = _x_pos;
	
	active = false;
	
	//Stat Upgrade Info
	stat_icons = new UnitStatSquare(TILE_SIZE*2, TILE_SIZE/4, undefined);
	stat_upgrade_buttons = new UnitStatUpgradeSquare(TILE_SIZE * 5, TILE_SIZE/4, undefined);
	
	//Unit Upgrade Info
	unit_upgrade_button_1 = new UnitUpgradeButton(TILE_SIZE*8, TILE_SIZE/8, undefined, noone);
	unit_upgrade_button_2 = new UnitUpgradeButton(TILE_SIZE*9.5, TILE_SIZE/8, undefined, noone);
	unit_upgrade_button_3 = new UnitUpgradeButton(TILE_SIZE*11, TILE_SIZE/8, undefined, noone);
	
	
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
		stat_icons.unit = selected_unit;
		stat_upgrade_buttons.on_unit_changed(selected_unit);
		
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
		//Only need to do one calculation because the menu takes up the whole bottom of the screen
		return mouse_y - _view_y >= y_pos_current; 
	}
	
	
	// _button_highlight_enabled lets you turn of the button highlighting while the game is paused
	static draw = function(_button_highlight_enabled = true) {
		var _view_h = camera_get_view_height(view_camera[0]);
		
		draw_rectangle_color(0, y_pos_current, x_pos, _view_h, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
		if(selected_unit != noone) {
			draw_sprite(selected_unit.sprite_index, 0, TILE_SIZE*0.5, y_pos_current + TILE_SIZE/4);
			stat_icons.draw(0, y_pos_current);
			stat_upgrade_buttons.draw(0, y_pos_current);
			unit_upgrade_button_1.draw(0, y_pos_current);
			unit_upgrade_button_2.draw(0, y_pos_current);
			unit_upgrade_button_3.draw(0, y_pos_current);
		}
	}
	
	
	//This function moves the menu based on its current state. Also accepts a menu toggle boolean
	//Shoud be called in a Step event.
	//Returns the number of pixels the menu has moved, so that any other UI elements can be moved along with it.
	static move_menu = function(_menu_toggle_pressed) {
		var _y_pos_old = y_pos_current;
		switch (state) {
			case SLIDING_MENU_STATE.CLOSED:
				if(_menu_toggle_pressed) {
					state = SLIDING_MENU_STATE.OPENING;
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
					state = SLIDING_MENU_STATE.CLOSING;
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
	static select_purchase = function() {
		var _selected_purchase_button = stat_upgrade_buttons.get_button_clicked(0, y_pos_current); //Checks all the stat upgrade buttons
		
		if(_selected_purchase_button == undefined) {	//No dedicated struct for all the unit upgrade buttons, so these are all just checked here for now.
			if(unit_upgrade_button_1.is_enabled() &&
				unit_upgrade_button_1.is_highlighted(0, y_pos_current)) {
				_selected_purchase_button = unit_upgrade_button_1;
			}
			else if(unit_upgrade_button_2.is_enabled() &&
				unit_upgrade_button_2.is_highlighted(0, y_pos_current)) {
				_selected_purchase_button = unit_upgrade_button_2;
			}
			else if(unit_upgrade_button_3.is_enabled() &&
				unit_upgrade_button_3.is_highlighted(0, y_pos_current)) {
				_selected_purchase_button = unit_upgrade_button_3;
			}
		}
		
		if(_selected_purchase_button != undefined) {
			_selected_purchase_button.on_click();
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
#macro GAME_INFO_DISPLAY_WIDTH TILE_SIZE*4
#macro GAME_INFO_DISPLAY_HEIGHT TILE_SIZE*2

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
			draw_text_color(TILE_SIZE*(1/2), TILE_SIZE*(1/2), "Victory!", c_black, c_black, c_black, c_black, 1);
		}
		else if(_game_state_manager != undefined && _game_state_manager.state == GAME_STATE.DEFEAT) {
			draw_text_color(TILE_SIZE*(1/2), TILE_SIZE*(1/2), "Defeat...", c_black, c_black, c_black, c_black, 1);
		}
		else if(_round_manager != undefined) {
			draw_text_color(TILE_SIZE*(1/2), TILE_SIZE*(1/2), "Round: " + string(_round_manager.current_round), c_black, c_black, c_black, c_black, 1);
		}
		else { //Fallback in the event we have no manager data. Should never actually show up in real play.
			draw_text_color(TILE_SIZE*(1/2), TILE_SIZE*(1/2), "Round: ???", c_black, c_black, c_black, c_black, 1);
		}
		draw_text_color(TILE_SIZE*(1/2), TILE_SIZE, "Money: " + string(global.player_money), c_black, c_black, c_black, c_black, 1);
		draw_text_color(TILE_SIZE*(1/2), TILE_SIZE*(3/2), "Wall Health: " + string(global.wall_health), c_black, c_black, c_black, c_black, 1);
	};
}
#endregion


#region GameUI (Class)
/*
	Used for managing the entire UI as a unit. Allows you to enable and disable parts of the UI as needed
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
function GameUI(_controller_obj, _purchase_data) constructor {
	//Manager Info
	controller_obj = _controller_obj;
	
	//Viewport info
	view_w =  camera_get_view_width(view_camera[0]);
	view_h = camera_get_view_height(view_camera[0]);
	
	//Pure Display Elements (no interactivity)
	game_info_display = new GameInfoDisplay(_controller_obj);
	
	//Buttons
	pause_button = new PauseButton(PAUSE_BUTTON_X, PAUSE_BUTTON_Y);
	round_start_button = new RoundStartButton(ROUND_START_BUTTON_X, ROUND_START_BUTTON_Y, _controller_obj);
	
	//Menus
	pause_menu = new PauseMenu((1/2), (1/2));
	//NOTE: In the older code, the height was just window_get_height(). See how this changes things.
	purchase_menu = new UnitPurchaseMenu(PURCHASE_MENU_SCREEN_PERCENTAGE, 
		view_h*(1-UNIT_INFO_CARD_SCREEN_PERCENTAGE), _purchase_data);
	unit_info_card = new UnitInfoCard(UNIT_INFO_CARD_SCREEN_PERCENTAGE, view_w);
	
	
	//The cool thing about this is that it lets you prioritize certain GUI elements over others.
	static gui_element_highlighted = function() {
		
		if(game_info_display.active && game_info_display.is_highlighted()) {
			return game_info_display;
		}
		
		if(pause_button.active && pause_button.is_highlighted()) {
			return pause_button;
		}
		
		if(round_start_button.active && round_start_button.is_highlighted()) {
			return round_start_button;
		}
		
		if(purchase_menu.active && purchase_menu.is_highlighted()) {
			return purchase_menu;
		}
		
		if(unit_info_card.active && unit_info_card.is_highlighted()) {
			return unit_info_card;
		}
		
		return undefined; //Mouse is not over any UI elements.
	}
	
	
	static set_gui_running = function() {
		game_info_display.activate();
		pause_button.activate();
		round_start_button.activate();
		purchase_menu.activate();
		unit_info_card.activate();
		
		pause_menu.deactivate();
	}
	
	
	static set_gui_paused = function() {
		game_info_display.activate();
		purchase_menu.activate();
		unit_info_card.activate();
		pause_menu.activate();
		
		pause_button.deactivate();
		round_start_button.deactivate();
	}
	
	
	static draw = function() {
		//var view_w = camera_get_view_width(view_camera[0]);
		//var view_h = camera_get_view_height(view_camera[0]);
		var _game_state_manager = get_game_state_manager(controller_obj);

		//Draw pause menu or not
		//TODO: Needs a little bit more work to implement actual pausing functionality
		if(pause_menu.active) {
			pause_menu.draw_paused_bg();
		}
		
		//Draw basic game stats (done later so that it's drawn over the background sprite)
		if(game_info_display.active) {
			game_info_display.draw();
		}
		
		if(pause_button.active) {
			pause_button.draw();
		}
		
		if(round_start_button.active) {
			round_start_button.draw();
		}

		//Draw purchase menu if it should be present on screen
		if(purchase_menu.active) {
			purchase_menu.draw(_game_state_manager.state == GAME_STATE.RUNNING);
		}
		
		//Draw unit info card if it should be present on screen
		if(unit_info_card.active) {
			unit_info_card.draw(_game_state_manager.state == GAME_STATE.RUNNING);
		}
		
		if(pause_menu.active) {
			pause_menu.draw_menu();
		}

		draw_text(TILE_SIZE, view_h - (TILE_SIZE/2), "Music by Eric Matyas, www.soundimage.org");
	}
	
	
	static clean_up = function() {
		pause_menu.clean_up();
	}
}
#endregion