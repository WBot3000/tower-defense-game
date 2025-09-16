/// @description Destroy if the target's health has gone below zero
switch (health_state) {
    case HEALTH_STATE.ACTIVE:
		if(current_health <= 0) {
			health_state = HEALTH_STATE.KNOCKED_OUT
			var _game_state_manager = get_game_state_manager();
			if(_game_state_manager.state == GAME_STATE.RUNNING) {
				_game_state_manager.lose_game();
			}
		}
        break;
    default:
        break;
}

