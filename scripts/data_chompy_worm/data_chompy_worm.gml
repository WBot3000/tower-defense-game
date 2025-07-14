/*
This file contains data about the Chompy Worm enemy
*/
global.ANIMBANK_CHOMPYWORM = new EnemyAnimationBank(spr_chompy_worm);
global.ANIMBANK_CHOMPYWORM.add_animation("ATTACK", spr_chompy_worm);

function ChompyWorm(_path_data, _round_spawned_in) : 
	Enemy(_path_data, _round_spawned_in) constructor {
	name = "Chompy Worm";
	
	//Health variables
	max_health = 30;
	current_health = 30;
	health_state = HEALTH_STATE.ACTIVE
	
	//Stat modifiers
	defense_factor = 1; //All taken damage is divided by this value
	
	range = new MeleeRange(inst);
	targeting_tracker = 
	new TargetingTracker( [global.ENEMY_TARGETING_DEFAULT] );
	buffs = [];
	
	action_queue = [
		new DirectDamageAction("BITE", [base_unit, base_target], seconds_to_roomspeed_frames(1), 10, spr_bite)
	];
	
	animation_controller = new AnimationController(inst, global.ANIMBANK_CHOMPYWORM);
}