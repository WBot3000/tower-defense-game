/*
This file contains code for handling room transition effects
*/
enum TRANSITION_STATE {
	FADING_IN,
	FADING_OUT,
	NOT_FADING
}

//Draws a fading transition on top of the screen
//TODO: Make this a UIComponent? On one hand, it isn't part of the overall hierarchy
//On the other hand, it IS part of the graphical display that isn't a direct element in the game
#macro FADING_RATE 0.025
function Transition(_starting_alpha = 1) constructor {
	alpha = _starting_alpha;
	state = TRANSITION_STATE.NOT_FADING;
	view_w =  camera_get_view_width(view_camera[0]);
	view_h = camera_get_view_height(view_camera[0]);
	
	static draw = function() {
		draw_set_alpha(alpha);
		draw_rectangle_color(0, 0, view_w, view_h, c_black, c_black, c_black, c_black, false);
		draw_set_alpha(1);
	}
	
	static fade_in = function() {
		state = TRANSITION_STATE.FADING_IN;
	}
	
	static fade_out = function() {
		state = TRANSITION_STATE.FADING_OUT;
	}
	
	//TODO: Can probably do an optimization here where this isn't called once the fading is done
	static on_step = function() {
		switch (state) {
		    case TRANSITION_STATE.FADING_IN:
		        alpha -= FADING_RATE;
				if(alpha <= 0) {
					state = TRANSITION_STATE.NOT_FADING;
				}
		        break;
			case TRANSITION_STATE.FADING_OUT:
				alpha += FADING_RATE;
				if(alpha >= 1) {
					state = TRANSITION_STATE.NOT_FADING;
				}
				break;
		    default:
		        break;
		}
	}
}