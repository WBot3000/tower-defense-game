/// @description Insert description here
// You can write your code in this editor


var _view_x = camera_get_view_x(view_camera[0]);
var _view_y = camera_get_view_y(view_camera[0]);

//TODO: Might want to put these in a seperate file. These should really only need to be recalculated when the screen changes size
var _view_w = camera_get_view_width(view_camera[0]);
var _view_h = camera_get_view_height(view_camera[0]);

//Padding will be 1/8th the size of the screen's height (so 1/4th the height including both sides). Used height instead of width, since viewport height should be smaller and I don't want the camera to move around as much.
var _padding = _view_h / 8;

var _new_x = _view_x;
var _new_y = _view_y;

if(mouse_x <= _view_x + _padding) { //Mouse is at or to the left of the screen
	_new_x = max(0, _view_x - CAM_SCROLL_SPEED); //Don't want to go further left than 0;
}
else if(mouse_x >= _view_x + _view_w - _padding) { //Mouse is at or to the right of the screen
	_new_x = min(room_width - _view_w, _view_x + CAM_SCROLL_SPEED); //Don't want to go further right than what the room can display
}

if(mouse_y <= _view_y + _padding) { //Mouse is at or to the top of the screen
	_new_y = max(0, _view_y - CAM_SCROLL_SPEED); //Don't want to go further left than 0;
}
else if(mouse_y >= _view_y + _view_h - _padding) { //Mouse is at or to the right of the screen
	_new_y = min(room_height - _view_h, _view_y + CAM_SCROLL_SPEED);
}

camera_set_view_pos(view_camera[0], _new_x, _new_y);