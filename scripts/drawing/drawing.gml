/*
	drawing.gml
	This file contains functions for drawing things to the screen that don't logically fit in any other file or class.
*/


#region draw_health_bar (Function)
//Draw health bars for units and enemies
//NOTE: Since health bar's origin is center-bottom, the x coordinate is where you want to draw the CENTER of the healthbar, while the y is where you want to draw the bottom
function draw_health_bar(x, y, _current_health, _max_health, recovering_from_ko = false){
	//Error prevention in the event the unit or enemy has 0 max health (should only be true in base objects, which shouldn't ever be instantiated anyways, but still good to check)
	if(_max_health > 0) {
		//Draw health bar sprite
		draw_sprite(spr_health_bar, 1, x, y);

		//Don't want the health bar to overflow in the event the entity's current health exceeds it's normal max health
		//Also don't want it to underflow if the entity (somehow) gets negative health
		//Enemy health casted to real so that division isn't integer division
		var _percent_health_remaining = max(min(1, real(_current_health) / _max_health), 0);
	
		var _spr_health_bar_width = sprite_get_width(spr_health_bar)
		//X-coordinate of the left bound of the health bar (+2 because the border is 2 pixels)
		var _health_bar_left_bound = x - (_spr_health_bar_width/2) + 2;
		//Right bound is same as left bound, but now you need to add the extra length and subtract the border (-3 because this draws at the end? of the pixel)
		var _health_bar_right_bound = x + (_spr_health_bar_width/2) - 3;
	
		//Where to draw the green part of the health bar up to
		var _health_bar_at = map_value(_percent_health_remaining, 0, 1, _health_bar_left_bound, _health_bar_right_bound);

		//Additions to y are also due to sprite borders (maybe make these seem less arbitrary)
		if(recovering_from_ko) {
			draw_rectangle_color(_health_bar_left_bound, y - 6, _health_bar_at, y - 3, c_yellow, c_yellow, c_yellow, c_yellow, false);
		}
		else {
			draw_rectangle_color(_health_bar_left_bound, y - 6, _health_bar_at, y - 3, c_green, c_green, c_green, c_green, false);
		}
	}
}
#endregion