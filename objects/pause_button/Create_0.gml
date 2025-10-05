/// @description Initialize variables
event_inherited();
highlighted = false;
enabled = false;

game_state_manager = get_game_state_manager(); //Cache this for easy access
if(game_state_manager != undefined) {
	enabled = true;
}