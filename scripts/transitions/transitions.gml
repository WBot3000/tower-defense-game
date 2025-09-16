/*
This file contains code for handling room transition effects
*/
enum TRANSITION_STATE {
	ROOM_IN,
	ROOM_OUT,
	NOT_TRANSITIONING,
	POST_TRANSITION_DELAY
}

#macro TRANSITION_DEFAULT_CALL_DELAY seconds_to_roomspeed_frames(0.25)

//Draws a fading transition on top of the screen
#macro FADING_RATE 0.05
function FadeTransition(_starting_alpha = 1, _post_transition_delay = TRANSITION_DEFAULT_CALL_DELAY) constructor {
	alpha = _starting_alpha;
	state = TRANSITION_STATE.NOT_TRANSITIONING;
	view_w =  camera_get_view_width(view_camera[0]);
	view_h = camera_get_view_height(view_camera[0]);
	
	call_fn = function() {};
	post_transition_delay = _post_transition_delay;
	delay_timer = 0;
	
	static draw = function() {
		draw_set_alpha(alpha);
		draw_rectangle_color(0, 0, view_w, view_h, c_black, c_black, c_black, c_black, false);
		draw_set_alpha(1);
	}
	
	static transition_in = function(_on_fade_in_complete_fn = undefined) {
		state = TRANSITION_STATE.ROOM_IN;
		if(_on_fade_in_complete_fn != undefined) {
			call_fn = _on_fade_in_complete_fn;
		}
	}
	
	static transition_out = function(_on_fade_out_complete_fn = undefined) {
		state = TRANSITION_STATE.ROOM_OUT;
		if(_on_fade_out_complete_fn != undefined) {
			call_fn = _on_fade_out_complete_fn;
		}
	}
	
	//TODO: Can probably do an optimization here where this isn't called once the fading is done
	static on_step = function() {
		switch (state) {
		    case TRANSITION_STATE.ROOM_IN:
		        alpha -= FADING_RATE;
				if(alpha <= 0) {
					if(post_transition_delay > 0) {
						state = TRANSITION_STATE.POST_TRANSITION_DELAY;
					}
					else {
						state = TRANSITION_STATE.NOT_TRANSITIONING;
						call_fn();
					}
				}
		        break;
			case TRANSITION_STATE.ROOM_OUT:
				alpha += FADING_RATE;
				if(alpha >= 1) {
					if(post_transition_delay > 0) {
						state = TRANSITION_STATE.POST_TRANSITION_DELAY;
					}
					else {
						state = TRANSITION_STATE.NOT_TRANSITIONING;
						call_fn();
					}
				}
				break;
			case TRANSITION_STATE.POST_TRANSITION_DELAY:
				delay_timer++;
				if(delay_timer >= post_transition_delay) {
					delay_timer = 0;
					call_fn();
					state = TRANSITION_STATE.NOT_TRANSITIONING;
				}
				break;
		    default:
		        break;
		}
	}
}


//Draws a swiping transition on top of the screen
#macro SWIPE_RATE 40
function SwipeTransition(_start_with_black = true, _post_transition_delay = TRANSITION_DEFAULT_CALL_DELAY) constructor {
	state = TRANSITION_STATE.NOT_TRANSITIONING;
	view_w =  camera_get_view_width(view_camera[0]);
	view_h = camera_get_view_height(view_camera[0]);
	
	//If you use 0 when you don't want to see any black, you'll get a tiny black sliver on the left of the screen
	x_left = _start_with_black ? 0 : -1;
	x_right = _start_with_black ? view_w : -1;
	
	call_fn = function() {};
	post_transition_delay = _post_transition_delay;
	delay_timer = 0;
	
	static draw = function() {
		draw_rectangle_color(x_left, 0, x_right, view_h, c_black, c_black, c_black, c_black, false);
		draw_set_alpha(1);
	}
	
	static transition_in = function(_on_fade_in_complete_fn = undefined) {
		state = TRANSITION_STATE.ROOM_IN;
		x_left = 0;
		x_right = view_w;
		if(_on_fade_in_complete_fn != undefined) {
			call_fn = _on_fade_in_complete_fn;
		}
	}
	
	static transition_out = function(_on_fade_out_complete_fn = undefined) {
		state = TRANSITION_STATE.ROOM_OUT;
		x_left = view_w;
		x_right = view_w;
		if(_on_fade_out_complete_fn != undefined) {
			call_fn = _on_fade_out_complete_fn;
		}
	}
	
	//TODO: Can probably do an optimization here where this isn't called once the fading is done
	static on_step = function() {
		switch (state) {
		    case TRANSITION_STATE.ROOM_IN:
		        x_right -= SWIPE_RATE;
				if(x_right < 0) {
					x_left = -1;
					if(post_transition_delay > 0) {
						state = TRANSITION_STATE.POST_TRANSITION_DELAY;
					}
					else {
						state = TRANSITION_STATE.NOT_TRANSITIONING;
						call_fn();
					}
				}
		        break;
			case TRANSITION_STATE.ROOM_OUT:
				x_left -= SWIPE_RATE;
				if(x_left <= 0) {
					if(post_transition_delay > 0) {
						state = TRANSITION_STATE.POST_TRANSITION_DELAY;
					}
					else {
						state = TRANSITION_STATE.NOT_TRANSITIONING;
						call_fn();
					}
				}
				break;
			case TRANSITION_STATE.POST_TRANSITION_DELAY:
				delay_timer++;
				if(delay_timer >= post_transition_delay) {
					delay_timer = 0;
					call_fn();
					state = TRANSITION_STATE.NOT_TRANSITIONING;
				}
				break;
		    default:
		        break;
		}
	}
}

//Yay globals... (Should try and figure out another way to do this)
global.UPCOMING_ROOM = undefined
global.POST_TRANSITION_CALLBACK = function(){}
function create_room_transition(_room_to_enter, _start_transition, _end_transition, _post_transition_callback = function(){} ) {
	global.UPCOMING_ROOM = _room_to_enter;
	global.POST_TRANSITION_CALLBACK = _post_transition_callback;
	layer_sequence_create(TRANSITION_LAYER, 0, 0, _start_transition);
	layer_set_target_room(global.UPCOMING_ROOM);
	layer_sequence_create(TRANSITION_LAYER, 0, 0, _end_transition);
	layer_reset_target_room();
}

function transition_room_transfer() {
	room_goto(global.UPCOMING_ROOM)
	global.UPCOMING_ROOM = undefined;
}

function post_transition_callback() {
	var _callback = global.POST_TRANSITION_CALLBACK;
	_callback();
	global.POST_TRANSITION_CALLBACK = function(){};
}