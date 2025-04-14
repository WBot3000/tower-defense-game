/// @description Move along the path and occasionally bite a unit
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
		range.move_range(get_bbox_center_x(self.id), get_bbox_center_y(self.id)); //If the enemy is in the attacking state, it's not moving, so you only need to update it here
		if(state_timer >= frames_per_attack) { //Enemy can now attack again
			//Prioritize units over targets (they'll be at the front of the list
			range.get_entities_in_range(base_unit, units_in_range, true);
			range.get_entities_in_range(base_target, targets_in_range, true);
			var _entity_to_attack = enemy_target_close(units_in_range, targets_in_range);

			if(_entity_to_attack != noone) {
				path_speed = 0;
				deal_damage(_entity_to_attack, melee_damage);
				draw_damage_effect(_entity_to_attack, spr_bite);
				
				state_timer = 0;
				attack_state = ENEMY_ATTACKING_STATE.IN_ATTACK;
			}
			ds_list_clear(units_in_range);
			ds_list_clear(targets_in_range);
		}
		break;
	case ENEMY_ATTACKING_STATE.IN_ATTACK:
		if(state_timer >= num_frames_paused) {
			path_speed = default_movement_speed;
			attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;
			state_timer = 0;
		}
		break;
	default:
		break;
}