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
	if(game_state == GAME_STATE.RUNNING) {
		game_state = GAME_STATE.PAUSED;
	}
	else if(game_state == GAME_STATE.PAUSED) {
		instance_activate_all(); //Responsible for re-activating all of the paused instances
        surface_free(pause_screen_surface);
        pause_screen_surface = -1;
		game_state = GAME_STATE.RUNNING;
	}
}

//Stuff below this section will only run if the game isn't paused
if(game_state != GAME_STATE.RUNNING) {
	return;
}

camera_controller.move_camera(!(purchase_menu_state != PURCHASE_MENU_STATE.CLOSED)); //Disable mouse camera movement while the menu is open (WASD still works though)

//"Advance" the round spawning timer
round_manager.on_step();

//See if the player has selected a unit from the Unit Purchase Menu
if(purchase_menu_state != PURCHASE_MENU_STATE.CLOSED && _mouse_left_released) {
	var _purchase_selected = purchase_menu.select_purchase();
	if(_purchase_selected != undefined) {
		purchase_selected = _purchase_selected;
	}
}

//Handle different cases for opening and closing the Unit Selection menu
//TODO: Put these into their own functions in the menu object?
//TODO: Currently, when resizing the window, the closing function takes longer to complete.
switch (purchase_menu_state) {
	case PURCHASE_MENU_STATE.CLOSED:
		if(_e_pressed) {
			//purchase_menu.open();
			purchase_menu_state = PURCHASE_MENU_STATE.OPENING;
		}
	    break;
	case PURCHASE_MENU_STATE.CLOSING:
		purchase_menu.x_pos_current = min(purchase_menu.x_pos_current + PURCHASE_MENU_MOVEMENT_SPEED, camera_get_view_width(view_camera[0]))
		if(purchase_menu.x_pos_current >= camera_get_view_width(view_camera[0])) {
			purchase_menu_state = PURCHASE_MENU_STATE.CLOSED;
		}
		break;
	case PURCHASE_MENU_STATE.OPENING:
		purchase_menu.x_pos_current = max(purchase_menu.x_pos_current - PURCHASE_MENU_MOVEMENT_SPEED, purchase_menu.x_pos_open)
		if(purchase_menu.x_pos_current <= purchase_menu.x_pos_open) {
			purchase_menu_state = PURCHASE_MENU_STATE.OPEN;
		}
		break;
	case PURCHASE_MENU_STATE.OPEN:
		if(_e_pressed) {
			//purchase_menu.close();
			purchase_menu_state = PURCHASE_MENU_STATE.CLOSING;
		}
		break;
	default:
	    break;
}