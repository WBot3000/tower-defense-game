/// @description Declare variables and initiate moving
// TODO: Inherit from base enemy in case a value isn't defined?
name = "Magic Mosquito"

max_health = 30;
current_health = 30;

default_movement_speed = 1; //Not sure what unit this is, but I'm converting it using seconds_to_roomspeed_frames for some reason (despite seconds not being a unit of speed)

attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;

//range = new MeleeRange(self.id); //CircularRange(self.id, x + sprite_width/2, y + sprite_height/2, tilesize_to_pixels(0.5));
melee_damage = 2;
frames_per_attack = seconds_to_roomspeed_frames(0.25);	//How many frames have to go by before the enemy can attack again.
//num_frames_paused = seconds_to_roomspeed_frames(0.25); //How many frames the enemy pauses to attack.

monetary_value = 25;

//Variables to keep track of things
state_timer = 0;

move_x = 0;
move_y = 0;
focused_entity = noone;

event_inherited();
