/// @description Declare variables and initiate moving

entity_data = new KingWorm();

current_health = entity_data.max_health/2;
health_state = HEALTH_STATE.ACTIVE;

set_facing_direction(DIRECTION_RIGHT);

buffs = []


attack_timer = 0;
wormhole_timer = seconds_to_roomspeed_frames(20); //Spawn the first worm hole soon after losing the health

units_in_range = ds_list_create();
targets_in_range = ds_list_create();

path_start(path_data.default_path, entity_data.default_movement_speed, path_action_stop, false);
