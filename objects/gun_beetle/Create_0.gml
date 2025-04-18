/// @description Declare variables and initiate moving
// TODO: Inherit from base enemy in case a value isn't defined?
name = "Gun Beetle"

max_health = 45;
current_health = 45;

direction_facing = DIRECTION_RIGHT;
image_xscale = direction_facing;

default_movement_speed = 1;
if(!variable_instance_exists(self.id, "path_data")) { //If the enemy wasn't given a movement path upon creation, just have it stay still. Shouldn't occur during normal gameplay.
	path_data = global.DATA_LEVEL_PATH_DUMMYPATH;
}

attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;

range = new CircularRange(self.id, get_bbox_center_x(self.id), get_bbox_center_y(self.id), tilesize_to_pixels(3));
shot_damage = 10;
shot_speed = 15;
frames_per_attack = seconds_to_roomspeed_frames(2);	//How many frames have to go by before the enemy can attack again.

monetary_value = 75;

enemy_buffs = [];

//Variables to keep track of things
state_timer = 0;

units_in_range = ds_list_create();
targets_in_range = ds_list_create();
focused_entity = noone;

path_start(path_data.default_path, default_movement_speed, path_action_stop, false);
