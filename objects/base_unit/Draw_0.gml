/// @description Creates a visual display radius
// You can write your code in this editor
if(position_meeting(mouse_x, mouse_y, self.id) && variable_struct_exists(entity_data, "range")) {
	entity_data.range.draw_range();
}
draw_self()