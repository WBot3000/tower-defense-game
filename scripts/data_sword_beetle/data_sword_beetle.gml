/*
This file contains data about the Chompy Worm enemy
*/
global.ANIMBANK_SWORDBEETLE = new EnemyAnimationBank(spr_sword_beetle);
global.ANIMBANK_SWORDBEETLE.add_animation("ATTACK", spr_sword_beetle);

function SwordBeetle() : 
	EnemyData() constructor {
	name = "Sword Beetle";
	
	//Health variables
	max_health = 60;
	
	//Stat modifiers
	default_movement_speed = 1;
	defense_factor = 2; //All taken damage is divided by this value
	attack_damage = 10;
	frames_per_attack = seconds_to_roomspeed_frames(1);
	
	//Monetary value
	monetary_value = 75;
	
	sight_range = new MeleeRange(inst);
}