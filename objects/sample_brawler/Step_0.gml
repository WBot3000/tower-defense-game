/// @description Look for enemies, and then punch them
//Manage animation state

//Handle animation playing
animation_controller.on_step();

//Increment punch timer
var _frames_per_punch = seconds_to_roomspeed_frames(seconds_per_punch)
punch_timer = min(punch_timer + 1, _frames_per_punch); //Done to prevent overflow

//NOTE: This doesn't do animation control yet because I haven't made all the sprites for the different directions
if(health_state == UNIT_STATE.KNOCKED_OUT) {
	var _amount_to_recover = recovery_rate / seconds_to_roomspeed_frames(1);
	current_health = min(max_health, current_health + _amount_to_recover);
	if(current_health >= max_health) {
		//animation_controller.set_animation(spr_sample_gunner, LOOP_FOREVER);
		health_state = UNIT_STATE.ACTIVE; 
	}
	else { //If the unit can come back this frame, let them take action (why this is in an else)
		exit; 
	}
}

if(current_health <= 0) { //If unit's health drops below zero, then it should get knocked out
	//animation_controller.set_animation(spr_sample_gunner_ko, LOOP_FOREVER);
	health_state = UNIT_STATE.KNOCKED_OUT;
	exit;
}

range.get_entities_in_range(base_enemy, enemies_in_range, true);

if(punch_timer >= _frames_per_punch && ds_list_size(enemies_in_range) > 0) { //More than seconds_per_shot have ellapsed since last punch, so you can punch again
	var _enemy_to_target = target_close(self.id, enemies_in_range, true); //This will probably just punch the closest enemy no matter what
	
	//Determine what direction the punch should be in based on where the enemy is in relation to the unit
	var _vector_x = (_enemy_to_target.x + _enemy_to_target.sprite_width/2) - (x + sprite_width/2);
	var _vector_y = (_enemy_to_target.y + _enemy_to_target.sprite_height/2) - (y + sprite_height/2);

	var _x_dir = _vector_x > 0 ? DIRECTION_RIGHT : DIRECTION_LEFT;
	//var _y_dir = _vector_y >= 0 ? DIRECTION.DOWN : DIRECTION.UP;
	//show_debug_message(_vector_x);
	//show_debug_message(_vector_y);
	//NOTE: > used for _x_dir, since I wanted facing left to be the "default" direction. Same reasoning for >= with _y_dir. This isn't an error.
	
	//If the enemy is further in the y-direction, face up or down. If the enemy is further in the x-direction, face left or right.
	//var _dir = abs(_vector_y) > abs(_vector_x) ? _y_dir : _x_dir
	

	switch (_x_dir) {
	    case DIRECTION_LEFT:
			animation_controller.set_animation(spr_sample_brawler_left_punch, 1, spr_sample_brawler_left);
	        break;
		case DIRECTION_RIGHT:
			animation_controller.set_animation(spr_sample_brawler_right_punch, 1, spr_sample_brawler_right);
	        break;
		/*
		case DIRECTION.UP:
			animation_controller.set_animation(spr_sample_brawler_up_punch, 1, spr_sample_brawler_up);
	        break;
		case DIRECTION.DOWN: //Same as default. Technically don't need this statement, but keeping it for clarity.*/
	    default:
			animation_controller.set_animation(spr_sample_brawler_down_punch, 1, spr_sample_brawler_down);
	        break;
	}
	curr_direction = _dir;
	
	deal_damage(_enemy_to_target, punch_damage);
	/*
	with(_enemy_to_target) {
		current_health -= other.punch_damage;
	}*/
	
	punch_timer = 0;
}

ds_list_clear(enemies_in_range)