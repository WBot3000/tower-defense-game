/// @description Initialize variables
left_bound = x - camera_get_view_x(view_camera[0]); //Adjust position for GUI
right_bound = left_bound + sprite_width;
//Where the nob should be drawn
nob_x = map_value(default_value, 0, 100, left_bound, right_bound);

held = false;
highlighted = false;
