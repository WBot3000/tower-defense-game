/// @description Move the cloud

animation_controller.on_step();

switch (state) {
    case CLOUD_STATE.TRAVELING_TO_TARGET:
        //If the original target no longer exists, pick a new one based on the summoner's current targeting
		if(!can_be_attacked(target)) {
			var _targeting_type = global.TARGETING_CLOSE; //In the event the owner was sold, need a fallback option
			if(instance_exists(owner)) {
				_targeting_type = owner.targeting_tracker.get_current_targeting_type();
			}
			
			range.get_entities_in_range([base_enemy], enemies_in_range);
			target = _targeting_type.targeting_fn(self.id, global.ALL_ENEMIES_LIST, true);
			if(target == noone) { //If no enemies can be found, just dissipate. TODO: Might change this behavior later
				state = CLOUD_STATE.DISSIPATING
				animation_controller.set_animation("DISSIPATING", 1, function(){ instance_destroy(self, true) });
				break;
			}
			ds_list_clear(enemies_in_range);
		}
		var _vector = vector_to_get_components(x, y, target.x, target.y - TILE_SIZE, true);
		x += _vector[VEC_X] * data.travel_speed;
		y += _vector[VEC_Y] * data.travel_speed;
		if(abs(x - target.x) <= data.travel_speed) { //Handle precision errors
			x = target.x;
		}
		if(abs(y - (target.y - TILE_SIZE)) <= data.travel_speed) {
			y = target.y - TILE_SIZE;
		}
		if(x == target.x && y == target.y - TILE_SIZE) {
			state = CLOUD_STATE.LINGERING;
		}
        break;
	case CLOUD_STATE.LINGERING:
        if(!can_be_attacked(target)) {
			var _targeting_type = global.TARGETING_CLOSE; //In the event the owner was sold, need a fallback option
			if(instance_exists(owner)) {
				_targeting_type = owner.targeting_tracker.get_current_targeting_type();
			}
			
			range.get_entities_in_range([base_enemy], enemies_in_range);
			target = _targeting_type.targeting_fn(self.id, enemies_in_range, global.DEFAULT_TARGETING_PARAMETERS);
			if(target == noone) { //If no enemies can be found, just dissipate. TODO: Might change this behavior later
				state = CLOUD_STATE.DISSIPATING;
				animation_controller.set_animation("DISSIPATING", 1, function(){ instance_destroy(self, true) });
				
			}
			else {
				state = CLOUD_STATE.TRAVELING_TO_TARGET;
			}
			part_emitter_stream(global.PARTICLE_SYSTEM, rain_emitter, global.PARTICLE_RAIN, 0);
			ds_list_clear(enemies_in_range);
			break;
		}
		
		x = target.x;
		y = target.y - TILE_SIZE;
		part_emitter_region(global.PARTICLE_SYSTEM, rain_emitter, x - 8, x + 8, y + sprite_height, y + sprite_height, ps_shape_rectangle, ps_distr_linear);
		part_emitter_region(global.PARTICLE_SYSTEM, spark_emitter, x - 8, x + 8, y + 32, y + 64, ps_shape_ellipse, ps_distr_gaussian);
		
		damage_timer++;
		if(damage_timer >= data.frames_to_damage) {
			deal_damage(target, data.damage);
			part_emitter_stream(global.PARTICLE_SYSTEM, rain_emitter, global.PARTICLE_RAIN, 1);
			damage_timer = 0;
		}
		lightning_timer++
		if(lightning_timer >= data.frames_to_lightning) {
			animation_controller.set_animation("LIGHTNING", 1);
			shock_area.get_entities_in_range([base_enemy], enemies_in_shock_area);
			for(var i = 0, len = ds_list_size(enemies_in_shock_area); i < len; ++i) {
				//TODO: Replace constant with lightning damage variable
				deal_damage(enemies_in_shock_area[| i], 20);
			}
			part_emitter_stream(global.PARTICLE_SYSTEM, spark_emitter, global.PARTICLE_SPARKLE, 10);
			lightning_timer = 0;
		}
		
		linger_timer++;
		if(linger_timer >= data.frames_to_linger) {
			state = CLOUD_STATE.DISSIPATING;
			animation_controller.set_animation("DISSIPATING", 1, function(){ instance_destroy(self, true) });
		}
        break;
	case CLOUD_STATE.DISSIPATING:
    default:
        break;
}