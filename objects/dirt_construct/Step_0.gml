/// @description Look for enemy, then fire (or recover health if knocked out)

animation_controller.on_step();

switch (health_state) {
    case UNIT_STATE.ACTIVE:
		shot_timer++;
		if(shot_timer >= frames_per_shot) {
			range.get_entities_in_range(base_enemy, enemies_in_range, true);
			
			if(ds_list_size(enemies_in_range) > 0) {
				var _targeting_type = targeting_tracker.get_current_targeting_type();
				var _enemy_to_target = _targeting_type.targeting_fn(self.id, enemies_in_range, true);
				//TODO: Right now, the vector is from the center of the unit to the center of the enemy unit. Will probably want to adjust these positions based on the enemy's position compared to the unit's
				var _vector = instances_vector_to_get_components(self, _enemy_to_target, true);
	
				direction_facing = get_entity_facing_direction(self, _enemy_to_target.x);
				image_xscale = direction_facing; //Seperate variables for now just in case I want to do other things with direction_facing
				
				animation_controller.set_animation("SHOOT");
				instance_create_layer((self.bbox_left + self.bbox_right)/2, (self.bbox_top + self.bbox_bottom)/2, PROJECTILE_LAYER, dirt_ball,
					{
						x_speed: _vector[VEC_X] * other.shot_speed,
						y_speed: _vector[VEC_Y] * other.shot_speed,
						bullet_damage: other.shot_damage
					});
					
				shot_timer = 0;
				ds_list_clear(enemies_in_range);
			}
		}
		
		if(current_health <= 0) {
			animation_controller.set_animation("ON_KO"); //TODO: Write code for chaining animations together
			health_state = UNIT_STATE.KNOCKED_OUT;
			shot_timer = 0;
		}
		
        break;
	case UNIT_STATE.KNOCKED_OUT:
		var _amount_to_recover = recovery_rate / seconds_to_roomspeed_frames(1);
		current_health = min(max_health, current_health + _amount_to_recover);
		if(current_health >= max_health) {
			animation_controller.set_animation("ON_RESTORE");
			health_state = UNIT_STATE.ACTIVE; 
		}
		break;
    default:
        break;
}