/// @description (DEBUG) Set fullscreen

//(OLD DEBUG) Start another round. WILL GO ONCE AN ACTUAL BUTTON IS IMPLEMENTED.
/*
if(music_manager.current_music == Music_PreRound) {
	music_manager.fade_out_current_music(seconds_to_milliseconds(QUICK_MUSIC_FADING_TIME), Music_Round);
}
round_manager.start_round();
*/

window_set_fullscreen(!window_get_fullscreen());