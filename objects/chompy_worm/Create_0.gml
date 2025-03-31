/// @description Declare variables and initiate moving
// TODO: Inherit from base enemy in case a value isn't defined?
name = "Chompy Worm"

max_health = 300;
current_health = 300;

default_movement_speed = 0.025; //Not sure what unit this is, but I'm converting it using seconds_to_roomspeed_frames for some reason (despite seconds not being a unit of speed)
if(!variable_instance_exists(self.id, "movement_path")) { //If the enemy wasn't given a movement path upon creation, just have it stay still. Shouldn't occur during normal gameplay.
	movement_path = pth_dummypath;
}

attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;

range = new BrawlerRange(id);
melee_damage = 5;
frames_per_attack = seconds_to_roomspeed_frames(1);	//How many frames have to go by before the enemy can attack again.
num_frames_paused = seconds_to_roomspeed_frames(0.25); //How many frames the enemy pauses to attack.

monetary_value = 50;

enemy_buffs = [];

//Variables to keep track of things
state_timer = 0;

enemies_in_range = ds_list_create();
targets_in_range = ds_list_create();

path_start(movement_path, seconds_to_roomspeed_frames(default_movement_speed), path_action_stop, false);
