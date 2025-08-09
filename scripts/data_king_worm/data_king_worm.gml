/*
This file contains data about the Chompy Worm enemy
*/
global.ANIMBANK_KINGWORM = new EnemyAnimationBank(spr_king_worm);
global.ANIMBANK_KINGWORM.add_animation("ATTACK", spr_king_worm);

function KingWormData(_path_data, _round_spawned_in) : 
	EnemyData(_path_data, _round_spawned_in) constructor {
	name = "Chompy Worm";
	
	//Health variables
	max_health = 1000;
	current_health = 1000;
	health_state = HEALTH_STATE.ACTIVE
	
	//Stat modifiers
	default_movement_speed = 0.5;
	defense_factor = 1; //All taken damage is divided by this value
	
	//Monetary value
	monetary_value = 1000;
	
	range = new MeleeRange(inst);
	targeting_tracker = 
	new TargetingTracker( [global.ENEMY_TARGETING_DEFAULT] );
	buffs = [];
	path_data = _path_data;
	
	static movement_block_fn = method(self, enemy_standard_path_stop_moving_func)
	
	action_queue = [
		new PathTravelAction("MOVE", path_data, default_movement_speed, movement_block_fn),
		new DirectDamageAction("BITE", [base_unit, base_target], seconds_to_roomspeed_frames(1), 20, spr_bite)
	];
	
	animation_controller = new AnimationController(inst, global.ANIMBANK_KINGWORM);
}