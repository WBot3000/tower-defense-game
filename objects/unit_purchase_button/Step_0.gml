/// @description Check to see if button is clicked
if(!visible || !layer_get_visible(layer) || current_purchase_data == undefined) { return; }

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self);

//TODO: Handle this kind of stuff in the purchase manager, so this doesn't have to run every frame

enabled = (global.player_money >= current_purchase_data.price);

if(_mouse_clicked && highlighted && enabled) {
	purchase_manager.set_selected_purchase(current_purchase_data);
}