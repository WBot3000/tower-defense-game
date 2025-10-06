/// @description Change targeting type
if(!visible || !layer_get_visible(layer) || entity == noone) { return; }

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self)

if(_mouse_clicked && highlighted) {
	entity.targeting_tracker.use_next_targeting_type();
}