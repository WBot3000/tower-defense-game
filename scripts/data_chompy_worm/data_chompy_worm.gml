/*
This file contains data about the Chompy Worm enemy
*/
global.ANIMBANK_CHOMPYWORM = new EnemyAnimationBank(spr_chompy_worm);
global.ANIMBANK_CHOMPYWORM.add_animation("ATTACK", spr_chompy_worm);

function ChompyWorm() : 
	EnemyData() constructor {
	name = "Chompy Worm";
	
	//Health variables
	max_health = 30;
	
	//Stat modifiers
	default_movement_speed = 1.5; //In pixels per game step/frame
	defense_factor = 1; //All taken damage is divided by this value
	attack_damage = 10;
	frames_per_attack = seconds_to_roomspeed_frames(2);
	
	//Monetary value
	monetary_value = 50;
	
	sight_range = new MeleeRange(inst);
}