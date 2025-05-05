/// @description Run the camera controller, round manager and handle menu resizing selection

#region Gathering User Inputs
var _mouse_left_released = mouse_check_button_released(mb_left);
var _mouse_right_released = mouse_check_button_released(mb_right);

var _q_pressed = keyboard_check_pressed(ord("Q"));
var _e_pressed = keyboard_check_pressed(ord("E"));
var _f_pressed = keyboard_check_pressed(ord("F"));
var _o_pressed = keyboard_check_pressed(ord("O"));
var _p_pressed = keyboard_check_pressed(ord("P"));;
#endregion

//Check to see if the game should be paused or unpaused
if(_q_pressed) {
	if(game_state_manager.state == GAME_STATE.RUNNING) {
		game_state_manager.pause_game();
	}
	else if(game_state_manager.state == GAME_STATE.PAUSED) {
		game_state_manager.resume_game();
	}
}

//Check to see if the music should be changed based on events in the game
//music_manager.on_step();
global.BACKGROUND_MUSIC_MANAGER.on_step();

if(game_state_manager.state == GAME_STATE.PAUSED && _mouse_left_released) {
	game_ui.pause_menu.on_click();
}


//"Advance" the round spawning timer
round_manager.on_step(game_state_manager.state);

//Perform any necessary camera movement based on user_input
camera_controller.move_camera(game_state_manager.state);

//Perform any per-frame UI changes
game_ui.on_step();


if(_mouse_left_released) {
	//Check for certain areas clicked
	var gui_elem = game_ui.gui_element_highlighted();
	//show_debug_message(gui_elem)
	if(gui_elem != undefined) {
		gui_elem.on_click();
	}
	else {
		//Attempt to click on an already placed unit
		var _clicked_on_unit = instance_position(mouse_x, mouse_y, base_unit)
		if(_clicked_on_unit != noone) {
			game_ui.unit_info_card.on_selected_unit_change(_clicked_on_unit);
			//Open the unit info card if it's not open already.
			if(game_ui.unit_info_card.state != SLIDING_MENU_STATE.OPENING && game_ui.unit_info_card.state != SLIDING_MENU_STATE.OPEN) {
				game_ui.unit_info_card.state = SLIDING_MENU_STATE.OPENING;
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
						global.player_money -= _purchase.price
					}
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


//This should really have corresponding buttons but honestly I'm so tired of UI code at this point.
if(game_state_manager.state != GAME_STATE.PAUSED &&
	_o_pressed && game_ui.unit_info_card.selected_unit != noone) {
	game_ui.unit_info_card.selected_unit.targeting_tracker.use_previous_targeting_type();
}

//This should ALSO really have corresponding buttons but honestly I'm so tired of UI code at this point.
if(game_state_manager.state != GAME_STATE.PAUSED &&
	_p_pressed && game_ui.unit_info_card.selected_unit != noone) {
	game_ui.unit_info_card.selected_unit.targeting_tracker.use_next_targeting_type();
}


//Handle different cases for opening and closing the Unit Selection menu
var _purchase_menu_move_distance = game_ui.purchase_menu.move_menu(_e_pressed);
game_ui.pause_button.x_pos += _purchase_menu_move_distance; //Move the pause button along with the purchase menu

//Handle different cases for opening and closing the Unit Info Card
var _unit_card_move_distance = game_ui.unit_info_card.move_menu(_f_pressed);
game_ui.round_start_button.y_pos += _unit_card_move_distance; //Move the round start button along with the unit info card