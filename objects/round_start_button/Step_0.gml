/// @description Check to see if button is clicked
if(!visible || !layer_get_visible(layer)) { return; }

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self);
if(_mouse_clicked && highlighted && enabled) {
	round_manager.start_round();
	if(round_manager.current_round == 1) { //If first round started, play the main level music
		global.BACKGROUND_MUSIC_MANAGER.fade_out_current_music(seconds_to_milliseconds(QUICK_MUSIC_FADING_TIME), Music_Round);
	}
	if(round_manager.max_round <= round_manager.current_round) {
		enabled = false;
	}
}