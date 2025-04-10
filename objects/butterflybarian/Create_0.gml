/// @description Declare variables and initiate moving
// TODO: Inherit from base enemy in case a value isn't defined?
name = "Butterfly-barian"

max_health = 30;
current_health = 30;

default_movement_speed = 3; //In pixels per game step (frame I think)
if(!variable_instance_exists(self.id, "movement_path")) { //If the enemy wasn't given a movement path upon creation, just have it stay still. Shouldn't occur during normal gameplay.
	movement_path = pth_dummypath;
}

//attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;

//Doesn't use the default melee range because the sprite is too small. Not an issue anyway since this enemy doesn't move
range = new CircularRange(self.id, x + sprite_width/2, y + sprite_height/2, tilesize_to_pixels(0.75));
melee_damage = 20;
frames_per_attack = seconds_to_roomspeed_frames(1);	//How many frames have to go by before the enemy can attack again.
//num_frames_paused = seconds_to_roomspeed_frames(0.5); //How many frames the enemy pauses to attack.

monetary_value = 100;

enemy_buffs = [];

//Variables to keep track of things
//state_timer = 0;

entities_in_range = ds_list_create();
//targets_in_range = ds_list_create();
entity_attack_cooldown_queue = new EntityCooldownList();

path_start(movement_path, default_movement_speed, path_action_stop, false);
