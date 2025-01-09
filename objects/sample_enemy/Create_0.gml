/// @description Declare variables and initiate moving
// TODO: Inherit from base enemy in case a value isn't defined?
name = "Sample Enemy"

max_health = 30;
current_health = 30;

default_movement_speed = 0.025; //TODO: What unit is this?
if(!variable_instance_exists(self.id, "movement_path")) { //If the enemy wasn't given a movement path upon creation, just have it stay still. Shouldn't occur during normal gameplay.
	movement_path = pth_dummypath;
}

attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;
unit_currently_attacking = noone;

range = new BrawlerRange(id);
melee_damage = 5;
seconds_per_attack = 1;

monetary_value = 50;

enemy_buffs = [];

//Variables to keep track of things
attack_timer = 0;

units_in_range = ds_list_create();

path_start(movement_path, seconds_to_roomspeed_frames(default_movement_speed), path_action_stop, false);
