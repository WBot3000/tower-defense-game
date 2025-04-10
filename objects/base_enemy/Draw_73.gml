/// @description Draw the enemy's health bar
// You can write your code in this editor
if(variable_instance_exists(self.id, "range")) {
	range.draw_range();
}
draw_health_bar(get_bbox_center_x(self.id), bbox_top, current_health, max_health)