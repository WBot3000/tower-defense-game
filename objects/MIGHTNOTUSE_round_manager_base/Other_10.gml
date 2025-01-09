/// @description Start a new round
if(current_round >= max_round) { //Don't exceed max round;
	exit;
}
var _new_round_data = new Round(spawn_data[current_round], 0, on_round_finish_callback);
array_push(rounds_currently_running, _new_round_data);
current_round++;