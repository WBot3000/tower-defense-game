/// @description Spawn enemies and delete worm hole if needed.

if(existence_timer > existence_time_limit) {
	instance_destroy();
	exit;
}

animation_controller.on_step();

//TODO: Add enemy spawning
if(worm_spawn_timer > frames_per_worm_spawn) {
	var _worm = round_manager.spawn_extra_enemy(chompy_worm, enemy_path_data, round_spawned_in);
	if(_worm != noone) {
		_worm.path_positionprevious = path_starting_percentage; //Don't know if I actually have to set this, but just in case
		_worm.path_position = path_starting_percentage;
	}
	worm_spawn_timer = 0;
}

worm_spawn_timer++
existence_timer++;
