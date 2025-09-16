/// @description Move along the path and occasionally bite a unit

event_inherited();

//Check to see if the enemy needs to be destroyed
if(current_health <= 0) {
	standard_on_enemy_defeat_actions();
	exit; 
	/*
		NOTE: Whenever an instance is destroyed and data structures need to be cleaned up, you need to exit the Step event right after.
		This is because, if you don't, the Destroy/Clean-Up event will be called immediately, and then the Step event will CONTINUE, now with an invalid reference to a data structure.
	*/
}


attack_timer++;
if(current_health + current_health <= entity_data.max_health) { //Only spawn worm holes once half-health or under.
	wormhole_timer++;
}

switch (health_state) {
	case HEALTH_STATE.ACTIVE:	
		if(wormhole_timer >= entity_data.frames_per_wormhole_summon) {
			//Look at Path Notes for more information on this calculation
			var _wormhole_path_position = min((path_position * path_get_length(path_index) + 128) / path_get_length(path_index), 1);
			var _wormhole_x = path_get_x(path_index, _wormhole_path_position) + path_data.spawn_x;
			//Because paths run along the bottom of tiles (to align with enemy sprite origins), to get the ACTUAL tile, we have to check a little bit above, otherwise it'll get the tile below instead
			var _wormhole_y = path_get_y(path_index, _wormhole_path_position) + path_data.spawn_y - 1;
			create_tile_aligned_instance(_wormhole_x, _wormhole_y, GROUND_INSTANCES_LAYER, wormhole, 
			{
				enemy_path_data: other.path_data,
				path_starting_percentage: _wormhole_path_position,
				round_spawned_in: other.round_spawned_in,
			});
			wormhole_timer = 0;
		}
		
		if(attack_timer >= entity_data.frames_per_attack) { //Enemy can now attack again
			//Prioritize units over targets (they'll be at the front of the list
			//Temporary for now
			entity_data.sight_range.get_entities_in_range(base_unit, units_in_range);
			entity_data.sight_range.get_entities_in_range(base_target, targets_in_range);
			for(var i = 0; i < ds_list_size(targets_in_range); ++i) {
				ds_list_add(units_in_range, ds_list_find_value(targets_in_range, i));
			}
			var _entity_to_attack = enemy_target_default(self, units_in_range);
			if(_entity_to_attack != noone) {
				deal_damage(_entity_to_attack, entity_data.attack_damage);
				draw_damage_effect(_entity_to_attack, spr_bite);
				
				attack_timer = 0;
			}
			ds_list_clear(units_in_range);
			ds_list_clear(targets_in_range);
		}
		break;
	case HEALTH_STATE.KNOCKED_OUT:
		break;
	default:
		break;
}