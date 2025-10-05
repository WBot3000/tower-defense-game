/// @description Initialize variables
event_inherited();
highlighted = false;
enabled = false;

round_manager = get_round_manager(); //Cache this for easy access
if(round_manager != undefined) {
	enabled = true;
}