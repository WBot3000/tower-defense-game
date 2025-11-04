/// @description Spawn enemies and delete worm hole if needed.

animation_controller.on_step();

switch (splotch_state) {
	case SLIDING_MENU_STATE.OPEN:
		if(existence_timer > existence_time_limit) {
			splotch_state = SLIDING_MENU_STATE.CLOSING;
			animation_controller.set_animation("SHRINKING", 1, function() { instance_destroy(self) } );
			exit;
		}

		//TODO: Probably a better way to do this than continuously applying the buff, but I'm tired rn
		instance_place_list(x, y, base_enemy, enemy_collision_list, false);
		for(var i = 0, len = ds_list_size(enemy_collision_list); i < len; ++i) {
			var _enemy = enemy_collision_list[| i];
			_enemy.buffs.apply_buff(BUFF_IDS.MUDDY);
		}

		ds_list_clear(enemy_collision_list);
		existence_timer++;
		break;
    default:
        break;
}
