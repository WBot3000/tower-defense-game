/// @description Run the camera controller, round manager and handle menu resizing selection

#region Gathering Necessary User Inputs (some of this is handled in other functions)
var _mouse_left_pressed = mouse_check_button_pressed(mb_left);
var _mouse_left_released = mouse_check_button_released(mb_left);
var _mouse_right_released = mouse_check_button_released(mb_right);

var _pause_toggle_pressed = keyboard_check_pressed(ord(global.GAME_CONFIG_OPTIONS.controls.pause_game_key));
var _o_pressed = keyboard_check_pressed(ord("O"));
var _p_pressed = keyboard_check_pressed(ord("P"));;
#endregion


#region Run Managers
//Check to see if the music should be changed based on events in the game
global.BACKGROUND_MUSIC_MANAGER.on_step();

//Advance the round spawning timer
round_manager.on_step(game_state_manager.state);

//Perform any necessary camera movement based on user_input or game state
camera_controller.move_camera(game_state_manager.state);

//Perform any per-frame UI changes, and check to see if you're highlighting a UI element at the moment.
//var _elem_highlighted = game_ui.on_step();
#endregion


//Check to see if the game should be paused or unpaused
if(_pause_toggle_pressed) {
	if(game_state_manager.state == GAME_STATE.RUNNING) {
		game_state_manager.pause_game();
	}
	else if(game_state_manager.state == GAME_STATE.PAUSED) {
		game_state_manager.resume_game();
	}
}

if(game_state_manager.state != GAME_STATE.RUNNING) { return; } //Don't need to handle anything else if game isn't in RUNNING state


//If the mouse is over any UI elements, don't allow any placement to occur
//NOTE: For some reason, the instance_position function wasn't working properly for this (which is why all this code is here). Probably some UI-layer stuff going on.
var _mouse_gui_x = device_mouse_x_to_gui(0);
var _mouse_gui_y = device_mouse_y_to_gui(0);
currently_highlighted_ui_elem = undefined;
for(var i = 0, len = array_length(ui_elements); i < len; ++i) {
	var _ui_elem = ui_elements[i];
	if(_ui_elem.bbox_left <= _mouse_gui_x && _ui_elem.bbox_right >= _mouse_gui_x &&
		_ui_elem.bbox_top <= _mouse_gui_y && _ui_elem.bbox_bottom >= _mouse_gui_y) {
			currently_highlighted_ui_elem = _ui_elem;
			break;
	}
}
	

//Not over a UI element, so you can take actions on the game field.
if(currently_highlighted_ui_elem == undefined && _mouse_left_released) {
	//Attempt to click on an already placed unit
	var _clicked_on_unit = instance_position(mouse_x, mouse_y, base_unit)
	if(_clicked_on_unit != noone) {
		selected_entity_manager.set_selected_entity(_clicked_on_unit);
		//game_ui.unit_info_card.on_selected_unit_change(_clicked_on_unit);
		//Open the unit info card if it's not open already.
		if(selected_entity_menu_base.state != SLIDING_MENU_STATE.OPEN) {
			selected_entity_menu_base.state = SLIDING_MENU_STATE.OPENING;
		}
	}
		
	//Attempt to make a new purchase
	//Can't purchase anything if nothing is selected (or if you're on the GUI, but we already know we aren't, since if you're here, gui_elem == undefined)
	if(purchase_manager.currently_selected_purchase != undefined) {
		var _tile_at_mouse = instance_position(mouse_x, mouse_y, placeable_tile);
		if(_tile_at_mouse != noone) {
			with(_tile_at_mouse) {
				var _purchase = other.purchase_manager.currently_selected_purchase;
				if(can_purchase_unit(self.id, _purchase)) {
					placed_unit = instance_create_layer(x + TILE_SIZE/2, y + TILE_SIZE, UNIT_LAYER, _purchase.unit);
					global.player_money -= _purchase.price;
					other.broadcast_hub.broadcast_event("unit_purchased", [placed_unit]);
				}
			}
		}
	}
}


if(_mouse_right_released) {
	if(purchase_manager.currently_selected_purchase != undefined) {
		purchase_manager.deselect_purchase();
	}
}


var _current_entity = selected_entity_manager.currently_selected_entity;
//This should really have corresponding buttons but honestly I'm so tired of UI code at this point.
if(game_state_manager.state == GAME_STATE.RUNNING && _o_pressed && _current_entity != noone) { //TODO: If allowing the selection of enemies/targets, make sure to check that this is a unit
	_current_entity.entity_data.targeting_tracker.use_previous_targeting_type();
}

//This should ALSO really have corresponding buttons but honestly I'm so tired of UI code at this point.
if(game_state_manager.state == GAME_STATE.RUNNING && _p_pressed && _current_entity != noone) {
	_current_entity.entity_data.targeting_tracker.use_next_targeting_type();
}
