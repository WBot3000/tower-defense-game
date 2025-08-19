/// @description Declare variables and initiate moving
// TODO: Inherit from base enemy in case a value isn't defined?
entity_data = new GunBeetle();

current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;

set_facing_direction(DIRECTION_RIGHT);

if(!variable_instance_exists(self.id, "path_data")) { //If the enemy wasn't given a movement path upon creation, just have it stay still. Shouldn't occur during normal gameplay.
	path_data = global.DATA_LEVEL_PATH_DUMMYPATH;
}

attack_state = ENEMY_ATTACKING_STATE.NOT_ATTACKING;

buffs = [];

//Variables to keep track of things
state_timer = 0;

entities_in_range = ds_list_create();
focused_entity = noone;

path_start(path_data.default_path, entity_data.default_movement_speed, path_action_stop, false);
