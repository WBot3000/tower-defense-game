/// @description Initialize variables
current_round = 0; //Prior to starting a round
rounds_currently_running = [];

//Default value for "max_round"
if(!variable_instance_exists(self.id, "max_round")) {
	max_round = 3;
}

//Default value for "spawn_data"
if(!variable_instance_exists(self.id, "spawn_data")) {
	spawn_data = [];
}