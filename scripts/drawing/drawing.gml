/*
	drawing.gml
	
	This file contains functions for drawing things to the screen that don't logically fit in any other file or class.
*/


#region draw_health_bar (Function)
//Draw health bars for units and enemies
//NOTE: Since health bar's origin is center-bottom, the x coordinate is where you want to draw the CENTER of the healthbar, while the y is where you want to draw the bottom
function draw_health_bar(_x, _y, _current_health, _max_health, recovering_from_ko = false){
	//Error prevention in the event the unit or enemy has 0 max health (should only be true in base objects, which shouldn't ever be instantiated anyways, but still good to check)
	if(_max_health > 0) {
		//Draw health bar sprite
		draw_sprite(spr_health_bar, 1, _x, _y);

		//Don't want the health bar to overflow in the event the entity's current health exceeds it's normal max health
		//Also don't want it to underflow if the entity (somehow) gets negative health
		//Enemy health casted to real so that division isn't integer division
		var _percent_health_remaining = max(min(1, real(_current_health) / _max_health), 0);
	
		var _spr_health_bar_width = sprite_get_width(spr_health_bar)
		//X-coordinate of the left bound of the health bar (+2 because the border is 2 pixels)
		var _health_bar_left_bound = _x - (_spr_health_bar_width/2) + 2;
		//Right bound is same as left bound, but now you need to add the extra length and subtract the border (-3 because this draws at the end? of the pixel)
		var _health_bar_right_bound = _x + (_spr_health_bar_width/2) - 3;
	
		//Where to draw the green part of the health bar up to
		var _health_bar_at = map_value(_percent_health_remaining, 0, 1, _health_bar_left_bound, _health_bar_right_bound);

		//Additions to y are also due to sprite borders (maybe make these seem less arbitrary)
		if(recovering_from_ko) {
			draw_rectangle_color(_health_bar_left_bound, _y - 6, _health_bar_at, _y - 3, c_yellow, c_yellow, c_yellow, c_yellow, false);
		}
		else {
			draw_rectangle_color(_health_bar_left_bound, _y - 6, _health_bar_at, _y - 3, c_green, c_green, c_green, c_green, false);
		}
	}
}
#endregion


#region draw_health_bar_target (Function)
//Draw the larger health bar used for targets
//NOTE: Just like the normal health bar, this health bar's origin is center-bottom
function draw_health_bar_target(x, y, _current_health, _max_health){
	//Error prevention in the event the target has 0 max health (should only be true in base objects, which shouldn't ever be instantiated anyways, but still good to check)
	if(_max_health > 0) {
		//Draw health bar sprite
		draw_sprite(spr_health_bar_target, 1, x, y);

		//Don't want the health bar to overflow in the event the entity's current health exceeds it's normal max health
		//Also don't want it to underflow if the entity (somehow) gets negative health
		//Enemy health casted to real so that division isn't integer division
		var _percent_health_remaining = max(min(1, real(_current_health) / _max_health), 0);
	
		var _spr_health_bar_width = sprite_get_width(spr_health_bar_target)
		//X-coordinate of the left bound of the health bar (+4 because the border is 4 pixels)
		var _health_bar_left_bound = x - (_spr_health_bar_width/2) + 4;
		//Right bound is same as left bound, but now you need to add the extra length and subtract the border (-5 because this draws at the end? of the pixel)
		var _health_bar_right_bound = x + (_spr_health_bar_width/2) - 5;
	
		//Where to draw the green part of the health bar up to
		var _health_bar_at = map_value(_percent_health_remaining, 0, 1, _health_bar_left_bound, _health_bar_right_bound);

		//Additions to y are also due to sprite borders (maybe make these seem less arbitrary)
		draw_rectangle_color(_health_bar_left_bound, y - 12, _health_bar_at, y - 5, c_teal, c_teal, c_teal, c_teal, false);
	}
}
#endregion


#region draw_damage_effect (Function)
//Used to draw sprites indicating damage. These will draw at a random location on the entity
//Unlike all the other functions, this actually creates an object instance, since it was the simplest way to accomplish this.
function draw_damage_effect(_entity_to_draw_on, _sprite_to_draw) {
	var _draw_x_pos = irandom_range(_entity_to_draw_on.bbox_left + 4, _entity_to_draw_on.bbox_right - 4); //+4 is so that the effect stays closer to the center of the entity's sprite
	var _draw_y_pos = irandom_range(_entity_to_draw_on.bbox_top + 4, _entity_to_draw_on.bbox_bottom - 4);
	instance_create_layer(_draw_x_pos, _draw_y_pos, PROJECTILE_LAYER, visual_effect, {
		sprite_index: _sprite_to_draw,
		entity_to_follow: _entity_to_draw_on
	});
}
#endregion

//TODO: Might move this to the menus_and_ui script, but not 100% about every single application of this, plus that file's getting huge and this component doesn't have any interactable parts.
#region draw_highlight_info (Function)
//TODO: For macros that rely on calculated values that shouldn't change, find a good way to get the value once, then cache it
//TODO: Take into account these values, and then adjust strings based on them
#macro MIN_HIGHLIGHT_WIDTH	(camera_get_view_width(view_camera[0]) / 16)
#macro MAX_HIGLIGHT_WIDTH	(camera_get_view_width(view_camera[0]) / 8)
#macro HIGHLIGHT_PADDING (camera_get_view_width(view_camera[0]) / 32)

#macro HIGHLIGHT_HEIGHT (camera_get_view_width(view_camera[0]) / 16)

function draw_highlight_info(_title = "No Title", _description = "No description given") {
	var _title_width = string_width(_title);
	var _description_width = string_width(_description);
	
	var _highlight_width = max(_title_width, _description_width) + HIGHLIGHT_PADDING; //+ is for extra padding
	
	draw_set_halign(fa_center);
	
	draw_rectangle_color(device_mouse_x_to_gui(0) - _highlight_width/2, 
						device_mouse_y_to_gui(0) - (HIGHLIGHT_HEIGHT + 30),
						device_mouse_x_to_gui(0) + _highlight_width/2,
						device_mouse_y_to_gui(0) - 2,
						c_black, c_black, c_black, c_black, false);
						
	draw_text_color(device_mouse_x_to_gui(0), 
					device_mouse_y_to_gui(0) - (HIGHLIGHT_HEIGHT + 24),
					_title, c_white, c_white, c_white, c_white, 1);
					
	draw_text_color(device_mouse_x_to_gui(0), 
					device_mouse_y_to_gui(0) - (HIGHLIGHT_HEIGHT + 4),
					_description, c_white, c_white, c_white, c_white, 1);		
	
	draw_set_halign(fa_left);
}
#endregion