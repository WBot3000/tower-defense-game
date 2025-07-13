/*
This file contains custom collision list functions that utilize arrays instead of ds_lists

These probably won't be used in the final game, but I wanted to take on the challenge
*/
//TODO: Add other arguments (prec, notme, ordered). Don't need to add list since this just returns an array
function collision_point_array(_x, _y, obj) {
	var collision_array = [];
	
	with (obj) {
		if(self.bbox_left <= _x && self.bbox_right >= _x && self.bbox_top <= _y && self.bbox_bottom >= _y) {
			array_push(collision_array, self);
		}
	}
	return collision_array;
}
//collision_point_list()


//TODO: This one aint done yet
//TODO: Add other arguments (prec, notme, ordered). Don't need to add list since this just returns an array
/*
	NOTES
	
	To get a collision, the line either has to
		1) Pass through one of the boundaries of the bounding box
		2) Hit a corner
*/
function collision_line_array(x1, y1, x2, y2, obj) {
	var collision_array = [];
	var slope = (y2 - y1) / (x2 - x1);
	var intercept = y1 - slope*x1; //Could also use y2 - slope*x2, should produce the same answer
	/*
	with (obj) {
		var y_of_bbox_left = 
		if(self.bbox_left <= _x && self.bbox_right >= _x && self.bbox_top <= _y && self.bbox_bottom >= _y) {
			array_push(collision_array, self);
		}
	}*/
	return collision_array;
}
//collision_line_list()


//TODO: Add other arguments (prec, notme, ordered). Don't need to add list since this just returns an array
function collision_rectangle_array(x1, y1, x2, y2, obj) {
	var collision_array = [];
	var left_bound = x1 < x2 ? x1 : x2;
	var right_bound = x1 < x2 ? x2 : x1;
	var top_bound = y1 < y2 ? y1 : y2;
	var bottom_bound = y1 < y2 ? y2 : y1;
	
	with (obj) {
		var bbox_left_in_rect = self.bbox_left >= left_bound && self.bbox_left <= right_bound;
		var bbox_right_in_rect = self.bbox_right >= left_bound && self.bbox_right <= right_bound;
		var bbox_top_in_rect = self.bbox_top >= top_bound && self.bbox_top <= bottom_bound;
		var bbox_bottom_in_rect = self.bbox_bottom >= top_bound && self.bbox_bottom <= bottom_bound;
		//Need at least one horizontal boundary and one vertical boundary in the rectangle for a collision
	    if((bbox_left_in_rect || bbox_right_in_rect) && (bbox_top_in_rect || bbox_bottom_in_rect)) {
			array_push(collision_array, self);
		}
	}
	
	return collision_array;
}
//collision_rectangle_list()


//TODO: Add other arguments (prec, notme, ordered). Don't need to add list since this just returns an array
/*
	NOTES
	
	Equation of a circle is (x-h)^2 + (y-k)^2 = r^2
	For all points (x, y) in and on the circle, (x-h)^2 + (y-k)^2 <= r^2
	If (x-h)^2 + (y-k)^2 > r^2, then the point is outside the circle
	
	In our function, h is actually x1, and k is actually y1
*/
function collision_circle_array(x1, y1, radius, obj) {
	var collision_array = [];
	var radius_squared = radius * radius;
	
	with (obj) {
		var tl_in_circle = (self.bbox_left - x1) * (self.bbox_left - x1) + (self.bbox_top - y1) + (self.bbox_top - y1) <= radius_squared
		var tr_in_circle = (self.bbox_right - x1) * (self.bbox_right - x1) + (self.bbox_top - y1) + (self.bbox_top - y1) <= radius_squared
		var bl_in_circle = (self.bbox_left - x1) * (self.bbox_left - x1) + (self.bbox_bottom - y1) + (self.bbox_bottom - y1) <= radius_squared
		var br_in_circle = (self.bbox_right - x1) * (self.bbox_right - x1) + (self.bbox_bottom - y1) + (self.bbox_bottom - y1) <= radius_squared
		
	    if(tl_in_circle || tr_in_circle || bl_in_circle || br_in_circle) { //If at least one of those points is in the circle, there should be a collision
			array_push(collision_array, self);
		}
	}
	
	return collision_array;
}
//collision_circle_list()