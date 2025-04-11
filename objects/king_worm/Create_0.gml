/// @description Declare variables and initiate moving
// TODO: Inherit from base enemy in case a value isn't defined?
name = "Chompy Worm"

max_health = 1000;
current_health = 1000;

direction_facing = DIRECTION_RIGHT;
image_xscale = direction_facing;

default_movement_speed = 0.25; //In pixels per game step (frame I think)
if(!variable_instance_exists(self.id, "movement_path")) { //If the enemy wasn't given a movement path upon creation, just have it stay still. Shouldn't occur during normal gameplay.
	movement_path = pth_dummypath;
}

attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;

range = new MeleeRange(self.id); //CircularRange(self.id, x + sprite_width/2, y + sprite_height/2, tilesize_to_pixels(0.5));
melee_damage = 5;
frames_per_attack = seconds_to_roomspeed_frames(1);	//How many frames have to go by before the enemy can attack again.
num_frames_paused = seconds_to_roomspeed_frames(0.25); //How many frames the enemy pauses to attack.

monetary_value = 50;

enemy_buffs = [];

//Variables to keep track of things
state_timer = 0;

units_in_range = ds_list_create();
targets_in_range = ds_list_create();

path_start(movement_path, default_movement_speed, path_action_stop, false);
