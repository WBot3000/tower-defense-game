/// @description Draw the enemy's health bar and any buffs if hovered over

if(variable_struct_exists(entity_data, "sight_range")) {
	entity_data.sight_range.draw_range();
}
if(entity_data.health_state == HEALTH_STATE.ACTIVE) {
	draw_health_bar(get_bbox_center_x(self.id), bbox_top - 4, current_health, entity_data.max_health);
	buffs.draw_buff_icons();
}