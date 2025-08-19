/// @description Spawn enemies and delete worm hole if needed.

animation_controller.on_step();

switch (wormhole_state) {
	/*
    case SLIDING_MENU_STATE.OPENING:
        if(sprite_index == spr_wormhole) {
			wormhole_state = SLIDING_MENU_STATE.OPEN;
		}
        break;*/
	case SLIDING_MENU_STATE.OPEN:
		if(existence_timer > existence_time_limit) {
			//instance_destroy();
			wormhole_state = SLIDING_MENU_STATE.CLOSING;
			animation_controller.set_animation("CLOSING", 1, spr_dummy);
			exit;
		}

		if(worm_spawn_timer > frames_per_worm_spawn) {
			var _worm = round_manager.spawn_extra_enemy(chompy_worm, enemy_path_data, round_spawned_in);
			if(_worm != noone) {
				_worm.path_positionprevious = path_starting_percentage; //Don't know if I actually have to set this, but just in case
				_worm.path_position = path_starting_percentage;
			}
			worm_spawn_timer = 0;
		}

		worm_spawn_timer++
		existence_timer++;
		break;
	case SLIDING_MENU_STATE.CLOSING:
		if(sprite_index == spr_dummy) {
			instance_destroy();
			exit;
		}
		break;
    default:
        break;
}
