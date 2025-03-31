/*
	conversions.gml
	
	This file contains various unit conversion functions.
	Primarily used so that variables can be set using more "human" units (ex. number of tiles and seconds) compared to the units GameMaker uses (ex. pixels and frames) 
	If a conversion changes, you can just change the function instead of changing everywhere where the conversion is needed.
*/


#region Distance Conversions
function tilesize_to_pixels(_num_tiles){
	return _num_tiles * TILE_SIZE;
}


function pixels_to_tilesize(_pixels) { //Inverse of tilesize_to_pixels
	return _pixels / TILE_SIZE;
}
#endregion


#region Time Conversions
function seconds_to_roomspeed_frames(_seconds) {
	return _seconds * game_get_speed(gamespeed_fps);
}


function roomspeed_frames_to_seconds(_room_speed_frames) { //Inverse of seconds_to_roomspeed_frames
	return _room_speed_frames / game_get_speed(gamespeed_fps);
}


function milliseconds_to_seconds(_milliseconds) { //Used for timers that utilize current_time instead of counters. Basically just dividing by 1000, but I felt like it should be encapsulated anyways.
	return _milliseconds/1000;
}


function seconds_to_milliseconds(_seconds) { //Basically just multiplying by 1000, but I felt like it should be encapsulated anyways.
	return _seconds*1000;
}


function seconds_to_microseconds(_seconds) { //Basically just multiplying by 1000000, but I felt like it should be encapsulated anyways.
	return _seconds*1000000;
}


function microseconds_to_milliseconds(_seconds) { //Basically just dividing by 1000, but I felt like it should be encapsulated anyways.
	return _seconds/1000;
}
#endregion