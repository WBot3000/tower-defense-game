/*
This file contains a potential implementation of an Action System, where unit/enemy behavior is split up into multiple discrete "actions" that can be taken.
Each action has a prerequisite, an execution function, and an update function (for updating things like timers or re-rolling random numbers)
*/

//NOTE: Getting rid of this, replacing it with a simpler system

#region Action (Class)
/*
	Base action for which all other actions are defined from
	
	The action_id can be used to refer to the action using a name
	The actor is the one who's performing the action
*/
function Action(_action_id, _actor = other) constructor {
	
	action_id = _action_id;
	actor = _actor;
	
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


#region TravelAction (Class)
/*
	Used to control entity movement (usually enemies, but will keep language vague in case I want to implement moving units/targets)
	
	Variables:
	movement_state: Determines whether an entity is able to move or not based on surrounding circumstances //TODO: Use boolean instead?
	start_movement_func: A function that determines whether or not an enemy can start moving again once blocked. Should return true if it can, false if it can't.
	stop_movement_func: A function that determines whether or not an enemy can stop moving based on the surrounding environment. Should return true if it should stop, false if it shouldn't.
	
	action_id and actor are the same as the base Action
*/
enum MOVEMENT_STATE {
	FREE,
	BLOCKED
}

function TravelAction(_action_id, _movement_blocked_fn = function(){ return false; }, _actor = other) :
	Action(_action_id, _actor) constructor {
		movement_state = MOVEMENT_STATE.FREE;
		
		movement_blocked_fn = _movement_blocked_fn;
}
#endregion


#region PathTravelAction (Class)
/*
	Used to facilitate movement along a path. Controls when an enemy can move, when they need to stop moving, and when they can continue moving.
	
	Variables:
	path_data: The path data that the entity utilizes
	default_movement_speed: The speed (in pixels per step) at which the enemy should travel
	end_action: What the entity should do once they reach the end of the path
	
	entity_previous_x: Enemy's x-Used to determine enemy direction
	
	action_id and actor are the same as the base Action
	movement_blocked_fn is the same as the base TravelAction
*/
function PathTravelAction(_action_id, _path_data, _default_movement_speed, _movement_blocked_fn = function(){ return false; }, _end_action = path_action_stop, _actor = other)
	: TravelAction(_action_id, _movement_blocked_fn, _actor) constructor {
		
		path_data = _path_data;
		default_movement_speed = _default_movement_speed;
		end_action = _end_action;
		entity_previous_x = -1 //Used for determining enemy direction
		
		with(actor.inst) {
			path_start(other.path_data.default_path, other.default_movement_speed, other.end_action, false);
		}
		
		
		static execute = function() {	
			var movement_blocked = movement_blocked_fn();
			
			switch (movement_state) {
			    case MOVEMENT_STATE.FREE:
			        if(actor.inst.x > entity_previous_x) {
						actor.direction_facing = DIRECTION_RIGHT;
						actor.inst.image_xscale = DIRECTION_RIGHT;
					}
					if(actor.inst.x < entity_previous_x) {
						actor.direction_facing = DIRECTION_LEFT;
						actor.inst.image_xscale = DIRECTION_LEFT;
					}
					entity_previous_x = actor.inst.x;
					
					if(movement_blocked) {
						with(actor.inst) {
							path_speed = 0;
						}
						movement_state = MOVEMENT_STATE.BLOCKED;
					}
			        break;
				case MOVEMENT_STATE.BLOCKED:
					if(movement_blocked) {
						with(actor.inst) {
							path_speed = default_movement_speed; //TODO: Take into account buffs/debuffs (maybe write function to adjust this)
						}
						movement_state = MOVEMENT_STATE.BLOCKED;
					}
					break;
			    default:
			        break;
			}
		}
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
		
		round_manager = get_round_manager();
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
			if(round_manager.is_spawning_enemies()) { //Prevents waiting for timers to expire in between rounds
				timer++;
				ds_list_clear(entities_in_range);
			}
		}
		
		
		static on_health_reached_zero = function() {
			timer = 0;
		}
		
		
		static on_deletion = function() {
			ds_list_destroy(entities_in_range);
		}
}
#endregion


#region RapidDirectDamageAction (Class)
/*
	Similar to the DirectDamageAction, but will attack any valid unit as soon as possible, then put the attacked entity on a cooldown timer.
	Used for Butterfly-barian.
	
	Variables:
	frames_between_attacks: The number of frames that occur between one attack and the next
	attack_damage: How much damage the attack should do (for attacks that have configurable damage)
	effect: An effect that can be drawn on the enemy to indicate that a direct attack is occuring
	
	action_id and actor are the same as the base Action
*/
function RapidDirectDamageAction(_action_id, _valid_targets, _frames_between_attacks, _attack_damage, _effect_sprite = undefined, _actor = other) 
	: Action(_action_id, _actor) constructor {
		
		valid_targets = _valid_targets;
		frames_between_attacks = _frames_between_attacks; //Used for individual cooldowns instead
		attack_damage = _attack_damage;
		effect_sprite = _effect_sprite;
		
		round_manager = get_round_manager();
		entities_in_range = ds_list_create();
		attack_cooldowns = new EntityCooldownList();
		static targeting_params = new TargetingParams(true, false);
		
		
		static execute = function() {
			actor.range.get_entities_in_range(valid_targets, entities_in_range);
			if(ds_list_empty(entities_in_range)) { return; }
			
			var _do_attack_animation = false;
			for (var i = 0, len = ds_list_size(entities_in_range); i < len; ++i) {
				var _entity = entities_in_range[| i];
			    if(targeting_params.is_entity_valid_target(_entity) && !attack_cooldowns.is_entity_on_cooldown(_entity)) {
					_do_attack_animation = true;
					deal_damage(_entity, attack_damage);
					if(effect_sprite != undefined) {
						draw_damage_effect(_entity, effect_sprite);
					}
					attack_cooldowns.add_entity(_entity, frames_between_attacks);
				}
			}
			
			actor.direction_facing = get_entity_facing_direction(actor.inst, entities_in_range[| 0].x); //Just look at the first entity in the list
			actor.inst.image_xscale = actor.direction_facing; //Seperate variables for now just in case I want to do other things with direction_facing
			
			if(_do_attack_animation) {
				actor.animation_controller.set_animation("ATTACK");
			}
		}
		
		
		static update_params = function() {
			if(round_manager.is_spawning_enemies()) { //Prevents waiting for timers to expire in between rounds
				attack_cooldowns.tick();
			}
			ds_list_clear(entities_in_range);
		}
		
		
		static on_health_reached_zero = function() {
		}
		
		
		static on_deletion = function() {
			ds_list_destroy(entities_in_range);
		}
}
#endregion


//TODO: Add configurable pre-requisutes to actions (such as timer and health level pre-requisites) that can be passed
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
		
		round_manager = get_round_manager();
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
					target: _enemy_to_target, //Needed for homing projectiles
					x_speed: _vector[VEC_X] * projectile_data.travel_speed,
					y_speed: _vector[VEC_Y] * projectile_data.travel_speed,
					data: projectile_data //NOTE: Also includes travel speed not broken up + normalized
				});
					
			timer = 0;
		}
		
		
		static update_params = function() {
			if(round_manager.is_spawning_enemies()) { //Prevents waiting for timers to expire in between rounds
				timer++;
				ds_list_clear(entities_in_range);
			}
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
			if(!round_manager.is_spawning_enemies() || timer < frames_between_generation) { return; }
			
			global.player_money += amount_generated;
			timer = 0;
			
			actor.animation_controller.set_animation("GENERATE");
			//TODO: Make these sparkles configurable if need be
			part_particles_create(global.PARTICLE_SYSTEM,
				actor.inst.x + random_range(-TILE_SIZE/2 + 8, -TILE_SIZE/2 + 16),  actor.inst.y - random_range(16, 24),
				global.PARTICLE_SPARKLE, 1);
					
			part_particles_create(global.PARTICLE_SYSTEM,
				actor.inst.x + random_range(TILE_SIZE/2 - 16, TILE_SIZE/2 - 8),  actor.inst.y - random_range(20, 28),
				global.PARTICLE_SPARKLE, 1);
					
			part_particles_create(global.PARTICLE_SYSTEM,
				actor.inst.x + random_range(-4, 4),  actor.inst.y - random_range(32, 40),
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
