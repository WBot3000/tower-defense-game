/// @description Run events

event_inherited();

switch (health_state) {
    case HEALTH_STATE.ACTIVE:
		shot_timer++;
		if(shot_timer * stat_multipliers[STATS.ATTACK_SPEED] >= entity_data.frames_per_shot) {
			entity_data.sight_range.get_entities_in_range([base_enemy], enemies_in_range);

			if(ds_list_size(enemies_in_range) > 0) {
				//TODO: Check to see if targets are being picked correctly not sure if they are
				var _enemy_to_target = get_entities_using_targeting_tracker(enemies_in_range, global.DEFAULT_TARGETING_PARAMETERS);
				
				set_facing_direction( get_entity_facing_direction(self, _enemy_to_target.x) );
				shoot_projectile(projectile_obj, _enemy_to_target, entity_data.projectile_data);
				animation_controller.set_animation("SHOOT");
				
				shot_timer = 0;
				ds_list_clear(enemies_in_range);
			}
		}
		
		if(current_health <= 0) {
			standard_on_ko_actions();
			shot_timer = 0;
		}
		
        break;
	case HEALTH_STATE.KNOCKED_OUT:
		standard_recover_from_ko_actions();
		break;
    default:
        break;
}