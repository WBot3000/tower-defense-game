/*
	music.gml
	This file contains the code for the MusicManager, responsible for playing the appropriate music for the appropriate situation, alongside appropriate effects to music.
		ex) Fading out a song before playing another one.

	TODO: Should there be something for sound effects too? Don't want to overcomplicate sound effects.
*/


#region MusicManager (Class)
#macro QUICK_MUSIC_FADING_TIME 0.5 //Number of seconds it takes for music to fade in and out (quickly).
#macro MUSIC_FADING_TIME 1 //Number of seconds it takes for music to fade in and out.
#macro MAX_AUDIO_PRIORITY 9999 //Used to give highest priority to music.
/*
	The MusicManager as explained above
	
	current_music: The song that's currently playing. Useful for checking what song is currently playing.
	current_music_ref: Reference to the current music that's playing.
	volume: The volume that the music is playing at. Ranges from 0 to 1 (0% to 100%).
	fading_out: Used to keep track of whether the current music is fading out (as opposed to it just being muted).
	fading_time: The number of milliseconds that it'll take to perform any fading out.
	fading_start: Used to keep track of how long any fading has been going on for
	- Because audio_sound_gain applies immediately, we can't use audio_sound_get_gain to keep track of how "quiet" the sound is, so we need this instead.
	next_music: The song to play after the current song has faded out. Not necessary if the track should switch immediately.
	
	TODO: Currently, this assumes that all music should loop. Should add support for non-looping music.
*/
function MusicManager(_initial_music, _initial_volume = 1) constructor {
	current_music = _initial_music;
	current_music_ref = -1;
	volume = _initial_volume
	if(_initial_music != undefined) {
		current_music_ref = audio_play_sound(_initial_music, MAX_AUDIO_PRIORITY, true, volume);
	}
	
	fading_out = false;
	fading_time = -1;
	fading_start = -1;
	next_music = undefined;
	
	static set_music = function(_new_music) {
		audio_stop_sound(current_music_ref);
		current_music_ref = audio_play_sound(_new_music, MAX_AUDIO_PRIORITY, true);
	}
	
	
	static set_volume = function(_new_volume) {
		volume = _new_volume;
		if(current_music_ref != -1) {
			audio_sound_gain(current_music_ref, volume, 0);
		}
	}
	
	
	static fade_out_current_music = function(_fading_time = MUSIC_FADING_TIME, _next_music = undefined) {
		fading_out = true;
		fading_time = _fading_time
		next_music = _next_music;
		audio_sound_gain(current_music_ref, 0, _fading_time);
		fading_start = get_timer();
	}
	
	
	static on_step = function() {
		if(fading_out && microseconds_to_milliseconds(get_timer() - fading_start) >= fading_time) {
			audio_stop_sound(current_music_ref);
			fading_out = false;
			fading_time = -1;
			fading_start = -1;
			if(next_music != undefined) {
				current_music = next_music;
				current_music_ref = audio_play_sound(next_music, MAX_AUDIO_PRIORITY, true, volume);
				next_music = undefined;
			}
			else {
				current_music = undefined;
			}
		}
	}
}
#endregion