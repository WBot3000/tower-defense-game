/// @description Move the cloud

switch (state) {
    case CLOUD_STATE.TRAVELING_TO_TARGET: //TODO: Needs to do something if the target is destroyed before being reached (choose another target or just stick with going the same direction?
        var _vector = vector_to_get_components(x, y, target.x, target.y - TILE_SIZE, true);
		x += _vector[VEC_X]*cloud_speed;
		y += _vector[VEC_Y]*cloud_speed;
		if(x == target.x && y == target.y - TILE_SIZE) {
			state = CLOUD_STATE.LINGERING;
		}
        break;
	case CLOUD_STATE.LINGERING:
        // code here
        break;
	case CLOUD_STATE.DISSIPATING:
        // code here
        break;
    default:
        break;
}

/*
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
		for(var i = 0; i < ds_list_size(enemies_in_range); i++) {
			deal_damage(enemies_in_range[| i], bullet_damage);
		}
		
		//Destroy the bullet
		instance_destroy()
		exit;
	}
}

//Move the bullet
x += x_speed;
y += y_speed;*/