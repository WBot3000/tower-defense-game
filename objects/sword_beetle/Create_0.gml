/// @description Declare variables and initiate moving

entity_data = new SwordBeetle();

current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;
blocked = false;

//Variables to keep track of biting
attack_timer = 0;

set_facing_direction(DIRECTION_RIGHT);

animation_bank = global.ANIMBANK_SWORDBEETLE;

event_inherited();

//movement_controller = new EnemyPathMovementController(self);
movement_controller.start_movement();