/// @description Run the camera controller, round manager and handle menu resizing selection

/*
	Gather all of the user's inputs
*/
#region
var _mouse_left_released = mouse_check_button_released(mb_left);

var _q_pressed = keyboard_check_pressed(ord("Q"));
var _e_pressed = keyboard_check_pressed(ord("E"));
var _f_pressed = keyboard_check_pressed(ord("F"));
#endregion

//Check to see if the game should be paused or unpaused
//NOTE: Currently just draws the pause menu. Doesn't handle any actual pausing or unpausing
if(_q_pressed) {
	if(game_state_manager.state == GAME_STATE.RUNNING) {
		instance_deactivate_all(true);
		game_state_manager.pause_game();
		game_ui.pause_menu.create_pause_background();
	}
	else if(game_state_manager.state == GAME_STATE.PAUSED) { //TODO: Find a way to roll this all into one component
		/*surface_free(game_ui.pause_menu.surface);
        game_ui.pause_menu.surface = -1;*/
		game_ui.pause_menu.free_pause_background();
		game_state_manager.resume_game();
		instance_activate_all(); //Responsible for re-activating all of the paused instances
	}
}

//Check to see if the music should be changed based on events in the game
music_manager.on_step();

//TODO: Update this to make it more efficient. Currently sets a value every "tick" when it doesn't need to.
//I'm just very tired right now.
//Honestly organize this entire section in general.
if(game_state_manager.state == GAME_STATE.PAUSED && _mouse_left_released) {
	var _selected_pill = game_ui.pause_menu.volume_options.on_click();
	game_ui.pause_menu.volume_options.current_segment = _selected_pill;
	music_manager.set_volume(game_ui.pause_menu.volume_options.current_segment / game_ui.pause_menu.volume_options.num_segments);
}


//Stuff below this section will only run if the game isn't paused
if(game_state_manager.state != GAME_STATE.RUNNING) {
	return;
}

camera_controller.move_camera(!(game_ui.purchase_menu.state != SLIDING_MENU_STATE.CLOSED)); //Disable mouse camera movement while the menu is open (WASD still works though)

//"Advance" the round spawning timer
round_manager.on_step();

if(_mouse_left_released) {
	//Check for certain button presses
	//TODO: Need to neaten up this mouse release code
	//TODO: Replace code in button highlight checks with on click functions
	
	//TODO: Come up with "coordinatior classes" (ex. Pause Coordinator) to sync multiple tasks like this maybe?
	if(game_ui.pause_button.is_highlighted()) { //Don't need to bother with unpausing because you can't use the button while the game is paused
		instance_deactivate_all(true);
		game_state_manager.pause_game();
		game_ui.pause_menu.create_pause_background();
	}
	
	if(game_ui.round_start_button.is_highlighted()) {
		if(music_manager.current_music == Music_PreRound) {
			music_manager.fade_out_current_music(seconds_to_milliseconds(QUICK_MUSIC_FADING_TIME), Music_Round);
		}
		round_manager.start_round();
	}
	
	//See if the player has selected a unit from the Unit Purchase Menu
	if(game_ui.purchase_menu.state != SLIDING_MENU_STATE.CLOSED) {
		var _purchase_selected = game_ui.purchase_menu.select_purchase();
		if(_purchase_selected != undefined) {
			purchase_selected = _purchase_selected;
		}
	}
	

	
	//Can't purchase anything if nothing is selected
	if(purchase_selected != undefined && ! game_ui.is_cursor_on_gui()) {
		var _tile_at_mouse = instance_position(mouse_x, mouse_y, placeable_tile);
		if(_tile_at_mouse == noone) {
			exit;
		}
		with(_tile_at_mouse) {
			/*
			if(placed_unit == noone && global.player_money >= 100 && (array_length(valid_units) == 0 || array_contains(valid_units, unit_picked))) {
				placed_unit = instance_create_layer(x, y, UNIT_LAYER, other.unit_picked);
				global.player_money -= 100//_selected_unit.unit_price;
				highlight = noone; //Can get rid of the highlight on the tile once it's placed
			}
			*/
			var _purchase = other.purchase_selected;
			if(can_purchase_unit(self.id, _purchase)) {
				placed_unit = instance_create_layer(x, y, UNIT_LAYER, _purchase.unit);
				global.player_money -= _purchase.price
				//highlight = noone; //Can get rid of the highlight on the tile once it's placed
			}
		}
	}
}


//Handle different cases for opening and closing the Unit Selection menu
/*
	TODO: Put these into their own functions in the menu object?
	The issue with that is moving the buttons WITH the menu is kind of annoying.
	Do I need to create a "Mover" object responsible for moving all of the objects within it?
*/
switch (game_ui.purchase_menu.state) {
	case SLIDING_MENU_STATE.CLOSED:
		if(_e_pressed) {
			//purchase_menu.open();
			game_ui.purchase_menu.state = SLIDING_MENU_STATE.OPENING;
		}
	    break;
	case SLIDING_MENU_STATE.CLOSING:
		game_ui.purchase_menu.x_pos_current = min(game_ui.purchase_menu.x_pos_current + SLIDING_MENU_MOVEMENT_SPEED, camera_get_view_width(view_camera[0]))
		//Need to move pause button along with it
		game_ui.pause_button.x_pos = min(game_ui.pause_button.x_pos + SLIDING_MENU_MOVEMENT_SPEED, PAUSE_BUTTON_X);
		if(game_ui.purchase_menu.x_pos_current >= camera_get_view_width(view_camera[0])) {
			game_ui.purchase_menu.state = SLIDING_MENU_STATE.CLOSED;
		}
		break;
	case SLIDING_MENU_STATE.OPENING:
		game_ui.purchase_menu.x_pos_current = max(game_ui.purchase_menu.x_pos_current - SLIDING_MENU_MOVEMENT_SPEED, game_ui.purchase_menu.x_pos_open)
		//Need to move pause button along with it
		game_ui.pause_button.x_pos = max(game_ui.pause_button.x_pos - SLIDING_MENU_MOVEMENT_SPEED, PAUSE_BUTTON_X - (camera_get_view_width(view_camera[0]) - game_ui.purchase_menu.x_pos_open));
		if(game_ui.purchase_menu.x_pos_current <= game_ui.purchase_menu.x_pos_open) {
			game_ui.purchase_menu.state = SLIDING_MENU_STATE.OPEN;
		}
		break;
	case SLIDING_MENU_STATE.OPEN:
		if(_e_pressed) {
			//purchase_menu.close();
			game_ui.purchase_menu.state = SLIDING_MENU_STATE.CLOSING;
		}
		break;
	default:
	    break;
}


//Handle different cases for opening and closing the Unit Selection menu
//TODO: Put these into their own functions in the menu object?
switch (game_ui.unit_info_card.state) {
	case SLIDING_MENU_STATE.CLOSED:
		if(_f_pressed) {
			//purchase_menu.open();
			game_ui.unit_info_card.state = SLIDING_MENU_STATE.OPENING;
		}
	    break;
	case SLIDING_MENU_STATE.CLOSING:
		game_ui.unit_info_card.y_pos_current = min(game_ui.unit_info_card.y_pos_current + SLIDING_MENU_MOVEMENT_SPEED, camera_get_view_height(view_camera[0]))
		//Need to move round button along with it
		game_ui.round_start_button.y_pos = min(game_ui.round_start_button.y_pos + SLIDING_MENU_MOVEMENT_SPEED, ROUND_START_BUTTON_Y);
		if(game_ui.unit_info_card.y_pos_current >= camera_get_view_height(view_camera[0])) {
			game_ui.unit_info_card.state = SLIDING_MENU_STATE.CLOSED;
		}
		break;
	case SLIDING_MENU_STATE.OPENING:
		game_ui.unit_info_card.y_pos_current = max(game_ui.unit_info_card.y_pos_current - SLIDING_MENU_MOVEMENT_SPEED, game_ui.unit_info_card.y_pos_open)
		//Need to move pause button along with it
		game_ui.round_start_button.y_pos = max(game_ui.round_start_button.y_pos - SLIDING_MENU_MOVEMENT_SPEED, ROUND_START_BUTTON_Y - (camera_get_view_height(view_camera[0]) - game_ui.unit_info_card.y_pos_open));
		if(game_ui.unit_info_card.y_pos_current <= game_ui.unit_info_card.y_pos_open) {
			game_ui.unit_info_card.state = SLIDING_MENU_STATE.OPEN;
		}
		break;
	case SLIDING_MENU_STATE.OPEN:
		if(_f_pressed) {
			//purchase_menu.close();
			game_ui.unit_info_card.state = SLIDING_MENU_STATE.CLOSING;
		}
		break;
	default:
	    break;
}