/// @description Check to see if button is clicked
if(!visible || !layer_get_visible(layer)) { return; }

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self);
if(_mouse_clicked && highlighted) {
		//Generally bad practice to reference variables from objects like this (instead of using a found instance), but since there should only ever be one entity selection menu, it works fine enough.
	play_sound_effect(SFX_Menu_Open);
	var _menu_state = purchase_menu_base.state;
	switch(_menu_state) {
		case SLIDING_MENU_STATE.CLOSED:
		case SLIDING_MENU_STATE.CLOSING:
			purchase_menu_base.state = SLIDING_MENU_STATE.OPENING;
			break;
		case SLIDING_MENU_STATE.OPEN:
		case SLIDING_MENU_STATE.OPENING:
			purchase_menu_base.state = SLIDING_MENU_STATE.CLOSING;
			break;
	}
}