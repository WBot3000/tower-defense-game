/// @description Initialize things needed for the whole game
randomise(); //Needed for random variables

//Arrow keys = WASD
keyboard_set_map(vk_up, ord("W"));
keyboard_set_map(vk_left, ord("A"));
keyboard_set_map(vk_down, ord("S"));
keyboard_set_map(vk_right, ord("D"));

//Do stuff regarding command-line parameters
command_line_parameters_on_game_start();

//Particle Stuff!
global.PARTICLE_SYSTEM = part_system_create_layer(PARTICLE_LAYER, true);

global.PARTICLE_ENEMYDEATH = part_type_create();
part_type_sprite(global.PARTICLE_ENEMYDEATH, spr_enemy_defeated, true, true, false);
part_type_size(global.PARTICLE_ENEMYDEATH, 1, 1, 0, 0);
part_type_alpha1(global.PARTICLE_ENEMYDEATH, 1);
part_type_speed(global.PARTICLE_ENEMYDEATH, 0, 0, 0, 0);
part_type_direction(global.PARTICLE_ENEMYDEATH, 0, 0, 0, 0);
part_type_orientation(global.PARTICLE_ENEMYDEATH, 0, 0, 0, 0, true);
part_type_blend(global.PARTICLE_ENEMYDEATH, 0);
part_type_life(global.PARTICLE_ENEMYDEATH, 30, 30);

global.PARTICLE_SPARKLE = part_type_create();
part_type_sprite(global.PARTICLE_SPARKLE, spr_sparkle, true, true, false);
part_type_size(global.PARTICLE_SPARKLE, 1, 1, 0, 0);
part_type_alpha2(global.PARTICLE_SPARKLE, 1, 0);
part_type_speed(global.PARTICLE_SPARKLE, 0, 0, 0, 0);
part_type_direction(global.PARTICLE_SPARKLE, 0, 0, 0, 0);
part_type_orientation(global.PARTICLE_SPARKLE, 0, 0, 0, 0, true);
part_type_blend(global.PARTICLE_SPARKLE, 0);
part_type_life(global.PARTICLE_SPARKLE, 20, 40);

global.PARTICLE_RAIN = part_type_create();
part_type_sprite(global.PARTICLE_RAIN, spr_rain, true, true, false);
part_type_size(global.PARTICLE_RAIN, 1, 1, 0, 0);
part_type_alpha3(global.PARTICLE_RAIN, 1, 1, 0);
part_type_speed(global.PARTICLE_RAIN, 2, 2, 0, 0);
part_type_direction(global.PARTICLE_RAIN, 270, 270, 0, 0);
part_type_orientation(global.PARTICLE_RAIN, 90, 90, 0, 0, true);
part_type_blend(global.PARTICLE_RAIN, 0);
part_type_life(global.PARTICLE_RAIN, 15, 15);

//TODO: When range becomes adjustable, each individual instance will need its own particle (like how the flamethrower particles work now). Just keep that in mind.
var _initial_aura_percentage = 16/sprite_get_width(spr_healing_aura)//Aura should start at 16 pixels, then grow to max size
var _aura_time = seconds_to_roomspeed_frames(0.5);
var _aura_growth_per_frame = 0.0306;

global.PARTICLE_HEALING_AURA = part_type_create();
part_type_sprite(global.PARTICLE_HEALING_AURA, spr_healing_aura, true, true, false);
part_type_size(global.PARTICLE_HEALING_AURA, _initial_aura_percentage, _initial_aura_percentage, _aura_growth_per_frame, 0);
part_type_alpha3(global.PARTICLE_HEALING_AURA, 1, 1, 0);
part_type_blend(global.PARTICLE_HEALING_AURA, 0);
part_type_life(global.PARTICLE_HEALING_AURA, _aura_time, _aura_time);


global.PARTICLE_DIGIT_0 = part_type_create();
global.PARTICLE_DIGIT_1 = part_type_create();
global.PARTICLE_DIGIT_2 = part_type_create();
global.PARTICLE_DIGIT_3 = part_type_create();
global.PARTICLE_DIGIT_4 = part_type_create();
global.PARTICLE_DIGIT_5 = part_type_create();
global.PARTICLE_DIGIT_6 = part_type_create();
global.PARTICLE_DIGIT_7 = part_type_create();
global.PARTICLE_DIGIT_8 = part_type_create();
global.PARTICLE_DIGIT_9 = part_type_create();
global.PARTICLE_DIGIT_PLUS = part_type_create();
initialize_digit_particles([global.PARTICLE_DIGIT_0, global.PARTICLE_DIGIT_1, global.PARTICLE_DIGIT_2, 
	global.PARTICLE_DIGIT_3, global.PARTICLE_DIGIT_4, global.PARTICLE_DIGIT_5, global.PARTICLE_DIGIT_6, 
	global.PARTICLE_DIGIT_7, global.PARTICLE_DIGIT_8, global.PARTICLE_DIGIT_9, global.PARTICLE_DIGIT_PLUS]);
	
global.PARTICLE_ARROW_GOLD_RUSH = part_type_create();
part_type_sprite(global.PARTICLE_ARROW_GOLD_RUSH, spr_arrow_particle, true, true, false);
part_type_size(global.PARTICLE_ARROW_GOLD_RUSH, 1, 1, 0, 0);
part_type_color1(global.PARTICLE_ARROW_GOLD_RUSH, c_yellow);
part_type_alpha3(global.PARTICLE_ARROW_GOLD_RUSH, 1, 1, 0);
part_type_speed(global.PARTICLE_ARROW_GOLD_RUSH, 1.5, 1.5, 0, 0);
part_type_direction(global.PARTICLE_ARROW_GOLD_RUSH, 90, 90, 0, 0);
part_type_orientation(global.PARTICLE_ARROW_GOLD_RUSH, 270, 270, 0, 0, true);
part_type_blend(global.PARTICLE_ARROW_GOLD_RUSH, 0);
part_type_life(global.PARTICLE_ARROW_GOLD_RUSH, 15, 15);