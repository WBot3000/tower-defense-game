/// @description Check to see if button is clicked
if(!visible || !layer_get_visible(layer)) { return; }

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self);
if(highlighted) {
	sprite_index = spr_level_select_base_highlighted;
}
else {
	sprite_index = spr_level_select_base;
}
if(_mouse_clicked && highlighted && room == LevelSelectScreen) {
	transition_to_new_room(screen_wipe_out, level_data.level_room);
}