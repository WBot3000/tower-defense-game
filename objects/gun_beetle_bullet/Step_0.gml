/// @description Move the bullet

//Check left, right, top, and bottom OOB, and delete if off screen to save space
if(x < DIST_OFF_SCREEN * -1 || x > room_width + DIST_OFF_SCREEN || y < DIST_OFF_SCREEN * -1 || y > room_height + DIST_OFF_SCREEN) {
	instance_destroy();
	exit;
}

//Check to see if bullet is hitting unit (produce ordered list of unit in between bullet's current position and next)
if(x >= 0 && x <= room_width && y >= 0 && y <= room_height) { //Only need to do boundary check if the bullet is actually in the room
	var _end_x = clamp(x + x_speed, 0, room_width)
	var _end_y = clamp(y + y_speed, 0, room_height)
	collision_line_list(x, y, _end_x, _end_y, base_unit, false, true, units_in_range, true);

	if(ds_list_size(units_in_range) > 0) {
		var _units_to_hit = units_in_range[| 0]; //First unit in the array will always be the closest due to ordered being true above
		deal_damage(_units_to_hit, bullet_damage);
		//Destroy the bullet
		instance_destroy()
		exit;
	}
}

//Move the bullet
x += x_speed;
y += y_speed;