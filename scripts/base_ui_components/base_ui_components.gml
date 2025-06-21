/*
This file contains UI components that make up other UI components

Hierarchy of Activation:
	By default, UI components are considered NOT activated. This is because it's less clutter to simply activate the components you need, as opposed to having to de-activate all the things you don't.
	Top-level UI components (StartMenuUI, LevelSelectUI, GameUI) are set to be active in their constructors, as there is no reason to de-activate these (they activate/de-activate all their own components)
	A UIParent will not perform any actions while non-active, including performing checks on all of its children, essentially rendering them inactive as well, even if the children aren't marked explicitly as inactive.
*/

#region UIComponent (Class)
/*
	A base component for all other UI components.
	
	Defines activatability and functions that all UI components should have.
	
	Argument Variables:
	_coordinates_defined_relatively: Whether creation coordinates are specified in terms of the parent's origin (true) or the global window origin (false)
	
	Data Variables:
	x_pos: The x_coordinate of the UIParent's top-left position. This will be 0 if the parent is meant to cover the entire UI.
	y_pos: The y_coordinate of the UIParent's top-left position. This will be 0 if the parent is meant to cover the entire UI.
	parent: The UI element that "owns" this element in the hierarchy.
*/
function UIComponent(_x_pos = 0, _y_pos = 0, _parent = other, _coordinates_defined_relatively = true) constructor {
	active = false;
	
	parent = undefined;
	x_pos = _x_pos;
	y_pos = _y_pos;
	if(is_instanceof(_parent, UIComponent)) { //Prevents issues with the top-level UIComponent
		parent = _parent;
		if(_coordinates_defined_relatively) {
			x_pos += parent.x_pos;
			y_pos += parent.y_pos;
		}
	}
	
	//TODO: Fetch on a needed basis
	view_w =  camera_get_view_width(view_camera[0]);
	view_h = camera_get_view_height(view_camera[0]);
	
	children = [];
	
	//Basically just a wrapper for activating the component
	static activate = function() { active = true; }
	
	//Basically just a wrapper for deactivating the component
	static deactivate = function() { active = false; }
	
	static is_highlighted = function() { return false; } //If no function is defined, assume the element can't be highlighted
	
	static get_highlighted_child = function() {
		if(!active) {
			return undefined;
		}
		//Array is searched from end to beginning so that elements drawn in the front are checked before elements drawn in the back
		for(var i = array_length(children) - 1; i >= 0; i--) {
			if(children[i].active && children[i].is_highlighted()) {
				return children[i];
			}
		}
		return undefined;
	}
	
	
	static move = function(_x_delta = 0, _y_delta = 0) {
		x_pos += _x_delta;
		y_pos += _y_delta;
		for(var i = 0; i < array_length(children); ++i) { //Move all the children along with the parent
				children[i].move(_x_delta, _y_delta);
		}
	}
	
	
	static draw = function() {
		if(!active) {
			return;
		}
		for(var i = 0; i < array_length(children); ++i) {
			if(children[i].active) {
				children[i].draw();
			}
		}
	}
	
	
	//This allows things like sliders that can take continuous input (via holding down the mouse)
	//Returns the GUI element that's currently highlighted (in case you want to do anything else with it).
	static on_step = function() {
		if(!active) {
			return undefined;
		}
		for(var i = array_length(children) - 1; i >= 0; i--) {
				children[i].on_step();
		}

		var _highlighted_elem = get_highlighted_child();
		if(_highlighted_elem != undefined) {
			if(mouse_check_button_pressed(mb_left)) {
				_highlighted_elem.on_pressed();
			}
			if(mouse_check_button_released(mb_left)) {
				//TODO: So I was able to fix the error with the sliders by just adding the release into the "on_step" event as well.
				//However, I still think I should revise how these functions works. Feels pretty hack-ish, and I don't want this code to become messier than it already is.
				//Especially if you have UIParents inside UIParents, that's gotta be funky with the on_step, THEN on_released
				_highlighted_elem.on_released();
			}
		}
		return _highlighted_elem
	}
	
	
	//The function that's called when the UIComponent is first clicked on
	/*
		To prevent an absolutely insane amount of:
			on_pressed_parent
			on_pressed
		I decided to limit the on_pressed function to stuff all components do, and then make a separate function called pressed_fn that handles component unique stuff.
		That way, you can just override pressed_fn instead of needing to do the parent stuff in the child component
		on_released works the same way
	*/
	static pressed_fn = function() {};
	static on_pressed = function() {
		_transition = get_room_transition();
		if(_transition != undefined && _transition.state != TRANSITION_STATE.NOT_TRANSITIONING) { //Want to disable interaction when a transition effect is running
			return;
		}
		pressed_fn(); //Code from deriving components would go here
	}
	
	
	static released_fn = function() {};
	static on_released = function() {
		_transition = get_room_transition();
		if(_transition != undefined && _transition.state != TRANSITION_STATE.NOT_TRANSITIONING) { //Want to disable interaction when a transition effect is running
			return;
		}
		released_fn(); //Code from deriving parents would go here
	}
	
	
	static clean_up = function() {
		for(var i = 0; i < array_length(children); ++i) {
			children[i].clean_up();
		}
	}
}
#endregion


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
function Button(_x_pos, _y_pos, 
	_button_sprite_default, _button_sprite_disabled = _button_sprite_default, _button_sprite_highlighted = _button_sprite_default) :
	UIComponent(_x_pos, _y_pos) constructor {
	button_sprite_default = _button_sprite_default;
	button_sprite_disabled = _button_sprite_disabled;
	button_sprite_highlighted = _button_sprite_highlighted;

	//Determines whether or not a button should be clickable or not.
	//Basically always overridden, mainly just here for completion's sake;
	//NOTE: Shouldn't accept any parameters.
	static is_enabled = function() {
		return true;
	}
	
	
	static is_highlighted = function() {
		//TODO: Passable view_camera index? And maybe rename these variables? Not sure.
		var _view_x = device_mouse_x_to_gui(0);
		var _view_y = device_mouse_y_to_gui(0);
		return (_view_x >= x_pos && _view_x <= x_pos + sprite_get_width(button_sprite_default)
			&& _view_y >= y_pos && _view_y <= y_pos + sprite_get_height(button_sprite_default));
	}
	
	
	// _button_highlight_enabled lets you turn of the button highlighting while the game is paused
	static draw = function(_button_highlight_enabled = true) {
		var _spr;
		if(!is_enabled()) {
			_spr = button_sprite_disabled;
		}
		else if(_button_highlight_enabled && is_highlighted()) {
			_spr = button_sprite_highlighted;
		}
		else {
			_spr = button_sprite_default;
		}
		draw_sprite(_spr, 0, x_pos, y_pos);
	}
}
#endregion


#region ToggleSwitch (Class)
/*
	Defines a switch that can be clicked to switch between two different "states".
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
	label:
	is_toggled: Whether or not the button 
	
	TODO: I haven't done control variables in a while. Should I still do these, or nah?
	Control Variables:
	active: Whether or not the button should appear on screen and can be clicked on
	
	NOTE 1: "Enabled" refers to whether or not the button can be clicked to perform an action. "Active" refers to whether or not the button is rendered at all.
*/
function ToggleSwitch(_x_pos, _y_pos, _label = "Unnamed Toggle") : UIComponent(_x_pos, _y_pos) constructor {
	label = _label;
	is_toggled = false;

	static is_highlighted = function() {
		//TODO: Passable view_camera index? And maybe rename these variables? Not sure.
		var _view_x = device_mouse_x_to_gui(0);
		var _view_y = device_mouse_y_to_gui(0);
		return (_view_x >= x_pos && _view_x <= x_pos + sprite_get_width(spr_toggle_switch_not_selected)
			&& _view_y >= y_pos && _view_y <= y_pos + sprite_get_height(spr_toggle_switch_not_selected));
	}
	
	
	static draw = function() {
		draw_set_halign(fa_right);
		draw_text_color(x_pos - 8, y_pos, label, c_white, c_white, c_white, c_white, 1);
		draw_set_halign(fa_left);
		draw_sprite((is_toggled ? spr_toggle_switch_selected : spr_toggle_switch_not_selected), 0, x_pos, y_pos);
	}
	
	
	static on_toggle = function(){};
	static on_untoggle = function(){};
	
	static released_fn = function() {
		if(is_toggled) {
			on_untoggle(); //If the switch is toggled, when we click it, it should untoggle
		}
		else {
			on_toggle();
		}
		is_toggled = !is_toggled;
	};
}
#endregion


#region Slider (Class)
/*
	Describes a slider class. Allows you to select from a certain range (with the leftmost position being the lowest, and the rightmost position being the highest)
	
	Argument Variables:
	_default_value: The value that the slider should be initialized with.
	All correlate with Data Variables
	
	Data Variables: (NOTE: Coordinates relative to the parent object as usual. Use offsets to get the absolute positions as normal)
	x_pos_left: Where the left of the slider resides.
	x_pos_right: Coordinate where the right of the slider resides.
	y_pos: Vertical position of the slider.
	label: A string that indicates what the slider does.
	min_value: The value selected when the slider is set to the leftmost position.
	max_value: The value selected when the slider is set to the rightmost position.
	current_value: The value the slider is currently set to.
	current_value_x_pos: The slider's current value mapped to an x-coordinate on the slider line (where the circle resides)
	is_selected: Whether or not this slider is the one the user selected. Allows you to continue sliding the slider after you've moved off of its hitbox.
*/
function Slider(_x_pos_left, _x_pos_right, _y_pos, _label = "Unnamed Slider",
	_min_value = 0, _max_value = 100, _default_value = _max_value) : UIComponent(_x_pos_left, _y_pos) constructor {
	x_pos_right = _x_pos_right;
	
	if(parent != undefined) {
		x_pos_right += parent.x_pos;
	}

	label = _label
	min_value = _min_value;
	max_value = _max_value;
	
	current_value = _default_value;
	//No need to re-calculate this each time we draw the slider
	current_value_x_pos = map_value(current_value, min_value, max_value, x_pos, x_pos_right);
	
	is_selected = false;
	
	//_x_offset and _y_offset are for sliders that are a part of menus. They allow you to define the coordinates in relation to the menu instead of to the entire screen.
	static is_highlighted = function() {		
		//TODO: Passable view_camera index? And maybe rename these variables? Not sure.
		var _view_x = device_mouse_x_to_gui(0);
		var _view_y = device_mouse_y_to_gui(0);
		return (_view_x >= x_pos - 16 && _view_x <= x_pos_right + 16
			&& _view_y >= y_pos - 16 && _view_y <= y_pos + 16); //TODO: Should probably change 16 to relate to the size of the slider circle sprite.
	}
	
	
	static draw = function() {
		if(active) {
			draw_text_color(x_pos, y_pos - 32, label + ": " + string( floor(current_value)), c_white, c_white, c_white, c_white, 1);
			draw_line_width_color(x_pos, y_pos, x_pos_right, y_pos, 4, c_white, c_white);
			draw_sprite((is_selected ? spr_slider_circle_selected : spr_slider_circle_default), 0, current_value_x_pos, y_pos);
		}
	}
	
	
	static move_parent = move;
	static move = function(_x_delta, _y_delta) {
		move_parent();
		current_value_x_pos += _x_delta //When moving the slider, we need to move the value of the knob too
	}
	
	
	static change_slider_value = function(_new_x_pos) {
		if(_new_x_pos <= x_pos) {
			current_value = min_value;
			current_value_x_pos = x_pos;
		}
		else if(_new_x_pos >= x_pos_right) {
			current_value = max_value;
			current_value_x_pos = x_pos_right;
		}
		else {
			current_value = map_value(_new_x_pos, x_pos, x_pos_right, min_value, max_value);
			current_value_x_pos = _new_x_pos;
		}
	}
	
	//Logic for when the mouse is held down (and when it isn't, hence the "is_highlighted" check)
	static on_step = function() {
		if(is_selected && mouse_check_button(mb_left)) {
			change_slider_value(device_mouse_x_to_gui(0)); //Move knob to mouse
		}
		if( mouse_check_button_released(mb_left)) { //Need to be able to release control of the slider even if the cursor currently isn't on it.
			is_selected = false;
		}
	}
	
	//When the mouse is pressed
	static pressed_fn = function() {
		is_selected = true;
	}
	
	//When the mouse is released
	static released_fn = function() {
		is_selected = false;
	}
}
#endregion


#region KeyConfig (Class)
/*
	A component that lets you change the key for certain controls
	
	Data Cariables:
	x_pos: X-coordinate of the top left corner
	y_pos: Y-coordinate of the top left corner
	key: String reference to the control that this component can change
	label: The component's label
*/
function KeyConfig(_x_pos, _y_pos, _key, _label = "Unnamed Toggle") : UIComponent(_x_pos, _y_pos) constructor {
	key = _key;
	label = _label;
	selected = false;

	static is_highlighted = function() {
		//TODO: Passable view_camera index? And maybe rename these variables? Not sure.
		var _view_x = device_mouse_x_to_gui(0);
		var _view_y = device_mouse_y_to_gui(0);
		return (_view_x >= x_pos && _view_x <= x_pos + sprite_get_width(spr_key_config)
			&& _view_y >= y_pos && _view_y <= y_pos + sprite_get_height(spr_key_config));
	}
	
	
	static draw = function() {
		draw_set_halign(fa_right);
		draw_text_color(x_pos - 8, y_pos, label, c_white, c_white, c_white, c_white, 1);
		draw_set_halign(fa_center);
		draw_sprite(spr_key_config, 0, x_pos, y_pos);
		if(!selected || floor(get_timer()/500000) % 2 == 1) { //Basic flashing effect
			draw_text_color(x_pos + 32, y_pos, global.GAME_CONFIG_SETTINGS.controls[$ key], 
			c_white, c_white, c_white, c_white, 1);
		}
		draw_set_halign(fa_left)
	}
	
	
	static pressed_fn = function() {
		//TODO: If there's a toggle already selected, de-select it
		selected = true;
	};
	
	//TODO: Replace with key change modal probably
	static on_step = function() {
		if(selected && keyboard_check_pressed(vk_anykey)) {
			global.GAME_CONFIG_SETTINGS.controls[$ key] = string_upper(keyboard_lastchar);
			selected = false;
		}
	}
}
#endregion


#region PopupMenuTab (Class)
/*
*/
function PopupMenuTab(_x_pos, _y_pos, _tab_name) : 
	Button(_x_pos, _y_pos, spr_menu_tab) constructor {
	tab_name = _tab_name;
	
	static draw_parent = draw;
	static draw = function() {
		draw_parent();
		draw_set_alignments(fa_center, fa_center);
		draw_text_color(x_pos + sprite_get_width(spr_menu_tab)/2 - 2, y_pos + sprite_get_height(spr_menu_tab)/2 + 2, tab_name, c_white, c_white, c_white, c_white, 1);
		draw_set_alignments();
	}
}
#endregion


#region PopupMenu (Class)
/*
	Defines a menu that appears over the main screen (as opposed to being a dediicated room/page)
	
	Argument Variables:
	_menu_width_percentage: The percentage of the screen's width this menu should take up
	_menu_height_percentage: The percentage of the screen's height this menu should take up
	All other argument variables correlate to data variables.
	
	Data Variables:
	x_pos: Left boundary
	y_pos: Upper boundary
	menu_width: Menu width
	menu_height: Menu height
	title: Large text that appears at the top of the menu
*/
enum POPUP_MENU_STATE {
	MENU_OPEN,
	MENU_CLOSED
}

#macro BORDER_PX 4

function PopupMenu(_menu_width_percentage, _menu_height_percentage, _title) : UIComponent() constructor {
	//TODO: Currently assumes all popup menus will start in the center of the screen. Should probably change this assumption.
	x_pos = (view_w/2) - (_menu_width_percentage/2 * view_w); //From middle point, go to the left by the percentage amount
	y_pos = (view_h/2) - (_menu_height_percentage/2 * view_h); //From middle point, go up by the percentage amount
	
	if(parent != undefined) {
		x_pos += parent.x_pos;
		y_pos += parent.y_pos;
	}
	
	menu_width = view_w * _menu_width_percentage;
	menu_height = view_h * _menu_height_percentage;
	
	title = _title;
	
	
	static draw_parent = draw;
	static draw = function(_x_offset = 0, _y_offset = 0) {
		var _draw_x2 = x_pos + menu_width;
		var _draw_y2 = y_pos + menu_height;
		
		draw_rectangle_color(x_pos - BORDER_PX, y_pos - BORDER_PX, _draw_x2 + BORDER_PX, _draw_y2 + BORDER_PX, 
			c_white, c_white, c_white, c_white, false) //For a nice border
		draw_rectangle_color(x_pos, y_pos, _draw_x2, _draw_y2, c_black, c_black, c_black, c_black, false);
		draw_set_halign(fa_center);
		draw_text_color(x_pos + menu_width/2, y_pos + 32, title, c_white, c_white, c_white, c_white, 1);
		draw_set_halign(fa_left);
		draw_parent();
	}
	
	static is_highlighted = function() {
		var _absolute_x2 = x_pos + menu_width;
		var _absolute_y2 = y_pos + menu_height;
		
		var _mouse_x_gui = device_mouse_x_to_gui(0);
		var _mouse_y_gui = device_mouse_y_to_gui(0);
		return _mouse_x_gui >= x_pos - BORDER_PX && _mouse_x_gui <= _absolute_x2 + BORDER_PX && 
			_mouse_y_gui >= y_pos - BORDER_PX && _mouse_y_gui <= _absolute_y2 + BORDER_PX;
	}
	
}
#endregion

//TODO: Create a sliding menu class that can be used for both sliding menus? Or too much work for little benefit?