/// @description Check for user input and perform actions accordingly

#region Gathering User Inputs
var _mouse_left_released = mouse_check_button_released(mb_left);
#endregion

if(_mouse_left_released) {
	var _button_pressed = level_select_ui.gui_element_highlighted();
	if(_button_pressed != undefined) {
		_button_pressed.on_click();
	}
}