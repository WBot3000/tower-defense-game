/// @description Run events

event_inherited();

switch (health_state) {
    case HEALTH_STATE.ACTIVE:
		shot_timer++;
		if(shot_timer * stat_multipliers[STATS.ATTACK_SPEED] >= entity_data.frames_per_shot) {
			entity_data.sight_range.get_entities_in_range([base_enemy], entities_in_range);

			if(ds_list_size(entities_in_range) > 0) {
				//TODO: Check to see if targets are being picked correctly not sure if they are
				var _enemy_to_target = get_entities_using_targeting_tracker(entities_in_range, target_filter_fn_default);
				
				set_facing_direction( get_entity_facing_direction(self, _enemy_to_target.x) );
				shoot_projectile(projectile_obj, _enemy_to_target, entity_data.projectile_data);
				animation_controller.set_animation("SHOOT");
				
				shot_timer = 0;
				ds_list_clear(entities_in_range);
			}
		}
		
		if(upgrade_purchased == 3 && round_manager.is_spawning_enemies()) {
			splotch_creation_timer++;
			if(splotch_creation_timer > entity_data.frames_per_splotch) {
				entity_data.sight_range.get_entities_in_range([path_tile], entities_in_range);
				var len = ds_list_size(entities_in_range);
				if(len > 0) {
					var _tile_index = irandom(len - 1);
					var _tile = entities_in_range[| _tile_index]; 
					create_tile_aligned_instance(_tile.x, _tile.y, GROUND_INSTANCES_LAYER, mud_splotch, {});
					ds_list_clear(entities_in_range);
				}
				splotch_creation_timer = 0;
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