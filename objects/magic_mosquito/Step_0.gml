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

//Check to see if the unit you're targeting exists (or is knocked out), and if it doesn't, then go for another one.
if(!instance_exists(focused_entity) || focused_entity.health_state == UNIT_STATE.KNOCKED_OUT) {
	attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING
	move_x = 0;
	move_y = 0;
	var _next_entity_to_target = undefined;//instance_nearest((bbox_left + bbox_right)/2, (bbox_top + bbox_bottom)/2, base_unit);
	var _min_vector_not_current = undefined;
	with(base_unit) { //Iterate through all units, and find the closest one that's currently active
		if(health_state != UNIT_STATE.KNOCKED_OUT) {
			var _vector = vector_to_get_components(other, self, true);
			if(_min_vector_not_current == undefined || _vector[VEC_LEN] < _min_vector_not_current[VEC_LEN]) {
				_next_entity_to_target = self;
				_min_vector_not_current = _vector;
			}
		}
	}
	
	if(_next_entity_to_target != undefined) {
		move_x = _min_vector_not_current[VEC_X];
		move_y = _min_vector_not_current[VEC_Y]
	}
	
	//TODO: Currently does nothing with targets, should this be changed?
	//Probably, to prevent a softlock in the event the user can't afford any more units, but no other enemies are available to attack the target.
	//Could also do something where all Magic Mosquitos despawn after all other enemies are defeated, but too much work for now.
}

//Increment state timer
state_timer++;

switch (attack_state) {
	case ENEMY_ATTACKING_STATE.NOT_ATTACKING:
		image_xscale = get_entity_facing_direction(self, move_x);
		x += move_x;
		y += move_y;
		focused_entity = instance_place(x, y, base_unit);
		if(focused_entity != noone) {
			attack_state = ENEMY_ATTACKING_STATE.IN_ATTACK;
		}
		/*
		//range.move_range(x + sprite_width/2, y + sprite_height/2); //If the enemy is in the attacking state, it's not moving, so you only need to update it here
		if(state_timer >= frames_per_attack) { //Enemy can now attack again
			//Prioritize units over targets (they'll be at the front of the list
			range.get_entities_in_range(base_unit, units_in_range, true);
			range.get_entities_in_range(base_target, targets_in_range, true);
			focused_entity = enemy_target_close(units_in_range, targets_in_range);

			if(focused_entity != noone) {
				path_speed = 0;
				deal_damage(focused_entity, melee_damage);
				draw_damage_effect(focused_entity, spr_slash);
				
				state_timer = 0;
				attack_state = ENEMY_ATTACKING_STATE.IN_ATTACK;
			}
			ds_list_clear(units_in_range);
			ds_list_clear(targets_in_range);
		}
		*/
		break;
	case ENEMY_ATTACKING_STATE.IN_ATTACK:
		if(state_timer >= frames_per_attack) {
			if(instance_exists(focused_entity) && focused_entity.health_state == UNIT_STATE.ACTIVE) { //Attack unit if valid attack target
				deal_damage(focused_entity, melee_damage);
				//draw_damage_effect(focused_entity, spr_slash);
				state_timer = 0;
			}
		}/*
			else { //Largely the same as the not-attacking code
				//Prioritize units over targets (they'll be at the front of the list
				range.get_entities_in_range(base_unit, units_in_range, true);
				range.get_entities_in_range(base_target, targets_in_range, true);
				focused_entity = enemy_target_close(units_in_range, targets_in_range);

				if(focused_entity != noone) {
					deal_damage(focused_entity, melee_damage);
					draw_damage_effect(focused_entity, spr_slash);
				}
				else {
					path_speed = default_movement_speed;
					attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;
				}
				ds_list_clear(units_in_range);
				ds_list_clear(targets_in_range);
			}*/
		break;
	default:
		break;
}