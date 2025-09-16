/*
This file contains functions relating to the particle systems of the game.
Might merge this into the drawing script, might not (that one is more about drawing things to the screen via draw event, this one is about particles specifically)
*/
#region ParticleBeam (Class)
#macro BEAM_SPEED_DEFAULT 30
/*
	Creates a "beam" of particles from one instance to another instance.
	Created for the Flame Construct's flamethrower, but might find other uses elsewhere.
	NOTE: Since this creates a particle system, remember to call "destroy_particle_beam" when you're done with it.
	
	TODO: Make a version with coordiantes too?
*/
function ParticleBeam(_particle_sprite, _start_instance = other, _end_instance = noone,
	_particle_frequency = 1, _particle_speed = BEAM_SPEED_DEFAULT, _additional_travel_distance = 0) constructor {
	start_instance = _start_instance;
	end_instance = _end_instance;
	particle_frequency = _particle_frequency;
	particle_speed = _particle_speed;
	additional_travel_distance = _additional_travel_distance;
	particle_timer = 0;
	
	beam_particle_system = part_system_create();
	beam_particle = part_type_create();
	particle_spacing = (particle_speed / sprite_get_width(_particle_sprite))*3; //Assumes pixel image is square
	
	part_type_sprite(beam_particle, _particle_sprite, true, true, false);
	part_type_size(beam_particle, 1, 1, 0, 0);
	part_type_alpha1(beam_particle, 1);
	part_type_speed(beam_particle, particle_speed, particle_speed, 0, 0);
	part_type_blend(beam_particle, 0);
	
	static on_step = function() {
		if(!instance_exists(start_instance)) { start_instance = noone; }
		if(!instance_exists(end_instance)) { end_instance = noone; }
		if(start_instance == noone || end_instance == noone) { return; }
		
		particle_timer++;
		if(particle_timer > particle_frequency) {
			
			//Sets the particle properties based on distance between start and end instances
			var _beam_vector = instances_vector_to_get_components(start_instance, end_instance);
		
			var _particle_direction = get_angle_from_vector_in_degrees(_beam_vector);
			//time = distance/velocity
			var _particle_lifespan = (_beam_vector[VEC_LEN] + additional_travel_distance) / particle_speed;

			part_type_direction(beam_particle, _particle_direction, _particle_direction, 0, 0);
			part_type_life(beam_particle, _particle_lifespan, _particle_lifespan);
			
			//Creating several particles at a time in order to get a solid "beam".
			var _particle_spaces = 0;
			while(_particle_spaces < particle_speed) {
				part_particles_create(beam_particle_system, 
					get_bbox_center_x(start_instance) + _particle_spaces*dcos(_particle_direction), get_bbox_center_y(start_instance) + _particle_spaces*dsin(_particle_direction)*-1, 
					beam_particle, 1);
				_particle_spaces += particle_spacing;
			}
			
		}
	}
	
	
	static destroy_particle_beam = function() {
		part_type_destroy(beam_particle);
		part_system_destroy(beam_particle_system);
	}
	
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