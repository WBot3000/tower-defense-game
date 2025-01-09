/// @description Run the camera controller, round manager and handle menu resizing selection

//Update menu size if the screen has been resized
//TODO: Seems to be currently buffed
//purchase_menu.update_menu_size();

var _mouse_left_released = mouse_check_button_released(mb_left);

var _q_pressed = keyboard_check_pressed(ord("Q"));
var _e_pressed = keyboard_check_pressed(ord("E"));

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

//Check for defeat. TODO: Will probably move this somewhere else in the future
//if(global.wall_health <= 0) {
//	event_user(1);
//}

//Stuff below this section will only run if the game isn't paused
if(game_state_manager.state != GAME_STATE.RUNNING) {
	return;
}

camera_controller.move_camera(!(game_ui.purchase_menu.state != PURCHASE_MENU_STATE.CLOSED)); //Disable mouse camera movement while the menu is open (WASD still works though)

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
	if(game_ui.purchase_menu.state != PURCHASE_MENU_STATE.CLOSED && _mouse_left_released) {
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
				highlight = noone; //Can get rid of the highlight on the tile once it's placed
			}
		}
	}
}


//Handle different cases for opening and closing the Unit Selection menu
//TODO: Put these into their own functions in the menu object?
//TODO: Currently, when resizing the window, the closing function takes longer to complete.
switch (game_ui.purchase_menu.state) {
	case PURCHASE_MENU_STATE.CLOSED:
		if(_e_pressed) {
			//purchase_menu.open();
			game_ui.purchase_menu.state = PURCHASE_MENU_STATE.OPENING;
		}
	    break;
	case PURCHASE_MENU_STATE.CLOSING:
		game_ui.purchase_menu.x_pos_current = min(game_ui.purchase_menu.x_pos_current + PURCHASE_MENU_MOVEMENT_SPEED, camera_get_view_width(view_camera[0]))
		//Need to move pause button along with it
		game_ui.pause_button.x_pos = min(game_ui.pause_button.x_pos + PURCHASE_MENU_MOVEMENT_SPEED, PAUSE_BUTTON_X);
		if(game_ui.purchase_menu.x_pos_current >= camera_get_view_width(view_camera[0])) {
			game_ui.purchase_menu.state = PURCHASE_MENU_STATE.CLOSED;
		}
		break;
	case PURCHASE_MENU_STATE.OPENING:
		game_ui.purchase_menu.x_pos_current = max(game_ui.purchase_menu.x_pos_current - PURCHASE_MENU_MOVEMENT_SPEED, game_ui.purchase_menu.x_pos_open)
		//Need to move pause button along with it
		game_ui.pause_button.x_pos = max(game_ui.pause_button.x_pos - PURCHASE_MENU_MOVEMENT_SPEED, PAUSE_BUTTON_X - (camera_get_view_width(view_camera[0]) - game_ui.purchase_menu.x_pos_open));
		if(game_ui.purchase_menu.x_pos_current <= game_ui.purchase_menu.x_pos_open) {
			game_ui.purchase_menu.state = PURCHASE_MENU_STATE.OPEN;
		}
		break;
	case PURCHASE_MENU_STATE.OPEN:
		if(_e_pressed) {
			//purchase_menu.close();
			game_ui.purchase_menu.state = PURCHASE_MENU_STATE.CLOSING;
		}
		break;
	default:
	    break;
}