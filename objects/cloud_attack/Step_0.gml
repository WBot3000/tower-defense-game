/// @description Move the cloud

switch (state) {
    case CLOUD_STATE.TRAVELING_TO_TARGET:
        //If the original target no longer exists, pick a new one based on the summoner's current targeting
		if(!instance_exists(target)) {
			var _targeting_type = global.TARGETING_CLOSE; //In the event the owner was sold, need a fallback option
			if(instance_exists(owner)) {
				_targeting_type = owner.targeting_tracker.get_current_targeting_type();
			}
			target = _targeting_type.targeting_fn(self.id, global.ALL_ENEMIES_LIST, true);
			if(target == noone) { //If no enemies can be found, just dissipate. TODO: Might change this behavior later
				state = CLOUD_STATE.DISSIPATING
				break;
			}
			ds_list_clear(enemies_in_range);
		}
		var _vector = vector_to_get_components(x, y, target.x, target.y - TILE_SIZE, true);
		x += _vector[VEC_X]*cloud_speed;
		y += _vector[VEC_Y]*cloud_speed;
		if(abs(x - target.x) <= cloud_speed) { //Handle precision errors
			x = target.x;
		}
		if(abs(y - (target.y - TILE_SIZE)) <= cloud_speed) {
			y = target.y - TILE_SIZE;
		}
		if(x == target.x && y == target.y - TILE_SIZE) {
			state = CLOUD_STATE.LINGERING;
		}
        break;
	case CLOUD_STATE.LINGERING:
        if(!instance_exists(target)) {
			var _targeting_type = global.TARGETING_CLOSE; //In the event the owner was sold, need a fallback option
			if(instance_exists(owner)) {
				_targeting_type = owner.targeting_tracker.get_current_targeting_type();
			}
			range.get_entities_in_range(base_enemy, enemies_in_range, true);
			target = _targeting_type.targeting_fn(self.id, enemies_in_range, true);
			if(target == noone) { //If no enemies can be found, just dissipate. TODO: Might change this behavior later
				state = CLOUD_STATE.DISSIPATING;
				
			}
			else {
				state = CLOUD_STATE.TRAVELING_TO_TARGET;
			}
			part_emitter_stream(global.PARTICLE_SYSTEM, rain_emitter, global.PARTICLE_RAIN, 0);
			ds_list_clear(enemies_in_range);
			break;
		}
		
		x = target.x;
		y = target.y - TILE_SIZE;
		part_emitter_region(global.PARTICLE_SYSTEM, rain_emitter, x - 8, x + 8, y + sprite_height, y + sprite_height, ps_shape_rectangle, ps_distr_linear);
		
		damage_timer++;
		if(damage_timer >= seconds_to_damage) {
			deal_damage(target, cloud_damage);
			part_emitter_stream(global.PARTICLE_SYSTEM, rain_emitter, global.PARTICLE_RAIN, 1);
			damage_timer = 0;
		}
		linger_timer++;
		if(linger_timer >= seconds_to_linger) {
			state = CLOUD_STATE.DISSIPATING;
		}
        break;
	case CLOUD_STATE.DISSIPATING:
        //TODO: Replace this with a dissipating animation
		instance_destroy();
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