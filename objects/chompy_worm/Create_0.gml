/// @description Initalize entity data and initiate moving

entity_data = new ChompyWorm();

current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;
movement_state = MOVEMENT_STATE.UNIMPEDED;

set_facing_direction(DIRECTION_RIGHT);

//Variables to keep track of biting
attack_timer = 0;

blocked = false;

animation_bank = global.ANIMBANK_CHOMPYWORM;

event_inherited();

//movement_controller = new EnemyPathMovementController(self);

movement_controller.start_movement();