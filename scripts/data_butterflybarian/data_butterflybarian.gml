/*
This file contains data about the Butterflybarian enemy
*/
global.ANIMBANK_BUTTERFLYBARIAN = new EnemyAnimationBank(spr_butterflybarian);
global.ANIMBANK_BUTTERFLYBARIAN.add_animation("ATTACK", spr_butterflybarian);

function Butterflybarian() : 
	EnemyData() constructor {
	name = "Butterflybarian";
	
	//Health variables
	max_health = 30;
	current_health = 30;
	health_state = HEALTH_STATE.ACTIVE
	
	//Stat modifiers
	default_movement_speed = 4;
	defense_factor = 1; //All taken damage is divided by this value
	attack_damage = 20;
	frames_per_attack = seconds_to_roomspeed_frames(1);
	
	//Monetary value
	monetary_value = 100;
	
	//Doesn't use the default melee range, as the Butterflybarian sprite is just too small.
	sight_range = new CircularRange(inst, 0, 0, tilesize_to_pixels(0.75));
}