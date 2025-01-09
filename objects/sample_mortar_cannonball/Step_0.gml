/// @description Move the bullet

/*
//Check left, right, top, and bottom OOB, and delete if off screen to save space
if(x < DIST_OFF_SCREEN * -1 || x > room_width + DIST_OFF_SCREEN || y < DIST_OFF_SCREEN * -1 || y > room_height + DIST_OFF_SCREEN) {
	instance_destroy()
}
*/

//Check to see if bullet is hitting enemy (produce ordered list of enemies in between bullet's current position and next)
if(x >= 0 && x <= room_width && y >= 0 && y <= room_height) { //Only need to do boundary check if the bullet is actually in the room
	var _end_x = clamp(x + x_speed, 0, room_width)
	var _end_y = clamp(y + y_speed, 0, room_height)
	
	if(number_is_between(x_target, x, _end_x) && number_is_between(y_target, y, _end_y)) {
		//Heavy mortar damage
		instance_place_list(x, y, base_enemy, enemies_in_range, false);
		for(var i = 0; i < ds_list_size(enemies_in_range); ++i) {
			deal_damage(enemies_in_range[| i], bullet_damage);
			/*
			with(enemies_in_range[| i]) {
				current_health -= other.bullet_damage;
			}*/
		}
		
		//Then generate the explosion
		//Current implementation is somewhat hacky, as it assumes both the explosion and the cannonball's size in tiles.
		//TODO: When you feel like thinking harder, come up with a method for calculating this that automatically changes with the cannonball and explosions' sizes
		instance_create_layer(x-(TILE_SIZE + 32), y-(TILE_SIZE + 32), PROJECTILE_LAYER, sample_mortar_explosion);
		instance_destroy();
		exit;
	}
}

//Move the bullet
x += x_speed;
y += y_speed;