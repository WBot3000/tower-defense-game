/// @description Look for enemy, then fire (or recover health if knocked out)

switch (health_state) {
    case UNIT_STATE.ACTIVE:
        // code here
		shot_timer++;
		if(shot_timer >= frames_per_shot) {
			range.get_entities_in_range(base_enemy, enemies_in_range, true);
			
			if(ds_list_size(enemies_in_range) > 0) {
				var _targeting_type = targeting_tracker.get_current_targeting_type();
				var _enemy_to_target = _targeting_type.targeting_fn(self.id, enemies_in_range, true);
				//TODO: Right now, the vector is from the center of the unit to the center of the enemy unit. Will probably want to adjust these positions based on the enemy's position compared to the unit's
				var _vector_x = (_enemy_to_target.bbox_left + _enemy_to_target.bbox_right)/2 - (self.bbox_left + self.bbox_right)/2;
				var _vector_y = (_enemy_to_target.bbox_top + _enemy_to_target.bbox_bottom)/2 - (self.bbox_top + self.bbox_bottom)/2;
				var _vector_len = sqrt(sqr(_vector_x) + sqr(_vector_y));
	
				_vector_x = _vector_x / _vector_len;
				_vector_y = _vector_y / _vector_len;
	
				instance_create_layer((self.bbox_left + self.bbox_right)/2, (self.bbox_top + self.bbox_bottom)/2, PROJECTILE_LAYER, dirt_ball,
					{
						x_speed: _vector_x * other.shot_speed,
						y_speed: _vector_y * other.shot_speed,
						bullet_damage: other.shot_damage
					});
					
				shot_timer = 0;
				ds_list_clear(enemies_in_range);
			}
		}
		
		if(current_health <= 0) {
			health_state = UNIT_STATE.KNOCKED_OUT;
			shot_timer = 0;
		}
		
        break;
	case UNIT_STATE.KNOCKED_OUT:
		//code here
		var _amount_to_recover = recovery_rate / seconds_to_roomspeed_frames(1);
		current_health = min(max_health, current_health + _amount_to_recover);
		if(current_health >= max_health) {
			//animation_controller.set_animation(spr_sample_gunner, LOOP_FOREVER);
			health_state = UNIT_STATE.ACTIVE; 
		}
		break;
    default:
        break;
}