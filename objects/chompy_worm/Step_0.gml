/// @description Move along the path and occasionally bite a unit

switch (health_state) {
	case HEALTH_STATE.ACTIVE:
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
		if(attack_timer >= entity_data.frames_per_attack) { //Enemy can now attack again
			
			entity_data.sight_range.get_entities_in_range([base_unit, base_target], entities_in_range, true);
			
			if(ds_list_size(entities_in_range) > 0) {
				var _entity_to_attack = enemy_target_default(self, entities_in_range);
				if(_entity_to_attack != noone) {
					deal_damage(_entity_to_attack, entity_data.attack_damage);
					draw_damage_effect(_entity_to_attack, spr_bite);
					attack_timer = 0;
				}
				ds_list_clear(entities_in_range);
			}
			
		}
		break;
	case HEALTH_STATE.KNOCKED_OUT:
		break;
	default:
		break;
}