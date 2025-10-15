/// @description Move the bullet

//Check left, right, top, and bottom OOB, and delete if off screen to save space
if(x < DIST_OFF_SCREEN * -1 || x > room_width + DIST_OFF_SCREEN || y < DIST_OFF_SCREEN * -1 || y > room_height + DIST_OFF_SCREEN) {
	instance_destroy();
	exit;
}

//Check to see if bullet is hitting enemy (produce ordered list of enemies in between bullet's current position and next)
if(x >= 0 && x <= room_width && y >= 0 && y <= room_height) { //Only need to do boundary check if the bullet is actually in the room
	var _end_x = clamp(x + x_speed, 0, room_width);
	var _end_y = clamp(y + y_speed, 0, room_height);
	
	var _target_hit = collision_line(x, y, _end_x, _end_y, target, false, true);

	if(_target_hit) {
		//Damage an enemy that should get hit by the projectile
		heal_entity(target, data.healing_amount);
		
		//Destroy the bullet
		instance_destroy();
		exit;
	}
}

//Move the bullet
x += x_speed;
y += y_speed;