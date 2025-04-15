/// @description If the enemy has stopped moving, attack the wall. Also check to see if the enemy has been defeated

//Check to see if the enemy needs to be destroyed
if(current_health <= 0) {
	instance_destroy();
	exit; 
	/*
		NOTE: Whenever an instance is destroyed and data structures need to be cleaned up, you need to exit the Step event right after.
		This is because, if you don't, the Destroy/Clean-Up event will be called immediately, and then the Step event will CONTINUE, now with an invalid reference to a data structure.
	*/
}

//Increment punch timer
var _frames_per_attack = seconds_to_roomspeed_frames(seconds_per_attack)
attack_timer = min(attack_timer + 1, _frames_per_attack); //Done to prevent overflow

//path_speed = 0;

switch (attack_state) {
    case ENEMY_ATTACKING_STATE.IN_ATTACK:
        //If the instance you were previously targeting gets knocked out or stops existing, then you'll need to choose a new unit to target
		if(!instance_exists(unit_currently_attacking) || unit_currently_attacking.health_state == UNIT_STATE.KNOCKED_OUT) {
			unit_currently_attacking = noone; //Technically not necessary, but matches setting state below
			path_speed = seconds_to_roomspeed_frames(default_movement_speed); //TODO: Change this along with the Create Event path speed
			attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;
			exit;
		}
		//Otherwise, just attack whenever the counter has peaked
		if(attack_timer >= _frames_per_attack) {
			deal_damage(unit_currently_attacking, melee_damage);
			/*
			with(unit_currently_attacking) {
				current_health -= other.melee_damage;
			}*/
			attack_timer = 0;
		}
		
        break;
		
	case ENEMY_ATTACKING_STATE.NOT_ATTACKING:
    default:
		//Move range to current position (can do this here since in the attacking state the enemy doesn't move)
		range.move_range(x + sprite_width/2, y + sprite_height/2);
        range.get_entities_in_range(base_unit, units_in_range, true);
		//Because units don't disappear when their health goes to zero, we first need to make sure that the enemy is a state in which it can be attacked.
		for(var i = 0; i < ds_list_size(units_in_range); ++i) {
			var _target = units_in_range[| i];
			if(_target.health_state == UNIT_STATE.ACTIVE) {
				unit_currently_attacking = _target;
				show_debug_message("cat");
				path_speed = 0;
				attack_state = ENEMY_ATTACKING_STATE.IN_ATTACK;
				ds_list_clear(units_in_range);
				exit;
			}
		}
		ds_list_clear(units_in_range);
		
		//Damage any targets around you
		/*
		if(movement_path != pth_dummypath && path_position == 1) {
			attack_timer++;
			range.get_entities_in_range(base_target, targets_in_range, true);
			if(attack_timer >= seconds_to_roomspeed_frames(seconds_per_attack)) {
				if(!ds_list_empty(targets_in_range)) {
					deal_damage(targets_in_range[| 0], melee_damage);
					attack_timer = 0;
				}
			}
			ds_list_clear(targets_in_range);
		}*/
        break;
}