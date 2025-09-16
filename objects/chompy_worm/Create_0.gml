/// @description Initalize entity data and initiate moving

entity_data = new ChompyWorm();

current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;

set_facing_direction(DIRECTION_RIGHT);

//Variables to keep track of biting
attack_timer = 0;
entities_in_range = ds_list_create();

blocked = false;

animation_bank = global.ANIMBANK_CHOMPYWORM;
event_inherited();

path_start(path_data.default_path, entity_data.default_movement_speed, path_action_stop, false);