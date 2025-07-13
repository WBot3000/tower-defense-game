/// @description Declare variables and initiate moving
name = "Butterfly-barian"

max_health = 30;
current_health = 30;

direction_facing = DIRECTION_RIGHT;
image_xscale = direction_facing;

default_movement_speed = 3; //In pixels per game step (frame I think)
if(!variable_instance_exists(self.id, "path_data")) { //If the enemy wasn't given a movement path upon creation, just have it stay still. Shouldn't occur during normal gameplay.
	path_data = global.DATA_LEVEL_PATH_DUMMYPATH;
}

//attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;

//Doesn't use the default melee range because the sprite is too small. Not an issue anyway since this enemy doesn't move
range = new CircularRange(self.id, get_bbox_center_x(self.id), get_bbox_center_y(self.id), tilesize_to_pixels(0.75));
melee_damage = 20;
frames_per_attack = seconds_to_roomspeed_frames(1);	//How many frames have to go by before the enemy can attack again.
//num_frames_paused = seconds_to_roomspeed_frames(0.5); //How many frames the enemy pauses to attack.

monetary_value = 100;

enemy_buffs = [];

//Variables to keep track of things

entities_in_range = ds_list_create();
//targets_in_range = ds_list_create();
entity_attack_cooldown_queue = new EntityCooldownList();

path_start(path_data.default_path, default_movement_speed, path_action_stop, false);
