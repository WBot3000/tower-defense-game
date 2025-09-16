/// @description Move along the path and occasionally bite a unit

event_inherited();

//Check to see if the enemy needs to be destroyed
if(current_health <= 0) {
	instance_destroy();
	exit; 
	/*
		NOTE: Whenever an instance is destroyed and data structures need to be cleaned up, you need to exit the Step event right after.
		This is because, if you don't, the Destroy/Clean-Up event will be called immediately, and then the Step event will CONTINUE, now with an invalid reference to a data structure.
	*/
}

//Increment state timer
state_timer++;

switch (attack_state) {
	case ENEMY_ATTACKING_STATE.NOT_ATTACKING:
		if(state_timer >= entity_data.frames_per_attack) { //Enemy can now attack again
			//Prioritize units over targets (they'll be at the front of the list
			entity_data.sight_range.get_entities_in_range([base_unit, base_target], entities_in_range);
			focused_entity = enemy_target_default(self, entities_in_range);

			if(focused_entity != noone) {
				path_speed = 0;
				
				shoot_projectile(gun_beetle_bullet, focused_entity, entity_data.projectile_data);
				
				state_timer = 0;
				attack_state = ENEMY_ATTACKING_STATE.IN_ATTACK;
			}
			ds_list_clear(entities_in_range);
		}
		break;
	case ENEMY_ATTACKING_STATE.IN_ATTACK:
		if(state_timer >= entity_data.frames_per_attack) {
			if(can_be_attacked(focused_entity)) {
				shoot_projectile(gun_beetle_bullet, focused_entity, entity_data.projectile_data);
				state_timer = 0;
			}
			else { //Largely the same as the not-attacking code
				//Prioritize units over targets (they'll be at the front of the list
				entity_data.sight_range.get_entities_in_range([base_unit, base_target], entities_in_range);
				focused_entity = enemy_target_default(self, entities_in_range);
				
				if(focused_entity != noone) {
					shoot_projectile(gun_beetle_bullet, focused_entity, entity_data.projectile_data);
					state_timer = 0;
				}
				else {
					path_speed = entity_data.default_movement_speed;
					attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;
				}
				ds_list_clear(entities_in_range);
			}
		}
		break;
	default:
		break;
}