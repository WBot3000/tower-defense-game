/// @description Draw the enemy's health bar

if(variable_struct_exists(entity_data, "range")) {
	entity_data.range.draw_range();
}
if(entity_data.health_state == HEALTH_STATE.ACTIVE) {
	draw_health_bar(get_bbox_center_x(self.id), bbox_top - 4, entity_data.current_health, entity_data.max_health);
}