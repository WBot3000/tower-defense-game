/// @description Check to see if button is clicked
if(!visible || !layer_get_visible(layer)) { return; }

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self);
if(_mouse_clicked && highlighted) {
	if(game_state_manager == undefined) {
		game_state_manager = get_game_state_manager();
	}
	if(game_state_manager != undefined) { //For when there's a game running
		game_state_manager.resume_game();
	}
	else { //For when there isn't a game running
		close_options_menu();
	}
}