/// @description Run actions

event_inherited();

switch (health_state) {
    case HEALTH_STATE.ACTIVE:
		cloud_timer++;
		if(cloud_timer * stat_multipliers[STATS.ATTACK_SPEED] >= entity_data.frames_per_cloud) {
			entity_data.sight_range.get_entities_in_range([base_enemy], enemies_in_range);
			
			if(ds_list_size(enemies_in_range) > 0) {
				var _enemy_to_target = get_entity_using_targeting_tracker(enemies_in_range, global.DEFAULT_TARGETING_PARAMETERS);
				
				set_facing_direction( get_entity_facing_direction(self, _enemy_to_target.x) );
				shoot_projectile(projectile_obj, _enemy_to_target, entity_data.projectile_data);
				animation_controller.set_animation("SHOOT");
					
				cloud_timer = 0;
				ds_list_clear(enemies_in_range);
			}
		}
		
		if(current_health <= 0) {
			standard_on_ko_actions();
			cloud_timer = 0;
		}
		
        break;
	case HEALTH_STATE.KNOCKED_OUT:
		standard_recover_from_ko_actions();
		break;
    default:
        break;
}