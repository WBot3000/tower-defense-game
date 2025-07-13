/// @description Gotta write the algorithm for money spawning

switch (health_state) {
    case HEALTH_STATE.ACTIVE:
		if(current_health <= 0) {
			health_state = HEALTH_STATE.KNOCKED_OUT;
			shot_timer = 0;
		}
		
		if(cached_round_manager.is_spawning_enemies()) {
			money_generation_timer++;
			if(money_generation_timer >= frames_per_generation) {
				global.player_money += money_generation_amount;
				money_generation_timer = 0;
				
				part_particles_create(global.PARTICLE_SYSTEM,
					x + random_range(-TILE_SIZE/2 + 8, -TILE_SIZE/2 + 16),  y - random_range(16, 24),
					global.PARTICLE_SPARKLE, 1);
					
				part_particles_create(global.PARTICLE_SYSTEM,
					x + random_range(TILE_SIZE/2 - 16, TILE_SIZE/2 - 8),  y - random_range(20, 28),
					global.PARTICLE_SPARKLE, 1);
					
				part_particles_create(global.PARTICLE_SYSTEM,
					x + random_range(-4, 4),  y - random_range(32, 40),
					global.PARTICLE_SPARKLE, 1);
			}
		}
		
        break;
	case HEALTH_STATE.KNOCKED_OUT:
		var _amount_to_recover = recovery_rate / seconds_to_roomspeed_frames(1);
		current_health = min(max_health, current_health + _amount_to_recover);
		if(current_health >= max_health) {
			//animation_controller.set_animation(spr_sample_gunner, LOOP_FOREVER);
			health_state = HEALTH_STATE.ACTIVE; 
		}
		break;
    default:
        break;
}