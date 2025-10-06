/// @description Check to see if button is clicked
if(!visible || !layer_get_visible(layer) || layer_get_visible(GUI_OPTIONS_MENU)) { return; } //Don't make these clickable when pause menu is open

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self);
if(_mouse_clicked && highlighted) {
	on_click();
}