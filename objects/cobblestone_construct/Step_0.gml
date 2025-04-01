/// @description Look for enemies, and then punch them

switch (health_state) {
    case UNIT_STATE.ACTIVE:
		punch_timer++;
		if(punch_timer >= frames_per_punch) {
			range.get_entities_in_range(base_enemy, enemies_in_range, true);
			
			if(ds_list_size(enemies_in_range) > 0) {
				var _targeting_type = targeting_tracker.get_current_targeting_type();
				var _enemy_to_target = _targeting_type.targeting_fn(self.id, enemies_in_range, true);
				deal_damage(_enemy_to_target, punch_damage);
				draw_damage_effect(_enemy_to_target, spr_punch);
				punch_timer = 0;
				ds_list_clear(enemies_in_range);
			}
		}
		
		if(current_health <= 0) {
			health_state = UNIT_STATE.KNOCKED_OUT;
			punch_timer = 0;
		}
		
        break;
	case UNIT_STATE.KNOCKED_OUT:
		var _amount_to_recover = recovery_rate / seconds_to_roomspeed_frames(1);
		current_health = min(max_health, current_health + _amount_to_recover);
		if(current_health >= max_health) {
			health_state = UNIT_STATE.ACTIVE; 
		}
		break;
    default:
        break;
}