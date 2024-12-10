/*
This file contains macros, structs, and functions for creating the various menus in the game.
Certain menus have different options based on different contexts. These let you control these options easily.
*/

//Enums for paused menu open state
enum PAUSE_MENU_STATE {
	PAUSE_OPEN,
	PAUSE_CLOSED
}


/*
	Defines all of the data for the Pause Menu
	menu_width_percentage: The percentage of the screen's width that the pause menu should take up.
	menu_height_percentage: The percentage of the screen's height that the pause menu should take up.
*/
function PauseMenu(_menu_width_percentage, _menu_height_percentage) constructor {
	menu_width_percentage = _menu_width_percentage;
	menu_height_percentage = _menu_height_percentage;
	
	static draw = function() {
		var _view_w = camera_get_view_width(view_camera[0]);
		var _view_h = camera_get_view_height(view_camera[0]);
		
		var _x1 = (_view_w/2) - (menu_width_percentage/2 * _view_w); //From middle point, go to the left by the percentage amount
		var _y1 = (_view_h/2) - (menu_height_percentage/2 * _view_h); //From middle point, go up by the percentage amount
		var _x2 = (_view_w/2) + (menu_width_percentage/2 * _view_w); //From middle point, go to the right by the percentage amount
		var _y2 = (_view_h/2) + (menu_height_percentage/2 * _view_h); //From middle point, go down by the percentage amount
		
		draw_rectangle_color(_x1, _y1, _x2, _y2, c_black, c_black, c_black, c_black, false);
		draw_text_color(_x1 + 16, _y1 + 16, "PAUSED", c_white, c_white, c_white, c_white, 1);
	}
}


/*
	Unit Purchase Menu Macros and Enums
*/
//How many pixels the menu should move per frame
#macro PURCHASE_MENU_MOVEMENT_SPEED 32

#macro PURCHASE_MENU_BPR 3 //BPR = Buttons Per Row

//How much of the screen should the unit purchase menu take up while it is open
#macro PURCHASE_MENU_SCREEN_PERCENTAGE (1/3)

//Enums for Unit Purchase Menu state
enum PURCHASE_MENU_STATE {
	CLOSED,
	CLOSING, //For closing animation
	OPENING, //For opening animation
	OPEN
}


/*
	Defines a clickable button for the Unit Selection Menu.
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
	purchase_data: The purchasing data that corresponds with the button.
*/
function UnitPurchaseButton(_x_pos, _y_pos, _purchase_data) constructor {
	x_pos = _x_pos;
	y_pos = _y_pos;
	purchase_data = _purchase_data;
	
	
	static is_highlighted = function(_menu_x_offset, _menu_y_offset) {
		var _absolute_x_pos = x_pos + _menu_x_offset
		var _absolute_y_pos = y_pos + _menu_y_offset
		
		//mouse_x is based on room position, not camera position, so need to correct selection
		var _view_x = camera_get_view_x(view_camera[0]);
		var _view_y = camera_get_view_y(view_camera[0]);
		return (mouse_x - _view_x >= _absolute_x_pos && mouse_x - _view_x <= _absolute_x_pos + sprite_get_width(spr_unit_purchase_button_default)
			&& mouse_y - _view_y >= _absolute_y_pos && mouse_y - _view_y <= _absolute_y_pos + sprite_get_height(spr_unit_purchase_button_default));
	}
	
	
	//_menu_x_offset and _menu_y_offset are the origins of the menu
	// _button_highlight_enabled lets you turn of the button highlighting while the game is paused
	static draw = function(_menu_x_offset, _menu_y_offset, _button_highlight_enabled = true) {
		var _draw_x_pos = x_pos + _menu_x_offset;
		var _draw_y_pos = y_pos + _menu_y_offset;
		
		var _spr = spr_unit_purchase_button_default
		if(_button_highlight_enabled && is_highlighted(_menu_x_offset, _menu_y_offset)) {
			_spr = spr_unit_purchase_button_highlighted
		}
		draw_sprite(_spr, 0, _draw_x_pos, _draw_y_pos);
		draw_sprite(object_get_sprite(purchase_data.unit), 0, _draw_x_pos + 8, _draw_y_pos + 4);
		draw_text(_draw_x_pos + 24, _draw_y_pos + 72, string(purchase_data.price));
	}
}


/*
	Defines all the data for the Unit Purchase Menu.
	menu_width_percentage: How much screen space the menu should take up. Needed to recalculate the size of the menu upon resizing the game window.
	x_pos_open: Horizontal coordinate of the menu's top-left corner when the menu is open.
	x_pos_current: Current horizontal coordinate of the menu's top-left corner (useful for scrolling).
	y_pos: Vertical coordinate of the menu's top-left corner when the menu is open.
	purchase_data_list: The purchasing data array that corresponds with the buttons.
	
	TODO: Store menu state in this struct, or in the game manager object?
*/
function UnitPurchaseMenu(_menu_width_percentage, _y_pos, _purchase_data_list) constructor {
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
	
	
	static update_menu_size = function() {
		var _view_w = camera_get_view_width(view_camera[0]);
		var _new_x_pos_open = (1-menu_width_percentage) * _view_w;
		if(x_pos_open != _new_x_pos_open) { //Only do all these updates only if there's actually been a resize
			x_pos_open = _new_x_pos_open
			//If you can calculate the proportional difference between the old open value and the new one, then you can use that proportion to update the current x-position
			x_pos_current = (_new_x_pos_open / x_pos_open) * x_pos_current;
	
			var _menu_width = _view_w - x_pos_open;
			var _button_width = sprite_get_width(spr_unit_purchase_button_default);

			var _button_x = 0;
			var _button_y = 0;
			var _x_gap = (_menu_width - PURCHASE_MENU_BPR*_button_width) / (PURCHASE_MENU_BPR + 1); //Gap in between buttons (also used as x_margins)
			//Create buttons
			for(var i = 0; i < array_length(buttons); ++i) {
				if(i % PURCHASE_MENU_BPR == 0) { //Start of a new row
					_button_x = _x_gap;
					_button_y += _button_width;
				}
				buttons[i].x_pos = _button_x;
				buttons[i].y_pos = _button_y;
				//array_push(buttons, new UnitPurchaseButton(_button_x, _button_y, _purchase_data_list[i]));
				_button_x += (_button_width + _x_gap);
			}
		}
	}
	
	
	// _button_highlight_enabled lets you turn of the button highlighting while the game is paused
	static draw = function(_button_highlight_enabled = true) {
		var _view_w = camera_get_view_width(view_camera[0]);
		
		draw_rectangle_color(x_pos_current, 0, _view_w, y_pos, c_silver, c_silver, c_silver, c_silver, false);
		for(var i = 0; i < array_length(buttons); ++i) {
			buttons[i].draw(x_pos_current, 0, _button_highlight_enabled);
		}
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