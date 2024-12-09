/// @description Don't want to show highlight if a unit is already placed on this tile
// You can write your code in this editor

event_inherited();
if(placed_unit != noone) {
	highlight = noone
}
