///@description Declare variables and initiate moving

name = "NAME_NOT_PROVIDED"

max_health = 0;
current_health = 0;

default_movement_speed = 0;
movement_path = pth_dummypath;

monetary_value = 0;

enemy_buffs = [];

path_start(movement_path, seconds_to_roomspeed_frames(default_movement_speed), path_action_stop, false);