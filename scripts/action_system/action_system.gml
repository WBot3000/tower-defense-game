/*
This file contains a potential implementation of an Action System, where unit/enemy behavior is split up into multiple discrete "actions" that can be taken.
Each action has a prerequisite, an execution function, and an update function (for updating things like timers or re-rolling random numbers)
*/

#region Action (Class)
/*
	Base action for which all other actions are defined from
	
	The action_id can be used to refer to the action using a name
	The actor is the one who's performing the action
*/
function Action(_action_id, _actor = other) constructor {
	
	action_id = _action_id;
	actor = _actor;
	
	//What needs to be true for this action to run. Should return true if the action should be run on the current frame, false otherwise
	static prerequisite = function() {return true};
	
	//The code of the action itself
	static execute = function() {};
	
	//Should run every step, even when the action isn't executing, to update things like timers
	static update_params = function() {};
	
	//If any parameters need to be changed on knockout, this is where you should do it
	static on_health_reached_zero = function() {};
	
	//If any parameters need to be changed on unit restoration (going back to the active state), this is where you should do it
	static on_restore = function() {};
	
	//If anything needs to be cleaned up after a unit is sold/deleted, this is where you should do it
	static on_deletion = function() {};
}
#endregion


#region DirectDamageAction (Class)
/*
	Used to deal direct damage to a detected enemy, without the use of something like a projectile
	
	Variables:
	frames_between_attacks: The number of frames that occur between one attack and the next
	attack_damage: How much damage the attack should do (for attacks that have configurable damage)
	effect: An effect that can be drawn on the enemy to indicate that a direct attack is occuring
	
	action_id and actor are the same as the base Action
*/
function DirectDamageAction(_action_id, _valid_targets, _frames_between_attacks, _attack_damage, _effect_sprite = undefined, _actor = other) 
	: Action(_action_id, _actor) constructor {
		
		valid_targets = _valid_targets;
		frames_between_attacks = _frames_between_attacks;
		attack_damage = _attack_damage;
		effect_sprite = _effect_sprite;
		
		timer = 0;
		entities_in_range = ds_list_create();
		static targeting_params = new TargetingParams(true, false);
		
		
		static execute = function() {
			if(timer < frames_between_attacks) { return; }
			actor.range.get_entities_in_range(valid_targets, entities_in_range);
			if(ds_list_empty(entities_in_range)) { return; }
			
			var _targeting_type = actor.targeting_tracker.get_current_targeting_type();
			var _entity_to_target = _targeting_type.targeting_fn(actor.inst, entities_in_range, targeting_params);
			if(_entity_to_target == noone) { return; }
			
			actor.direction_facing = get_entity_facing_direction(actor.inst, _entity_to_target.x);
			actor.inst.image_xscale = actor.direction_facing; //Seperate variables for now just in case I want to do other things with direction_facing
			
			deal_damage(_entity_to_target, attack_damage);
			actor.animation_controller.set_animation("ATTACK");
			if(effect_sprite != undefined) {
				draw_damage_effect(_entity_to_target, effect_sprite);
			}

			timer = 0;
		}
		
		
		static update_params = function() {
			timer++;
			ds_list_clear(entities_in_range);
		}
		
		
		static on_health_reached_zero = function() {
			timer = 0;
		}
		
		
		static on_deletion = function() {
			ds_list_destroy(entities_in_range);
		}
}
#endregion


#region ShootProjectileAction (Class)
/*
	Used to shoot a projectile at an enemy
	
	Variables:
	projectile: The projectile object that will be shot at the enemy
	frames_between_shots: The number of frames that occur between one shot and the next
	projectile_damage: How much damage the projectile should do (for projectiles that have configurable damage)
	projectile_speed: How fast the projectile should travel (for projectiles that have configurable travel speed)
	
	action_id and actor are the same as the base Action
*/
function ShootProjectileAction(_action_id, _projectile, _valid_targets, _frames_between_shots, _projectile_data, _actor = other) 
	: Action(_action_id, _actor) constructor {
		
		projectile = _projectile;
		valid_targets = _valid_targets;
		frames_between_shots = _frames_between_shots;
		projectile_data = _projectile_data;
		
		timer = 0;
		entities_in_range = ds_list_create();
		static targeting_params = new TargetingParams(true, false);
		
		
		static execute = function() {
			if(timer < frames_between_shots) { return; }
			actor.range.get_entities_in_range(valid_targets, entities_in_range);
			if(ds_list_empty(entities_in_range)) { return; }
			
			var _targeting_type = actor.targeting_tracker.get_current_targeting_type();
			var _enemy_to_target = _targeting_type.targeting_fn(actor.inst, entities_in_range, targeting_params);
			if(_enemy_to_target == noone) { return; }
			
			//TODO: Right now, the vector is from the center of the unit to the center of the enemy unit. Will probably want to adjust these positions based on the enemy's position compared to the unit's
			var _vector = instances_vector_to_get_components(actor.inst, _enemy_to_target, true);
	
			actor.direction_facing = get_entity_facing_direction(actor.inst, _enemy_to_target.x);
			actor.inst.image_xscale = actor.direction_facing; //Seperate variables for now just in case I want to do other things with direction_facing
			
			actor.animation_controller.set_animation("SHOOT");
			instance_create_layer((actor.inst.bbox_left + actor.inst.bbox_right)/2, (actor.inst.bbox_top + actor.inst.bbox_bottom)/2, PROJECTILE_LAYER, projectile,
				{
					x_speed: _vector[VEC_X] * projectile_data.travel_speed,
					y_speed: _vector[VEC_Y] * projectile_data.travel_speed,
					data: projectile_data //NOTE: Also includes travel speed not broken up + normalized
				});
					
			timer = 0;
		}
		
		
		static update_params = function() {
			timer++;
			ds_list_clear(entities_in_range);
		}
		
		
		static on_health_reached_zero = function() {
			timer = 0;
		}
		
		
		static on_deletion = function() {
			ds_list_destroy(entities_in_range);
		}
}
#endregion


#region GenerateMoneyAction (Class)
/*
	Used for when a unit wants to generate money.
	
	Variables:
	amount_generated: How much money is generated each time this action is activated
	frames_between_generations: How many frames need to pass between each time money is generated
	
	Mainly just for the Gold Construct right now but might be useful for future units as well.
	TODO: If I come up with a unit that generates a certain money after a certain number of enemy kills, add that as a parameter for this action too
*/
function GenerateMoneyAction(_action_id, _amount_generated, _frames_between_generation, _actor = other) 
	: Action(_action_id, _actor) constructor {
		
		amount_generated = _amount_generated;
		frames_between_generation = _frames_between_generation;
		
		round_manager = get_round_manager();
		timer = 0;
		
		
		static execute = function() {
			if(!round_manager.is_spawning_enemies() || timer < frames_between_shots) { return; }
			
			global.player_money += money_generation_amount;
			timer = 0;
			
			actor.animation_controller.set_animation("GENERATE");
			//TODO: Make these sparkles configurable if need be
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
		
		
		static update_params = function() {
			if(round_manager.is_spawning_enemies()) { //Without this check, players would just be able to wait in between rounds to generate infinite money
				timer++;
			}
		}
		
		
		static on_health_reached_zero = function() {
			timer = 0;
		}
		
}
#endregion
