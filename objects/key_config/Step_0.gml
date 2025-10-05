/// @description Check for button presses
if(!visible || !layer_get_visible(layer)) { return; }

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
var _key_has_been_pressed = keyboard_check_pressed(vk_anykey);
#endregion

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self);
if(_mouse_clicked && highlighted) {
	selected = true;
	with(key_config) { //You should only be able to select one key at a time
		if(self != other) { //So we don't disable this one
			selected = false;
		}
	}
}

if(selected) {
	flash_timer++;
	if(_key_has_been_pressed) {
		struct_set(global.GAME_CONFIG_OPTIONS.controls, control_string, string_upper(keyboard_lastchar));
		current_key = string_upper(keyboard_lastchar);
		selected = false;
		flash_timer = 0;
	}
	if(flash_timer > 60) {
		flash_timer = 0;
	}
}
