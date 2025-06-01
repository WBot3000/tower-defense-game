/// @description Check for user input and perform actions accordingly

#region Gathering User Inputs
var _mouse_left_released = mouse_check_button_released(mb_left);
#endregion

if(_mouse_left_released) {
	var _button_pressed = level_select_ui.get_highlighted_child();
	if(_button_pressed != undefined) {
		_button_pressed.on_released();
	}
}