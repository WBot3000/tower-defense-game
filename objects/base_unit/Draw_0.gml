/// @description Draw the sight radius if the cursor is hovering over the unit

if(position_meeting(mouse_x, mouse_y, self) && selected_entity_manager.currently_selected_entity != self) {
	if(variable_struct_exists(entity_data, "sight_range")) {
		entity_data.sight_range.draw_range();
	}
}
draw_self();