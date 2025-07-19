/*
This file contains data about the Chompy Worm enemy
*/
global.ANIMBANK_SWORDBEETLE = new EnemyAnimationBank(spr_sword_beetle);
global.ANIMBANK_SWORDBEETLE.add_animation("ATTACK", spr_sword_beetle);

function SwordBeetle(_path_data, _round_spawned_in) : 
	Enemy(_path_data, _round_spawned_in) constructor {
	name = "Sword Beetle";
	
	//Health variables
	max_health = 30;
	current_health = 30;
	health_state = HEALTH_STATE.ACTIVE
	
	//Stat modifiers
	default_movement_speed = 1;
	defense_factor = 2; //All taken damage is divided by this value
	
	monetary_value = 75;
	
	range = new MeleeRange(inst);
	targeting_tracker = 
	new TargetingTracker( [global.ENEMY_TARGETING_DEFAULT] );
	buffs = [];
	
	action_queue = [
		new PathTravelAction("MOVE", _path_data.default_path, default_movement_speed),
		new DirectDamageAction("SLASH", [base_unit, base_target], seconds_to_roomspeed_frames(1), 10, spr_slash)
	];
	
	animation_controller = new AnimationController(inst, global.ANIMBANK_SWORDBEETLE);
}