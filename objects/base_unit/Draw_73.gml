/// @description Draw unit health bar
// You can write your code in this editor

draw_health_bar(get_bbox_center_x(self.id), bbox_top - 4, 
	entity_data.current_health, entity_data.max_health, entity_data.health_state == HEALTH_STATE.KNOCKED_OUT);