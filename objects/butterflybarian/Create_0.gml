/// @description Initalize entity data and initiate moving

entity_data = new Butterflybarian();

current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;

entities_in_range = ds_list_create();
entity_attack_cooldown_queue = new EntityCooldownList();

set_facing_direction(DIRECTION_RIGHT);

animation_bank = global.ANIMBANK_BUTTERFLYBARIAN;
event_inherited();

path_start(path_data.default_path, entity_data.default_movement_speed, path_action_stop, false);