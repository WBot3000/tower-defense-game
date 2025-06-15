/// @description Initialize data structures
state = CLOUD_STATE.TRAVELING_TO_TARGET;

linger_timer = 0;
damage_timer = 0;

seconds_to_linger = seconds_to_roomspeed_frames(8); //TODO: Make configurable
seconds_to_damage = seconds_to_roomspeed_frames(1);

enemies_in_range = ds_list_create();