///@description Declare variables and initiate moving

name = "NAME_NOT_PROVIDED"

max_health = 0;
current_health = 0;

default_movement_speed = 0;
path_data = global.DATA_LEVEL_PATH_DUMMYPATH;

monetary_value = 0;

enemy_buffs = [];

path_start(path_data.default_path, seconds_to_roomspeed_frames(default_movement_speed), path_action_stop, false);