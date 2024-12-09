/*
This file contains the Animation Controller, used for managing the animations for different units
*/
#macro LOOP_FOREVER -1

/*
	The Animation Controller. Handles the logic of animating objects.
	entity_obj: The object that contains and whose sprite will be modified by this controller.
	//current_sprite: The sprite (animation) that is currently playing
	static_sprite: The sprite that the entity object will use when an animation isn't playing.
	//animation_queue: Contains all of the animations that the controller will play;
	num_loops: The number of times the current animation should loop. LOOP_FOREVER to loop unless stopped.
	loop_counter: Used to keep track of the number of times the animation has played
	
	TODO: Implement animation queue so different animations can be "queued" up and played sequentially
*/

function AnimationController(_entity_obj, _current_sprite, _static_sprite = _current_sprite) constructor {
	entity_obj = _entity_obj;
	//current_sprite = _current_sprite;
	static_sprite = _static_sprite;
	//animation_queue = [];
	num_loops = LOOP_FOREVER;
	loop_counter = 0;
	
	/*
		Set an animation.
		_sprite: The sprite (animation) that should play.
		_num_loops: The number of times that the animations should play.
		_end_sprite: The sprite that the object will be set to after the animation finishes.
	*/
	static set_animation = function(_sprite, _num_loops = 1, _end_sprite = _static_sprite) {
		//current_sprite = _sprite;
		num_loops = _num_loops;
		static_sprite = _end_sprite;
		with(entity_obj) {
			sprite_index = _sprite;
			image_index = 0;
		}
	}
	
	static clear_animation = function() {
		//current_sprite = static_sprite;
		num_loops = -1;
		loop_counter = 0;
		with(entity_obj) {
			sprite_index = other.static_sprite;
			image_index = 0;
		}
	}
	
	static clear_animation_upon_completion = function() {
		//Basically, just finish up the current loop. Technically, any value works as long as num_loops = loop_counter - 1.
		num_loops = 1;
		loop_counter = 0;
	}
	
	static on_step = function() {
		if((num_loops == LOOP_FOREVER) || (entity_obj.image_index < entity_obj.image_number - entity_obj.image_speed)) {
			exit;
		}
		
		loop_counter++;
		if(loop_counter >= num_loops) {
			clear_animation();
		}
	}
	
	/*
	static queue_animation = function() {
	}
	*/
}