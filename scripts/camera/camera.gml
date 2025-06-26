/*
	camera.gml
	
	This file contains the Camera Controller, responsible for moving the viewport.
	The viewport can be moved either with the mouse keys, or 
*/


#region CameraController (Class)
#macro CAM_SCROLL_SPEED_PLAYER 4 //How many pixels the camera should move each frame (when controlled by the player)
#macro CAM_SCROLL_SPEED_AUTO 8 //How many pixels the camera should move each frame (when controlled by the game)
#macro CAM_NUM_SECONDS_HANGING_DEFAULT seconds_to_roomspeed_frames(2) //Default value for how many seconds should the camera stay frozen before switching modes

//Enums for when the camera should be movable by the player, and when it should be frozen
enum CAMERA_STATE {
	PLAYER_MOVABLE, //Can be moved by player
	SEQUENCE_MOVABLE, //Can't be moved by player (BUT can be moved by the game)
	FROZEN, //Can't be moved at all
}

//Enums for whether the sequence should be moving the camera, or it should be hanging
enum CAMERA_SEQUENCE_STATE {
	CAMERA_MOVING,
	CAMERA_HANGING
}

/*
	A data point refering to where the camera should go to in a sequence, alongside how long it should hold on said point before moving on to the next one.
*/
function CameraSequenceData(_dest_x, _dest_y, _seconds_to_hang = CAM_NUM_SECONDS_HANGING_DEFAULT) constructor {
	dest_x = _dest_x;
	dest_y = _dest_y;
	seconds_to_hang = _seconds_to_hang;
}

/*
*/
function CameraSequence(_initial_seconds_to_hang = CAM_NUM_SECONDS_HANGING_DEFAULT,
	_after_sequence_callback = function(){}) constructor {
	sequence_queue = []
	sequence_state = CAMERA_SEQUENCE_STATE.CAMERA_HANGING;
	after_sequence_callback = _after_sequence_callback;
	
	move_to_vector_x = 0; //Cached so it doesn't need to be recalculated every frame
	move_to_vector_y = 0; //Cached so it doesn't need to be recalculate every frame
	current_seconds_to_hang = _initial_seconds_to_hang
	hanging_timer = 0;
	
	
	//This data will be used to move the camera to a certain location when it's in AUTO_MOVABLE mode
	static add_location = function(_dest_x, _dest_y, _seconds_to_hang = CAM_NUM_SECONDS_HANGING_DEFAULT) {
		//Need to make sure they don't go beyond the level itself (hence the max and min checks)
		//Right and down checks subtract the width/height of the view since coordinates are based on the top-left corner of the camera
		//NOTE: I'm not caching these since they're only used once, and passing them through the camera manager would be ugly
		var _fixed_dest_x = max(0, min(_dest_x, room_width - camera_get_view_width(view_camera[0])));
		var _fixed_dest_y = max(0, min(_dest_y, room_height - camera_get_view_height(view_camera[0])));
		
		array_push(sequence_queue, new CameraSequenceData(_fixed_dest_x, _fixed_dest_y, _seconds_to_hang));
	}
	
	
	//Can use this to clear a queue, and hang on the current location for a set period of time
	static clear_queue = function(_hanging_time = 0) {
		array_delete(sequence_queue, 0, array_length(sequence_queue));
		sequence_state = CAMERA_SEQUENCE_STATE.CAMERA_HANGING;
		//TODO: Add a function that, if already in the hanging state, allow the hanging time to include the previously hung time? Or unnecessary?
		hanging_timer = 0;
		current_seconds_to_hang = _hanging_time;
	}
	
	
	//Will return "true" once the sequence has completed
	static advance_sequence = function() {
		switch (sequence_state) {
		    case CAMERA_SEQUENCE_STATE.CAMERA_HANGING:
		        if(current_seconds_to_hang < 0) { //Can use this to keep the camera frozen for an indefinite period of time
					return false;
				}
				hanging_timer++;
				if(hanging_timer >= current_seconds_to_hang) {
					hanging_timer = 0;
					//Currently, we assume that if the point queue is empty, we can give control back to the player
					//This assumption will probably change (ex. adding a "start" splash right before the level begins), but works for now
					if(array_length(sequence_queue) > 0) {
						//Need to initialize movement variables again for the next point
						var _move_to_vector = vector_to_get_components(camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), 
							sequence_queue[0].dest_x, sequence_queue[0].dest_y, true);
						move_to_vector_x = _move_to_vector[VEC_X] * CAM_SCROLL_SPEED_AUTO;
						move_to_vector_y = _move_to_vector[VEC_Y] * CAM_SCROLL_SPEED_AUTO;
						current_seconds_to_hang = sequence_queue[0].seconds_to_hang;
						
						sequence_state = CAMERA_SEQUENCE_STATE.CAMERA_MOVING;
					}
					else { //Sequence is done now, do whatever you need to do afterwards
						after_sequence_callback();
						return true;
					}
				}
		        break;
			case CAMERA_SEQUENCE_STATE.CAMERA_MOVING:
		        var _dest_x = sequence_queue[0].dest_x;
				var _dest_y = sequence_queue[0].dest_y;
				
				var _new_x = camera_get_view_x(view_camera[0]) + move_to_vector_x;
				var _new_y = camera_get_view_y(view_camera[0]) + move_to_vector_y;
				
				if(number_is_between(_dest_x, _new_x, camera_get_view_x(view_camera[0]))) { //For catching any rounding errors
					_new_x = _dest_x;
					move_to_vector_x = 0;
				}
				if(number_is_between(_dest_y, _new_y, camera_get_view_y(view_camera[0]))) { //For catching any rounding errors
					_new_y = _dest_y;
					move_to_vector_y = 0;
				}
				
				camera_set_view_pos(view_camera[0], _new_x, _new_y);
				if(_new_x == _dest_x && _new_y == _dest_y) { //We've reached the destination point
					move_to_vector_x = 0;
					move_to_vector_y = 0;
					array_shift(sequence_queue);
					sequence_state = CAMERA_SEQUENCE_STATE.CAMERA_HANGING;
				}
				break;
		    default:
		        break;
			return false;
		}
	}
}


/*
	The camera controller itself
*/
function CameraController() constructor {
	
	state = CAMERA_STATE.FROZEN;
	
	view_w = camera_get_view_width(view_camera[0]);
	view_h = camera_get_view_height(view_camera[0]);
	padding = view_h / 16; //Padding will be 1/16th the size of the screen's height (so 1/8th the height including both sides). Used height instead of width, since viewport height should be smaller and I don't want the camera to move around as much.
	
	current_sequence = new CameraSequence();
	after_sequence_callback = function(){};
	move_to_vector_x = 0;
	move_to_vector_y = 0;
	
	frozen_timer = 0;
	num_seconds_frozen = -1; //Start out with indefinite freeze, then switch to CAM_NUM_SECONDS_HANGING_DEFAULT when we want to start movement.
	

	//This data will be used to move the camera to a certain location when it's in SEQUENCE_MOVABLE mode
	static add_location_to_sequence = function(_dest_x, _dest_y, _seconds_to_hang = CAM_NUM_SECONDS_HANGING_DEFAULT) {
		current_sequence.add_location(_dest_x, _dest_y, _seconds_to_hang);
	}


	//This data will be used to move the camera so that a certain instance is centered when it's in SEQUENCE_MOVABLE mode
	static add_instance_location_to_sequence = function(_instance, _seconds_to_hang = CAM_NUM_SECONDS_HANGING_DEFAULT) {
		//Camera coordinates are based on the top-left position of the screen, so need to make adjustments based on that
		var _instance_camera_x = get_bbox_center_x(_instance) - view_w/2;
		var _instance_camera_y = get_bbox_center_y(_instance) - view_h/2;
		current_sequence.add_location(_instance_camera_x, _instance_camera_y, _seconds_to_hang);
	}
	
	//Revokes camera control from the player, and starts the current camera auto-movement sequence
	static start_current_sequence = function(_initial_seconds_to_hang = CAM_NUM_SECONDS_HANGING_DEFAULT, _after_sequence_callback = function(){}) {
		//Initialize camera sequence values
		current_sequence.current_seconds_to_hang = _initial_seconds_to_hang;
		current_sequence.after_sequence_callback = _after_sequence_callback;
		
		state = CAMERA_STATE.SEQUENCE_MOVABLE;
	}
	
	//Function responsible for performing all of the camera movement.
	static move_camera = function(_curr_game_state, _use_wasd = true, _use_mouse = false) {
		if(_curr_game_state == GAME_STATE.PAUSED) {
			return; //Don't allow camera updates while the game is paused.
		}
				
		switch (state) {
		    case CAMERA_STATE.SEQUENCE_MOVABLE: //Doesn't move at all
		        var _sequence_completed = current_sequence.advance_sequence();
				if(_sequence_completed) { //Give control back to the player once the sequence is done. TODO: Should this always be the case, or should this utilize the FROZEN state?
					state = CAMERA_STATE.PLAYER_MOVABLE;
				}
		        break;
			case CAMERA_STATE.PLAYER_MOVABLE: //Movable by the player
				var _view_x = camera_get_view_x(view_camera[0]);
				var _view_y = camera_get_view_y(view_camera[0]);

				var _new_x = _view_x;
				var _new_y = _view_y;

				if((_use_mouse && mouse_x <= _view_x + padding) || 
					(_use_wasd && keyboard_check(ord("A")))) { //Mouse is at or to the left of the screen or A is being pressed
					_new_x = max(0, _view_x - CAM_SCROLL_SPEED_PLAYER); //Don't want to go further left than 0;
				}
				else if((_use_mouse && mouse_x >= _view_x + view_w - padding) ||
					(_use_wasd && keyboard_check(ord("D")))) { //Mouse is at or to the right of the screen or D is being pressed
					_new_x = min(room_width - view_w, _view_x + CAM_SCROLL_SPEED_PLAYER); //Don't want to go further right than what the room can display
				}

				if((_use_mouse && mouse_y <= _view_y + padding) ||
					(_use_wasd && keyboard_check(ord("W")))) { //Mouse is at or to the top of the screen or W is being pressed
					_new_y = max(0, _view_y - CAM_SCROLL_SPEED_PLAYER); //Don't want to go further left than 0;
				}
				else if((_use_mouse && mouse_y >= _view_y + view_h - padding) ||
					(_use_wasd && keyboard_check(ord("S")))) { //Mouse is at or to the right of the screen or S is being pressed
					_new_y = min(room_height - view_h, _view_y + CAM_SCROLL_SPEED_PLAYER);
				}

				camera_set_view_pos(view_camera[0], _new_x, _new_y);
				break;
		    default:
		        break;
		}
			
		
	}
	
}
#endregion