/*
	camera.gml
	This file contains the Camera Controller, responsible for moving the viewport.
	The viewport can be moved either with the mouse keys, or 
*/


#region CameraController (Class)
//How many pixels the camera should move each frame
#macro CAM_SCROLL_SPEED 4

//Enums for when the camera should be movable, and when it should be frozen
enum CAMERA_STATE {
	CAMERA_MOVABLE,
	CAMERA_FROZEN
}


/*
	The camera controller itself
*/
function CameraController() constructor {
	
	static move_camera = function(_use_mouse = true, _use_wasd = true) {
		var _view_x = camera_get_view_x(view_camera[0]);
		var _view_y = camera_get_view_y(view_camera[0]);

		//TODO: Might want to put these in a seperate file. These should really only need to be recalculated when the screen changes size
		var _view_w = camera_get_view_width(view_camera[0]);
		var _view_h = camera_get_view_height(view_camera[0]);

		//Padding will be 1/16th the size of the screen's height (so 1/8th the height including both sides). Used height instead of width, since viewport height should be smaller and I don't want the camera to move around as much.
		var _padding = _view_h / 16;

		var _new_x = _view_x;
		var _new_y = _view_y;

		if((_use_mouse && mouse_x <= _view_x + _padding) || 
			(_use_wasd && keyboard_check(ord("A")))) { //Mouse is at or to the left of the screen or A is being pressed
			_new_x = max(0, _view_x - CAM_SCROLL_SPEED); //Don't want to go further left than 0;
		}
		else if((_use_mouse && mouse_x >= _view_x + _view_w - _padding) ||
			(_use_wasd && keyboard_check(ord("D")))) { //Mouse is at or to the right of the screen or D is being pressed
			_new_x = min(room_width - _view_w, _view_x + CAM_SCROLL_SPEED); //Don't want to go further right than what the room can display
		}

		if((_use_mouse && mouse_y <= _view_y + _padding) ||
			(_use_wasd && keyboard_check(ord("W")))) { //Mouse is at or to the top of the screen or W is being pressed
			_new_y = max(0, _view_y - CAM_SCROLL_SPEED); //Don't want to go further left than 0;
		}
		else if((_use_mouse && mouse_y >= _view_y + _view_h - _padding) ||
			(_use_wasd && keyboard_check(ord("S")))) { //Mouse is at or to the right of the screen or S is being pressed
			_new_y = min(room_height - _view_h, _view_y + CAM_SCROLL_SPEED);
		}

		camera_set_view_pos(view_camera[0], _new_x, _new_y);
	}
	
}
#endregion