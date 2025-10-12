/// @description Draw unit health bar and buffs/debuffs

draw_health_bar(get_bbox_center_x(self.id), bbox_top - 4, 
	current_health, entity_data.max_health, health_state == HEALTH_STATE.KNOCKED_OUT);

if(selected_entity_manager.currently_selected_entity == self || position_meeting(mouse_x, mouse_y, self)) {
	buffs.draw_buff_icons();
}