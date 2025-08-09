/// @description Insert description here

event_inherited();

switch (health_state) {
    case HEALTH_STATE.ACTIVE:
		if(cached_round_manager.is_spawning_enemies()) {
			money_generation_timer++;
			if(money_generation_timer >= entity_data.frames_per_generation) {
				global.player_money += entity_data.money_generation_amount;
				money_generation_timer = 0;
				animation_controller.set_animation("GENERATE");
				
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
		
		if(current_health <= 0) {
			standard_on_ko_actions();
			money_generation_timer = 0;
		}
		
        break;
	case HEALTH_STATE.KNOCKED_OUT:
		standard_recover_from_ko_actions();
		break;
    default:
        break;
}