/// @description Insert description here

event_inherited();

switch (health_state) {
    case HEALTH_STATE.ACTIVE:
		if(cached_round_manager.is_spawning_enemies()) {
			health_restoration_timer++;
			if(health_restoration_timer >= entity_data.frames_per_restoration) {
				entity_data.sight_range.get_entities_in_range([base_unit], entities_in_range);
				for(var i = 0, len = ds_list_size(entities_in_range); i < len; ++i) {
					heal_entity(entities_in_range[| i], entity_data.healing_amount);
				}
				health_restoration_timer = 0;
				ds_list_clear(entities_in_range);
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