/// @description Check to see if button is clicked
if(!visible || !layer_get_visible(layer)) { return; }

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

enabled = (game_state_manager != undefined && game_state_manager.state == GAME_STATE.RUNNING);

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self);
if(_mouse_clicked && highlighted && enabled) {
	game_state_manager.pause_game();
}