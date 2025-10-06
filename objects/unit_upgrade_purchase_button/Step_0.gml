/// @description Check to see if button is clicked
if(!visible || !layer_get_visible(layer) || entity == noone) { return; }

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

var _current_stats = entity.stat_upgrades;
var _upgrade_data = entity.unit_upgrades[upgrade_idx];

if(_upgrade_data == undefined) { return; }
//current_upgrade_sprite = current_upgrade_data.new_animbank.get_animation("DEFAULT");
enabled = (_upgrade_data != undefined && global.player_money >= _upgrade_data.price &&
	_current_stats[0].current_level >= _upgrade_data.level_req_1 &&
	_current_stats[1].current_level >= _upgrade_data.level_req_2 &&
	_current_stats[2].current_level >= _upgrade_data.level_req_3);

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self)
if(_mouse_clicked && highlighted && enabled) {
	global.player_money -= _upgrade_data.price;
	_upgrade_data.on_upgrade();
}