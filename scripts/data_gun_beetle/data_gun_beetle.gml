/*
This file contains data about the Chompy Worm enemy
*/
global.ANIMBANK_GUNBEETLE = new EnemyAnimationBank(spr_gun_beetle);
global.ANIMBANK_GUNBEETLE.add_animation("ATTACK", spr_gun_beetle);

function GunBeetle(_path_data, _round_spawned_in) : 
	EnemyData(_path_data, _round_spawned_in) constructor {
	name = "Gun Beetle";
	
	//Health variables
	max_health = 45;
	current_health = 45;
	health_state = HEALTH_STATE.ACTIVE;
	
	//Stat modifiers
	default_movement_speed = 1.5;
	defense_factor = 1; //All taken damage is divided by this value
	
	monetary_value = 75;
	
	range = new CircularRange(inst, 0, 0, tilesize_to_pixels(3));
	targeting_tracker = 
	new TargetingTracker( [global.ENEMY_TARGETING_DEFAULT] );
	buffs = [];
	path_data = _path_data;
	
	var _projectile_data = {
				damage: 10, 
				travel_speed: 15,
				pierce: 1
			};
			
	static movement_block_fn = method(self, enemy_standard_path_stop_moving_func)
	
	action_queue = [
		new PathTravelAction("MOVE", path_data, default_movement_speed, movement_block_fn),
		new ShootProjectileAction("SHOOT", gun_beetle_bullet, [base_unit, base_target], seconds_to_roomspeed_frames(2), _projectile_data)
	];
	
	animation_controller = new AnimationController(inst, global.ANIMBANK_GUNBEETLE);
}