/// @description Run events

event_inherited();

switch (health_state) {
    case HEALTH_STATE.ACTIVE:
		
		//Get new target if needed
		if(!instance_exists(flamethrower_target) || !entity_data.sight_range.is_entity_in_range(flamethrower_target)) {
			entity_data.sight_range.get_entities_in_range([base_enemy], enemies_in_range, true);
			if(ds_list_size(enemies_in_range) > 0) {
				//TODO: Check to see if targets are being picked correctly not sure if they are
				flamethrower_target = get_entity_using_targeting_tracker(enemies_in_range, global.DEFAULT_TARGETING_PARAMETERS);
				flamethrower_effect.end_instance = flamethrower_target;
				ds_list_clear(enemies_in_range);
			}
			else {
				flamethrower_target = noone;
				flamethrower_effect.end_instance = noone;
			}
		}
		
		if(flamethrower_target != noone && flamethrower_damage_timer * stat_multipliers[STATS.ATTACK_SPEED] >= entity_data.frames_per_damage) {
			var _light_on_fire = random(20); //Generates a number from 0-20. Should lead to a 5% chance to inflict burn
			if(_light_on_fire <= 1) { //1/20 chance if I did the math right
				flamethrower_target.buffs.apply_buff(BUFF_IDS.ON_FIRE, [seconds_to_roomspeed_frames(5)]); //Add 5 seconds of burn
				show_debug_message("Hit");
			}
			set_facing_direction( get_entity_facing_direction(self, flamethrower_target.x) );
			deal_damage(flamethrower_target, entity_data.damage);
			flamethrower_damage_timer = 0;
		}
		
		if(current_health <= 0) {
			standard_on_ko_actions();
			flamethrower_damage_timer = 0;
		}
		
		flamethrower_damage_timer++;
		flamethrower_effect.on_step();
		
        break;
	case HEALTH_STATE.KNOCKED_OUT:
		standard_recover_from_ko_actions();
		break;
    default:
        break;
}