/// @description Creates a visual display radius
// You can write your code in this editor
if(position_meeting(mouse_x, mouse_y, self.id) && variable_instance_exists(self.id, "range")) {
	range.draw_range();
}
draw_self()