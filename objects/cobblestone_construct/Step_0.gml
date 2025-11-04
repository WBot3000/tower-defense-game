/// @description Run events

event_inherited();

switch (health_state) {
    case HEALTH_STATE.ACTIVE:
		punch_timer++;
		if(punch_timer * stat_multipliers[STATS.ATTACK_SPEED] >= entity_data.frames_per_punch) {
			entity_data.sight_range.get_entities_in_range([base_enemy], entities_in_range);

			if(ds_list_size(entities_in_range) > 0) {
				var _enemy_to_target = get_entities_using_targeting_tracker(entities_in_range, target_filter_fn_default);
				
				set_facing_direction( get_entity_facing_direction(self, _enemy_to_target.x) );
				deal_damage(_enemy_to_target, entity_data.punch_damage);
				
				//animation_controller.set_animation("ATTACK");
				draw_damage_effect(_enemy_to_target, spr_punch);
				
				punch_timer = 0;
				punch_counter++;
				if(punch_counter >= 5) {
					if(upgrade_purchased == 1) {
						for(var i = 0, len = ds_list_size(entities_in_range); i < len; ++i) {
							var _enemy = entities_in_range[| i];
							with(_enemy) {
								movement_controller.add_knockback(seconds_to_roomspeed_frames(1));
							}
						}
						part_particles_create(global.PARTICLE_SYSTEM, x, y - TILE_SIZE/2, global.PARTICLE_QUAKE, 1);
					}
					punch_counter = 0;
				}
				ds_list_clear(entities_in_range);
			}
		}
		
		if(current_health <= 0) {
			standard_on_ko_actions();
			//release_enemies_from_block();
			broadcast_hub.broadcast_event(EVENT_END_BLOCK, [self]);
			punch_timer = 0;
		}
		
        break;
	case HEALTH_STATE.KNOCKED_OUT:
		standard_recover_from_ko_actions();
		break;
    default:
        break;
}