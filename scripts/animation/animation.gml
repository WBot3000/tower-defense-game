/*
	animation.gml
	
	This file contains the Animation Controller, used for managing the animations for different entities.
*/

#region AnimationBank (Class)
/*
	Contains a series of animations that can be referenced in the same place.
*/
function AnimationBank() constructor {
	animations = {"DEFAULT": undefined};
	
	static add_animation = function(_animation_ref, _sprite) { //Returns true if animation was successfully added, false otherwise
		var _ref_hash = variable_get_hash(_animation_ref);
		if(struct_exists_from_hash(animations, _ref_hash)) {
			show_debug_message("Attempting to add an animation with a reference that's already used: " + _animation_ref);
			return false
		}
		struct_set_from_hash(animations, _ref_hash, _sprite);
		return true;
	}
	
	
	static set_default_animation = function(_animation_ref) { //Returns true if animation was successfully added, false otherwise
		var _ref_hash = variable_get_hash(_animation_ref);
		if(!struct_exists_from_hash(animations, _ref_hash)) {
			show_debug_message("Attempting to reference an animation with a reference that doesn't exist: " + _animation_ref);
			return false
		}
		var _sprite = struct_get_from_hash(animations, _ref_hash)
		struct_set(animations, "DEFAULT", _sprite); //Don't feel like getting the hash for "DEFAULT", might change later
		return true;
	}
	
	
	static get_animation = function(_animation_ref) {
		return struct_get_from_hash(animations, variable_get_hash(_animation_ref));
	}
}
#endregion


#region UnitAnimationBank (Class)
/*
	Contains a series of animations that can be referenced in the same place.
	Allows the passing of certain animations in the constructor to make initialization easier.
*/
function UnitAnimationBank(_idle_active_animation, _idle_ko_animation = _idle_active_animation,
	_on_spawn_animation = _idle_active_animation, _on_ko_animation = _idle_active_animation, _on_restore_animation = _idle_active_animation) : AnimationBank() constructor {
		add_animation("IDLE_ACTIVE", _idle_active_animation); //Animation that plays when the unit is active and not doing anything
		add_animation("IDLE_KO", _idle_ko_animation);	//Animation that plays when the unit is knocked out and not doing anything
		add_animation("ON_SPAWN", _on_spawn_animation);	//Animation that plays when the unit is purchased and spawned in for the first time
		add_animation("ON_KO", _on_ko_animation); //Animation that plays when the unit's health reaches 0, and they get knocked out
		add_animation("ON_RESTORE", _on_restore_animation); //Animation that plays when the unit is done restoring, and becomes active again

		set_default_animation("IDLE_ACTIVE");
}
#endregion


#region AnimationController (Class)
#macro LOOP_FOREVER -1

/*
	The Animation Controller. Handles the logic of animating objects.
	entity_obj: The object that contains and whose sprite will be modified by this controller.
	current_sprite: The sprite (animation) that is currently playing. Needed for mapping
	static_sprite: The sprite that the entity object will use when an animation isn't playing.
	//animation_queue: Contains all of the animations that the controller will play;
	num_loops: The number of times the current animation should loop. LOOP_FOREVER to loop unless stopped.
	loop_counter: Used to keep track of the number of times the animation has played
	
	TODO: Implement animation queue so different animations can be "queued" up and played sequentially
	
	TODO: When updating a unit, need a way to convert from the sprites of the unupgraded version to the sprites of the upgraded version.
		- Basically need to "map" sprites to each other
*/

function AnimationController(_entity_obj, _animation_bank, _starting_animation_ref = "DEFAULT") constructor {
	entity_obj = _entity_obj;
	
	animation_bank = _animation_bank
	current_animation_ref = _starting_animation_ref

	num_times_played = LOOP_FOREVER;
	played_counter = 0;
	
	prev_image_index = -1;
	
	/*
		Set an animation.
		_animation_ref: The reference to the animation that should play.
		_num_times_played: The number of times that the animations should play.
		
		Returns true if the animation was set successfully, returns false otherwise
	*/
	static set_animation = function(_animation_ref, _num_times_played = 1) {
		var _sprite = animation_bank.get_animation(_animation_ref);
		if(_sprite == undefined) {
			show_debug_message("Attempted to reference an animation that doesn't exist using reference: " + _animation_ref);
			return false
		}
		
		current_animation_ref = _animation_ref;
		
		played_counter = 0;
		num_times_played = _num_times_played;
		prev_image_index = -1;
		
		with(entity_obj) {
			sprite_index = _sprite;
			image_index = 0;
		}
		return true;
	}
	
	//Used to swap out one animation bank with another.
	//If you don't manually set "_replacement_animation_ref", make sure the old bank and new bank have the same references
	static set_animation_bank = function(_new_animation_bank, _replacement_animation_ref = current_animation_ref) {
		//Need to change the currently playing animation to the corresponding one in the animation bank
		var _replacement_animation = _new_animation_bank.get_animation(current_animation_ref);
		
		var _new_image_index = entity_obj.image_index;
		if(entity_obj.image_number != sprite_get_number(_replacement_animation)) { //In the event the old and new animations have different image numbers
			_new_image_index = map_value(entity_obj.image_index, 0, entity_obj.image_number, 0, sprite_get_number(_replacement_animation));
		}
		
		with(entity_obj) {
			sprite_index = _replacement_animation;
			image_index = _new_image_index;
		}
	}
	
	
	static clear_animation = function() {
		var _sprite = animation_bank.get_animation("DEFAULT");
		current_animation_ref = "DEFAULT";
		
		num_times_played = LOOP_FOREVER;
		played_counter = 0;
		prev_image_index = -1;
		
		with(entity_obj) {
			sprite_index = _sprite;
			image_index = 0;
		}
	}
	
	static clear_animation_upon_completion = function() {
		//Basically, just finish up the current loop.
		played_counter = num_times_played - 1;
	}
	
	static on_step = function() {
		if(num_times_played <= LOOP_FOREVER) {
			exit;
		}
		if(prev_image_index < entity_obj.image_index) {
			prev_image_index = entity_obj.image_index;
			exit;
		}
		
		prev_image_index = entity_obj.image_index;
		played_counter++;
		if(played_counter >= num_times_played) {
			clear_animation();
		}
	}
	
	//Set the first animation automatically
	set_animation(_starting_animation_ref, LOOP_FOREVER);
}
#endregion


#region OldAnimationController (Class)

/*
	The Animation Controller. Handles the logic of animating objects.
	entity_obj: The object that contains and whose sprite will be modified by this controller.
	current_sprite: The sprite (animation) that is currently playing. Needed for mapping
	static_sprite: The sprite that the entity object will use when an animation isn't playing.
	//animation_queue: Contains all of the animations that the controller will play;
	num_loops: The number of times the current animation should loop. LOOP_FOREVER to loop unless stopped.
	loop_counter: Used to keep track of the number of times the animation has played
	
	TODO: Implement animation queue so different animations can be "queued" up and played sequentially
	
	TODO: When updating a unit, need a way to convert from the sprites of the unupgraded version to the sprites of the upgraded version.
		- Basically need to "map" sprites to each other
*/

function OldAnimationController(_entity_obj, _current_sprite, _static_sprite = _current_sprite) constructor {
	entity_obj = _entity_obj;
	current_sprite = _current_sprite;
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
	static set_animation = function(_sprite, _num_loops = 1, _end_sprite = static_sprite) {
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
#endregion