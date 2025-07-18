/// @description Move the bullet

//Check left, right, top, and bottom OOB, and delete if off screen to save space
if(x < DIST_OFF_SCREEN * -1 || x > room_width + DIST_OFF_SCREEN || y < DIST_OFF_SCREEN * -1 || y > room_height + DIST_OFF_SCREEN) {
	instance_destroy();
	exit;
}

//Check to see if bullet is hitting enemy (produce ordered list of enemies in between bullet's current position and next)
if(x >= 0 && x <= room_width && y >= 0 && y <= room_height) { //Only need to do boundary check if the bullet is actually in the room
	var _end_x = clamp(x + x_speed, 0, room_width)
	var _end_y = clamp(y + y_speed, 0, room_height)
	collision_line_list(x, y, _end_x, _end_y, base_enemy, false, true, enemies_in_range, true);

	if(ds_list_size(enemies_in_range) > 0) {
		//Damage all enemies that should get hit by the projectile
		for(var i = 0; (i < ds_list_size(enemies_in_range)) && (array_length(enemies_already_hit) < data.pierce); i++) {
			var _enemy = enemies_in_range[| i];
			if(!array_contains(enemies_already_hit, _enemy.id)) {
				deal_damage(enemies_in_range[| i], data.damage);
				array_push(enemies_already_hit, _enemy.id)
			}
		}
	}
	
	if(array_length(enemies_already_hit) >= data.pierce) {
		//Destroy the bullet
		instance_destroy()
		exit;
	}
}

//Move the bullet
x += x_speed;
y += y_speed;

ds_list_clear(enemies_in_range);