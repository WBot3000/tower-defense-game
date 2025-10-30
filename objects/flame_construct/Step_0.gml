/// @description Run events

event_inherited();

switch (health_state) {
    case HEALTH_STATE.ACTIVE:
		var _potential_targets = undefined;
		var _potential_targets_len = -1;
		var _current_potential_target_idx = 0;
		
		for (var i = 0, len = array_length(flamethrowers); i < len; ++i) {
		    var _flamethrower = flamethrowers[i];
			//Get new target if needed
			if(_flamethrower.target == noone || !instance_exists(_flamethrower.target) || !entity_data.sight_range.is_entity_in_range(_flamethrower.target)) {
				
				 if(_flamethrower.target != noone) {
					array_delete(current_targets, array_get_index(current_targets, _flamethrower.target), 1);
					_flamethrower.set_target(noone); //Can't reach the target anymore
				}
				
				
				if(_potential_targets == undefined) { //Only need to fetch this once
					entity_data.sight_range.get_entities_in_range([base_enemy], entities_in_range, true);
					//Need to return all entities, as we'll need to make sure the enemy isn't currently being targeted by another flamethrower at the moment
					_potential_targets = get_entities_using_targeting_tracker(entities_in_range, target_filter_fn_default, RETURN_ALL_ENTITIES);
					_potential_targets_len = array_length(_potential_targets);
				}
				
				
				if(_potential_targets_len > 0) { //TODO: Should multiple flamethrowers be able to double up? Right now excess flamethowers just aren't used
					
					while(_current_potential_target_idx < _potential_targets_len) {
						var _new_target = _potential_targets[_current_potential_target_idx];
						_current_potential_target_idx++;
						if(!array_contains(current_targets, _new_target)) {
							_flamethrower.set_target(_new_target);
							array_push(current_targets, _new_target);
							break; //Found a new target, don't need to do any more looping
						}
					}
					//TODO: Check to see if targets are being picked correctly not sure if they are
					//flamethrower_target = get_entities_using_targeting_tracker(entities_in_range, target_filter_fn_default);
					//flamethrower_effect.end_instance = flamethrower_target;
					//ds_list_clear(entities_in_range);
				}
			}
			
			if(_flamethrower.target != noone) {
				_flamethrower.damage_timer++;
				_flamethrower.particle_effect.on_step();
				
				if(_flamethrower.damage_timer * stat_multipliers[STATS.ATTACK_SPEED] >= entity_data.frames_per_damage) {
					var _light_on_fire = random(20); //Generates a number from 0-20. Should lead to a 5% chance to inflict burn
					if(_light_on_fire <= 1) { //1/20 chance if I did the math right
						_flamethrower.target.buffs.apply_buff(BUFF_IDS.ON_FIRE, [seconds_to_roomspeed_frames(5)]); //Add 5 seconds of burn
						deal_damage(_flamethrower.target, entity_data.damage);
						_flamethrower.damage_timer = 0;
					}
				}	
			}
			
		}
		
		ds_list_clear(entities_in_range);
		
		if(array_length(current_targets) > 0) { //TODO: Find a way that doesn't run this every step
			set_facing_direction( get_entity_facing_direction(self, current_targets[0].x) );
		}
	
	/*
		//Get new target if needed
		if(!instance_exists(flamethrower_target) || !entity_data.sight_range.is_entity_in_range(flamethrower_target)) {
			entity_data.sight_range.get_entities_in_range([base_enemy], entities_in_range, true);
			if(ds_list_size(entities_in_range) > 0) {
				//TODO: Check to see if targets are being picked correctly not sure if they are
				flamethrower_target = get_entities_using_targeting_tracker(entities_in_range, target_filter_fn_default);
				flamethrower_effect.end_instance = flamethrower_target;
				ds_list_clear(entities_in_range);
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
			}
			set_facing_direction( get_entity_facing_direction(self, flamethrower_target.x) );
			deal_damage(flamethrower_target, entity_data.damage);
			flamethrower_damage_timer = 0;
		}
		*/
		
		if(current_health <= 0) {
			standard_on_ko_actions();
			flamethrower_damage_timer = 0;
		}
		
        break;
	case HEALTH_STATE.KNOCKED_OUT:
		standard_recover_from_ko_actions();
		break;
    default:
        break;
}