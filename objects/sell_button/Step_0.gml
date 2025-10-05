/// @description Determine if a purchase should be made
if(!visible || !layer_get_visible(layer) || selected_entity_manager == undefined) { return; }

current_entity = selected_entity_manager.currently_selected_entity;
if (current_entity == noone) { return; }

#region Gather Inputs
var _mouse_clicked = mouse_check_button_released(mb_left);
#endregion

highlighted = instance_position(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), self)
if(_mouse_clicked && highlighted) {
	//Since the origin of units is centre-bottom, check one point above the origin for the tile. Otherwise, we accidentally mark the tile below as free for placement.
	with(current_entity) { //For some reason, doing it outside of the with causes a crash (maybe because this is a UI element?)
		var _tile = instance_position(x, y - 1, placeable_tile);
		_tile.placed_unit = noone;
		global.player_money += sell_price;
		//Need to clear these reference so they aren't pointing to something invalid
		instance_destroy();
	}
	selected_entity_manager.deselect_entity();
	current_entity = noone;
}