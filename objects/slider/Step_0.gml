/// @description Insert description here
if(!visible || !layer_get_visible(layer)) { return; }

#region Gather Inputs
var _mouse_pressed = mouse_check_button_pressed(mb_left);
var _mouse_held = mouse_check_button(mb_left);
var _mouse_released = mouse_check_button_released(mb_left);
#endregion

if(_mouse_released) {
	held = false;
	return;
}

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self);
if(_mouse_pressed && highlighted) {
	held = true;
}

if(_mouse_held && held) {
	nob_x = max(left_bound, min(right_bound, device_mouse_x_to_gui(0))); //Don't go beyond boundaries of the slider
	on_value_changed_func(map_value(nob_x, left_bound, right_bound, 0, 100));
}