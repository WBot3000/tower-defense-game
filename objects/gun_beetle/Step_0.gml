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
			focused_entity = enemy_target_default(units_in_range, targets_in_range);

			if(focused_entity != noone) {
				path_speed = 0;
				
				var _vector = instances_vector_to_get_components(self, focused_entity, true);
				direction_facing = get_entity_facing_direction(self, focused_entity.x)
				image_xscale = direction_facing;
	
				instance_create_layer((self.bbox_left + self.bbox_right)/2, (self.bbox_top + self.bbox_bottom)/2, PROJECTILE_LAYER, gun_beetle_bullet,
					{
						x_speed: _vector[VEC_X] * other.shot_speed,
						y_speed: _vector[VEC_Y] * other.shot_speed,
						bullet_damage: other.shot_damage,
						image_xscale: other.direction_facing,
					});
				
				state_timer = 0;
				attack_state = ENEMY_ATTACKING_STATE.IN_ATTACK;
			}
			ds_list_clear(units_in_range);
			ds_list_clear(targets_in_range);
		}
		break;
	case ENEMY_ATTACKING_STATE.IN_ATTACK:
		if(state_timer >= frames_per_attack) {
			if(can_be_attacked(focused_entity)) {
				var _vector_x = (focused_entity.bbox_left + focused_entity.bbox_right)/2 - (self.bbox_left + self.bbox_right)/2;
				var _vector_y = (focused_entity.bbox_top + focused_entity.bbox_bottom)/2 - (self.bbox_top + self.bbox_bottom)/2;
				var _vector_len = sqrt(sqr(_vector_x) + sqr(_vector_y));
	
				_vector_x = _vector_x / _vector_len;
				_vector_y = _vector_y / _vector_len;
	
				instance_create_layer((self.bbox_left + self.bbox_right)/2, (self.bbox_top + self.bbox_bottom)/2, PROJECTILE_LAYER, gun_beetle_bullet,
					{
						x_speed: _vector_x * other.shot_speed,
						y_speed: _vector_y * other.shot_speed,
						bullet_damage: other.shot_damage
					});
				state_timer = 0;
			}
			else { //Largely the same as the not-attacking code
				//Prioritize units over targets (they'll be at the front of the list
				range.get_entities_in_range(base_unit, units_in_range, true);
				range.get_entities_in_range(base_target, targets_in_range, true);
				focused_entity = enemy_target_default(units_in_range, targets_in_range);
				
				if(focused_entity != noone) {
					var _vector_x = (focused_entity.bbox_left + focused_entity.bbox_right)/2 - (self.bbox_left + self.bbox_right)/2;
					var _vector_y = (focused_entity.bbox_top + focused_entity.bbox_bottom)/2 - (self.bbox_top + self.bbox_bottom)/2;
					var _vector_len = sqrt(sqr(_vector_x) + sqr(_vector_y));
	
					_vector_x = _vector_x / _vector_len;
					_vector_y = _vector_y / _vector_len;
	
					instance_create_layer((self.bbox_left + self.bbox_right)/2, (self.bbox_top + self.bbox_bottom)/2, PROJECTILE_LAYER, gun_beetle_bullet,
						{
							x_speed: _vector_x * other.shot_speed,
							y_speed: _vector_y * other.shot_speed,
							bullet_damage: other.shot_damage
						});
					state_timer = 0;
				}
				else {
					path_speed = default_movement_speed;
					attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;
				}
				ds_list_clear(units_in_range);
				ds_list_clear(targets_in_range);
			}
		}
		break;
	default:
		break;
}