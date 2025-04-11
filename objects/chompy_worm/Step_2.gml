/// @description Check and change direction

direction_facing = get_enemy_path_direction(self);
image_xscale = (direction_facing == DIRECTION.LEFT ? -1 : 1)