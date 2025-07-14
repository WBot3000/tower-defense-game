/*
This file contains data about the Butterflybarian enemy
*/
global.ANIMBANK_BUTTERFLYBARIAN = new EnemyAnimationBank(spr_butterflybarian);
global.ANIMBANK_BUTTERFLYBARIAN.add_animation("ATTACK", spr_butterflybarian);

function Butterflybarian(_path_data, _round_spawned_in) : 
	Enemy(_path_data, _round_spawned_in) constructor {
	name = "Butterflybarian";
	
	//Health variables
	max_health = 30;
	current_health = 30;
	health_state = HEALTH_STATE.ACTIVE
	
	//Stat modifiers
	default_movement_speed = 4;
	defense_factor = 1; //All taken damage is divided by this value
	
	//Doesn't use the default melee range, as the Butterflybarian sprite is just too small.
	range = new CircularRange(inst, 0, 0, tilesize_to_pixels(0.75));
	buffs = [];
	
	action_queue = [
		new RapidDirectDamageAction("SLASH", [base_target, base_unit], seconds_to_roomspeed_frames(1), 20, spr_slash)
	];
	
	animation_controller = new AnimationController(inst, global.ANIMBANK_BUTTERFLYBARIAN);
}