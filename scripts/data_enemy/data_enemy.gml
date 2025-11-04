//Ignore most of this for now.

/*
	data_enemy.gml
	
	This file contains data for all the different types of enemies in the game.
	Sometimes, we might need to refer to some stats that an enemy has before initializing any instances of that enemy (ex. looking at an enemy descriptions)
	This data can be used to refer to enemies in these instances.
	This data is also used when the corresponding enemy is created
*/
enum MOVEMENT_STATE {
	UNIMPEDED,
	BLOCKED,
	IN_KNOCKBACK
}

//In pixels/second
#macro KNOCKBACK_SPEED -3

//Used to control how enemies should be moving at any given instance
//Currently assumes a path is being used, but this should be changed
function EnemyMovementController(_owner = other) constructor {
	owner = _owner;
	state = MOVEMENT_STATE.UNIMPEDED;
	
	//Unimpeded
	unimpeded_movement_speed = _owner.entity_data.default_movement_speed;
	
	//Blocked
	current_obstruction = noone; //Need to keep track of this in the event the enemy is knocked away from a blocked state (need to unregister the event)
	
	//Knocked Back
	knockback_timer = 0;
	
	static on_step = function() {
		with(owner) {
			switch (other.state) {
			    case MOVEMENT_STATE.UNIMPEDED:
			        //Check for potential obstructions
					//If obstruction exists, set state to BLOCKED, and stop any movement
					if(entity_data.immune_to_block) { return; }
					instance_place_list(x, y, base_unit, entities_in_range, true);
					for (var i = 0, len = ds_list_size(entities_in_range); i < len; ++i) {
					    var _unit = entities_in_range[| i];
						if(_unit.entity_data.can_block && _unit.health_state == HEALTH_STATE.ACTIVE) {
							other.block_movement();
						
							add_broadcast_subscriber(_unit, EVENT_END_BLOCK, function(args) {
								var _blocker = args[0];
								movement_controller.state = MOVEMENT_STATE.UNIMPEDED;
								movement_controller.current_obstruction = noone;
								movement_controller.start_movement();
							}, true, self);
						
							other.current_obstruction = _unit;
							other.state = MOVEMENT_STATE.BLOCKED;
							break;
						}
					}
					ds_list_clear(entities_in_range)
			        break;
				case MOVEMENT_STATE.BLOCKED:
					//I don't think you actually have to do anything here lol
					break;
				case MOVEMENT_STATE.IN_KNOCKBACK:
					//Decrement knockback timer, and if the timer reaches zero, then go back into the unimpeded state
					if(path_position == 0) {
						path_speed = 0;
					}
					else {
						path_speed = KNOCKBACK_SPEED;
					}
					other.knockback_timer--;
					if(other.knockback_timer <= 0) { //In case of any shenanigans
						other.knockback_timer = 0;
						other.state = MOVEMENT_STATE.UNIMPEDED;
						//TODO: Also re-initialize path movement
						other.start_movement();
					}
					break;
			    default:
			        break;
			}
		}
	}
	
	
	static start_movement = function(){}; //Depends on what the entity uses to move.
	
	static retrigger_speed_calculation = function(){}; //Depends on what the entity uses to move. Useful for applying/removing buffs for things like path-based units
	
	static block_movement = function(){}; //Depends on what the entity uses to move. NOTE: Don't use to change state, that's done automatically in the on step function
	
	static initiate_knockback = function(){}; //Depends on what the entity uses to move
	
	static add_knockback = function(_frames_of_knockback) {
		if(state != MOVEMENT_STATE.IN_KNOCKBACK) {
			state = MOVEMENT_STATE.IN_KNOCKBACK;
			if(current_obstruction != noone) {
				remove_broadcast_subscriber(current_obstruction, EVENT_END_BLOCK, owner);
				current_obstruction = noone;
			}
			initiate_knockback();
		}
		knockback_timer += _frames_of_knockback;
	}; 
}


function EnemyPathMovementController(_owner = other) : EnemyMovementController(_owner) constructor {
	
	static start_movement = function() {
		with(owner) {
			if(path_index == -1) {
				path_start(path_data.default_path, 
					entity_data.default_movement_speed * stat_multipliers[STATS.MOVEMENT_SPEED], 
					path_action_stop, false);
			}
			else {
				path_speed = entity_data.default_movement_speed * stat_multipliers[STATS.MOVEMENT_SPEED];
			}
		}
	}
	
	
	static retrigger_speed_calculation = function() { //Call this after modifying the stat multipliers
		with(owner) {
			path_speed = entity_data.default_movement_speed * stat_multipliers[STATS.MOVEMENT_SPEED];
		}
	}
	
	
	static block_movement = function() {
		with(owner) {
			path_speed = 0;
		}
	}
	
	
	static initiate_knockback = function() {
		with(owner) {
			path_speed = KNOCKBACK_SPEED //Tinker with this value a bit to see what works best
		}
	}
	
}


/*
	Data that all enemies should have
	max_health: The maximum amount of health this enemy normally has
	current_health: The health that the enemy is currently has. Normally initialized to the same value as max_health.
	monetary_value: The amount of money this enemy gives upon defeat
	movement_controller_type: Determines what kind of movement controller the enemy uses.
	movement_path: The path that the enemy follows. Usually given to the enemy by a spawner.
	movement_speed: How quickly the enemy moves along it's given path
	round_spawned_in: A pointer to the Round object that spawned the enemy. Needed to call back into the round when it gets destroyed
	enemy_buffs: An array of all the buffs/debuffs the enemy has
*/
function EnemyData(_path_data, _round_spawned_in) : CombatantData() constructor {
	
	movement_controller_type = EnemyMovementController;
	path_data = _path_data;
	default_movement_speed = 1.5;
	immune_to_block = false;
	
	round_spawned_in = _round_spawned_in
	monetary_value = 50;
	
}


function get_enemy_path_direction(_enemy) {
	//var _enemy_current_x = _enemy.x;//path_get_x(_enemy.path_data.default_path, _enemy.path_position);
	//var _enemy_previous_x = path_get_x(_enemy.path_data.default_path, _enemy.path_positionprevious);
	
	if(_enemy.x > _enemy.xprevious) {
		return DIRECTION_RIGHT;
	}
	if(_enemy.x < _enemy.xprevious) {
		return DIRECTION_LEFT;
	}
	if(variable_instance_exists(_enemy.id, "direction_facing")) {
		return _enemy.direction_facing;
	}
	return undefined;
}

//So I don't have to write a stop_moving_func for all basic enemies.
//NOTE: You need to use the method function to bind this to an Enemy class, otherwise this won't work.
function enemy_standard_path_stop_moving_func() {
	if(inst.path_index == -1) { return; }
	var next_position_in_pixels = (inst.path_position * path_get_length(inst.path_index)) + inst.path_speed;
	var next_position_normalized = next_position_in_pixels / path_get_length(inst.path_index);
	
	//Need to add spawn position, because path_get_x/y assumes origin is (0, 0)
	var next_x = path_get_x(inst.path_index, next_position_normalized) + path_data.spawn_x;
	var next_y = path_get_y(inst.path_index, next_position_normalized) + path_data.spawn_y;
	var entity_at_position = instance_position(next_x, next_y, base_unit);
	
	return (entity_at_position != noone && entity_at_position.entity_data.can_block)
}