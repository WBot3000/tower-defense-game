/// @description Check and change direction
if(attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING) {
	direction_facing = get_enemy_path_direction(self);
	image_xscale = direction_facing;
}
