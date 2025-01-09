/// @description Deal damage to all units in the explosion (if they haven't been damaged within a certain timeframe)
if(explosion_timer >= explosion_total_length) {
	instance_destroy();
	exit;
}

explosion_hitbox.on_step(base_enemy, enemies_in_range, false);
explosion_timer++;