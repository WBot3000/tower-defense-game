/*
This file contains data about the Chompy Worm enemy
*/
global.ANIMBANK_GUNBEETLE = new EnemyAnimationBank(spr_gun_beetle);
global.ANIMBANK_GUNBEETLE.add_animation("ATTACK", spr_gun_beetle);

function GunBeetle() : 
	EnemyData() constructor {
	name = "Gun Beetle";
	
	//Health variables
	max_health = 45;
	
	//Stat modifiers
	default_movement_speed = 1.5;
	defense_factor = 1; //All taken damage is divided by this value
	frames_per_attack = seconds_to_roomspeed_frames(2);
	
	monetary_value = 75;
	
	sight_range = new CircularRange(inst, 0, 0, tilesize_to_pixels(3));

	projectile_data = {
				damage: 10, 
				travel_speed: 15,
				pierce: 1
			};
			
}