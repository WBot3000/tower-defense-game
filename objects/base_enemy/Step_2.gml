/// @description Set direction
if(movement_controller.state == MOVEMENT_STATE.UNIMPEDED) {
	set_facing_direction(get_enemy_path_direction(self));
}