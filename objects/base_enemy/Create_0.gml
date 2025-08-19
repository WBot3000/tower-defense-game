///@description Declare variables and initiate moving
if(!variable_instance_exists(self, "enemy_data_type")) {
	throw "Enemy data type not specified when attempting to spawn an enemy!"
}

if(!variable_instance_exists(self, "path_data")) {
	show_debug_message("Enemy " + string(self.id) + " created with no path data");
	path_data = global.DATA_LEVEL_PATH_DUMMYPATH;
}

if(!variable_instance_exists(self, "round_spawned_in")) {
	show_debug_message("Enemy " + string(self.id) + " created with no round spawn data");
}

entity_data = new enemy_data_type(path_data, round_spawned_in);