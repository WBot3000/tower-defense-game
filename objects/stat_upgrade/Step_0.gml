/// @description Determine if a purchase should be made
if(!visible || !layer_get_visible(layer) || entity == noone) { return; }

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

var _curr_stat_data = entity.stat_upgrades[stat_idx];

enabled = (_curr_stat_data != undefined && global.player_money >= _curr_stat_data.current_price && _curr_stat_data.current_level < _curr_stat_data.max_level);

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self)
if(_mouse_clicked && highlighted && enabled) {
	global.player_money -= _curr_stat_data.current_price;
	_curr_stat_data.on_upgrade();
}