/// @description Initalize entity data and initiate moving

entity_data = new Butterflybarian();

current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;

entity_attack_cooldown_queue = new EntityCooldownList();

set_facing_direction(DIRECTION_RIGHT);

animation_bank = global.ANIMBANK_BUTTERFLYBARIAN;

event_inherited();

//movement_controller = new EnemyPathMovementController(self);
movement_controller.start_movement();