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

//Check to see if the unit you're targeting... 
	//stops existing
	//is a target when units exist
	//is knocked out
if(!instance_exists(focused_entity) || 
	(object_is_ancestor(focused_entity.object_index, base_target) && instance_number(base_unit) > 0) ||
	(object_is_ancestor(focused_entity.object_index, base_unit) && focused_entity.health_state == UNIT_STATE.KNOCKED_OUT)) {
	attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING
	move_x = 0;
	move_y = 0;
	var _next_entity_to_target = noone;//instance_nearest((bbox_left + bbox_right)/2, (bbox_top + bbox_bottom)/2, base_unit);
	var _min_vector_not_current = undefined;
	with(base_unit) { //Iterate through all units, and find the closest one that's currently active
		if(health_state != UNIT_STATE.KNOCKED_OUT) {
			var _vector = instances_vector_to_get_components(other, self, true);
			if(_min_vector_not_current == undefined || _vector[VEC_LEN] < _min_vector_not_current[VEC_LEN]) {
				_next_entity_to_target = self;
				_min_vector_not_current = _vector;
			}
		}
	}
	
	//If there are no valid units, attack a target
	if(_next_entity_to_target == noone) {
		_next_entity_to_target = instance_nearest(x, y, base_target);
	}
	
	if(_next_entity_to_target != noone) {
		move_x = _min_vector_not_current[VEC_X];
		move_y = _min_vector_not_current[VEC_Y]
	}
	
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
		break;
	case ENEMY_ATTACKING_STATE.IN_ATTACK:
		if(state_timer >= frames_per_attack) {
			if(can_be_attacked(_entity_to_be_attacked)) { //Attack unit if valid attack target
				deal_damage(focused_entity, melee_damage);
				//draw_damage_effect(focused_entity, spr_slash);
				state_timer = 0;
			}
		}
		break;
	default:
		break;
}