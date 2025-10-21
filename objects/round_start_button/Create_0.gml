/// @description Initialize variables
event_inherited();
highlighted = false;
enabled = false;

//Cache these for easy access (start out as undefined since these are refreshed on room change)
game_state_manager = undefined;
round_manager = undefined;