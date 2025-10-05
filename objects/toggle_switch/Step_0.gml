/// @description Check to see if button is clicked
if(!visible || !layer_get_visible(layer)) { return; }

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self);
if(_mouse_clicked && highlighted) {
	toggled = !toggled;
	sprite_index = toggled ? spr_toggle_switch_selected : spr_toggle_switch_not_selected;
	on_toggle_func();
}