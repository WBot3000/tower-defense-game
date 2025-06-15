/*
	drawing.gml
	
	This file contains functions for drawing things to the screen that don't logically fit in any other file or class.
	Most of this is done in "Draw" events, though the visual effects have their own objects becauseu
*/
#region draw_set_alignments
//Just a wrapper around draw_set_halign and draw_set_valign so you can assign them both at once
//Call this without any arguments to reset them back to the default
function draw_set_alignments(_horizontal = fa_left, _vertical = fa_top) {
	draw_set_halign(_horizontal);
	draw_set_valign(_vertical);
}
#endregion


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


#region Visual Effect Enums
//Enums for fading out visual effects
enum VISUAL_EFFECT_STATUS {
	STILL,
	ROOM_OUT
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


#region initialize_digit_particle
//TODO: Currently for increases in money, make this more general or add different functions (ex. if we want an effect for losing money too)
function initialize_digit_particles(digit_particle_refs) {
	var _digit_particle_sprites = [spr_digit_0, spr_digit_1, spr_digit_2, 
		spr_digit_3, spr_digit_4, spr_digit_5, spr_digit_6, 
		spr_digit_7, spr_digit_8, spr_digit_9, spr_digit_plus];
	
	for(var i = 0; i < array_length(digit_particle_refs); ++i) {
		part_type_sprite(digit_particle_refs[i], _digit_particle_sprites[i], true, true, false);
		part_type_size(digit_particle_refs[i], 1, 1, 0, 0);
		part_type_color1(digit_particle_refs[i], c_lime);
		part_type_alpha1(digit_particle_refs[i], 1);
		part_type_speed(digit_particle_refs[i], 2, 2, 0, 0);
		part_type_direction(digit_particle_refs[i], 90, 90, 0, 0);
		part_type_orientation(digit_particle_refs[i], 270, 270, 0, 0, true);
		part_type_blend(digit_particle_refs[i], 0);
		part_type_life(digit_particle_refs[i], 30, 30);
	}
}
#endregion


#region draw_money_increase
function draw_money_increase(value_increased, x_pos, y_pos) {
	var digit_to_particle = [global.PARTICLE_DIGIT_0, global.PARTICLE_DIGIT_1, global.PARTICLE_DIGIT_2,
	global.PARTICLE_DIGIT_3, global.PARTICLE_DIGIT_4, global.PARTICLE_DIGIT_5, global.PARTICLE_DIGIT_6,
	global.PARTICLE_DIGIT_7, global.PARTICLE_DIGIT_8, global.PARTICLE_DIGIT_9];
	var _value_increased_string = string(value_increased);
	
	
	part_particles_create(global.PARTICLE_SYSTEM, x_pos, y_pos, global.PARTICLE_DIGIT_PLUS, 1);
	show_debug_message(string_length(_value_increased_string));
	for(var i = 1; i <= string_length(_value_increased_string); ++i) {
		//string_char_at starts with index ONE for some bizzare reason and not ZERO like everything else
		//At least it makes the digit offset calculations look nicer
		var _digit = real(string_char_at(_value_increased_string, i)); //Converts the digit back into a number that can be used as an index
		part_particles_create(global.PARTICLE_SYSTEM, x_pos + 12*i, y_pos + i*0.75, 
			digit_to_particle[_digit], 1);
	}
}
#endregion