/// @description Check to see if button is clicked
if(!visible || !layer_get_visible(layer)) { return; }

//TODO: Handle this when the page changes, so this doesn't run every step
var _current_page_data = purchase_menu_base.purchase_list[purchase_menu_base.current_page];
if(array_length(_current_page_data) <= button_number) {
	enabled = false;
	return;
}
var _current_purchase_data = _current_page_data[button_number];

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self);

//TODO: Handle this kind of stuff in the purchase manager, so this doesn't have to run every frame

enabled = (global.player_money >= _current_purchase_data.price);

if(_mouse_clicked && highlighted && enabled) {
	purchase_manager.set_selected_purchase(_current_purchase_data);
}