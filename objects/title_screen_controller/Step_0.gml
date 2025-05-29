/// @description Check for user input and perform actions accordingly

#region Gathering User Inputs
var _mouse_left_released = mouse_check_button_released(mb_left);
#endregion

start_menu_ui.on_step();

if(_mouse_left_released) {
	var _button_pressed = start_menu_ui.gui_element_highlighted();
	if(_button_pressed != undefined) { //Right now, button can either be Play (which does nothing) or Quit (which exits the game)
		_button_pressed.on_click();
	}
}