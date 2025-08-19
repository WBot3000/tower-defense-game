/*
This file contains data about the Chompy Worm enemy
*/
global.ANIMBANK_KINGWORM = new EnemyAnimationBank(spr_king_worm);
global.ANIMBANK_KINGWORM.add_animation("ATTACK", spr_king_worm);

global.ANIMBANK_KINGWORM_WORMHOLE = new AnimationBank(spr_wormhole);
global.ANIMBANK_KINGWORM_WORMHOLE.add_animation("OPENING", spr_wormhole_opening);
global.ANIMBANK_KINGWORM_WORMHOLE.add_animation("CLOSING", spr_wormhole_closing);

function KingWorm() : 
	EnemyData() constructor {
	name = "King Worm";
	
	//Health variables
	max_health = 1000;
	
	//Stat modifiers
	default_movement_speed = 0.5;
	defense_factor = 1; //All taken damage is divided by this value
	attack_damage = 10;
	frames_per_attack = seconds_to_roomspeed_frames(1);
	frames_per_wormhole_summon = seconds_to_roomspeed_frames(20);
	
	//Monetary value
	monetary_value = 1000;
	
	sight_range = new MeleeRange(inst);
}