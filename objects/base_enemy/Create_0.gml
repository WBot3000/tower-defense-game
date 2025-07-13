///@description Declare variables and initiate moving
if(!variable_instance_exists(self, "enemy_data_type")) {
	throw "Enemy data type not specified when attempting to spawn an enemy!"
}

entity_data = new enemy_data_type(path_data, round_spawned_in);
path_start(path_data.default_path, entity_data.default_movement_speed, path_action_stop, false);