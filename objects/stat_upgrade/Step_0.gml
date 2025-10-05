/// @description Determine if a purchase should be made
if(!visible || !layer_get_visible(layer)) { return; }

//TODO: Replace with broadcasting system
if(selected_entity_manager.currently_selected_entity == noone) {
	current_stat_data = undefined;
	enabled = false;
	return;
}

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

current_stat_data = selected_entity_manager.currently_selected_entity.stat_upgrades[stat_idx];
enabled = (current_stat_data != undefined && global.player_money >= current_stat_data.current_price && current_stat_data.current_level < current_stat_data.max_level);

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self)
if(_mouse_clicked && highlighted && enabled) {
	global.player_money -= current_stat_data.current_price;
	current_stat_data.on_upgrade();
}