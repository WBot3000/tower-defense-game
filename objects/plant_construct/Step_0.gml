/// @description Insert description here

event_inherited();

switch (health_state) {
    case HEALTH_STATE.ACTIVE:
		if(cached_round_manager.is_spawning_enemies()) { //TODO: Lots of if-nesting. Maybe this can be reduced.
			health_restoration_timer++;
			if(health_restoration_timer >= entity_data.frames_per_restoration) {
				entity_data.sight_range.get_entities_in_range([base_unit], entities_in_range);
				
				part_particles_create(global.PARTICLE_SYSTEM, x,  y - TILE_SIZE/2,
					global.PARTICLE_HEALING_AURA, 1);
					
				for(var i = 0, len = ds_list_size(entities_in_range); i < len; ++i) {
					heal_entity(entities_in_range[| i], entity_data.healing_amount);
				}
				health_restoration_timer = 0;
				ds_list_clear(entities_in_range);
				
				if(upgrade_purchased == 1) {// Shoot projectiles for upgrade 1
					entity_data.global_range.get_entities_in_range([base_unit], entities_in_range);
					var _entities_for_healing_projectiles = get_entities_using_targeting_tracker(entities_in_range, global.DEFAULT_TARGETING_PARAMETERS, entity_data.num_projectiles);
					show_debug_message(_entities_for_healing_projectiles);
					if(_entities_for_healing_projectiles[0] != noone) {
						var _projectiles_created = 0;
						var i = 0;
						while(_projectiles_created < entity_data.num_projectiles) {
							var _entity = _entities_for_healing_projectiles[i];
							show_debug_message(_entity);
							if(_entity == noone) {
								_entity = _entities_for_healing_projectiles[0];
								i = 0;
							}
							shoot_projectile(healing_projectile, _entity, entity_data.projectile_data);
							i++;
							_projectiles_created++;
						}
					}
					ds_list_clear(entities_in_range);
				}
				
			}
		}
		
		if(current_health <= 0) {
			standard_on_ko_actions();
			health_restoration_timer = 0;
		}
		
        break;
	case HEALTH_STATE.KNOCKED_OUT:
		standard_recover_from_ko_actions();
		break;
    default:
        break;
}