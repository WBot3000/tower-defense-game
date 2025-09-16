/// @description Declare variables and initiate moving
// TODO: Inherit from base enemy in case a value isn't defined?
entity_data = new GunBeetle();

current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;

set_facing_direction(DIRECTION_RIGHT);

attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;

//Variables to keep track of things
state_timer = 0;

entities_in_range = ds_list_create();
focused_entity = noone;

animation_bank = global.ANIMBANK_GUNBEETLE;
event_inherited();

path_start(path_data.default_path, entity_data.default_movement_speed, path_action_stop, false);
