/// @description Create StartMenuUI and some global stuff
start_menu_ui = new StartMenuUI();

//Play title music
global.BACKGROUND_MUSIC_MANAGER.set_music(Music_Title_Theme);

//Arrow keys = WASD
keyboard_set_map(vk_up, ord("W"));
keyboard_set_map(vk_left, ord("A"));
keyboard_set_map(vk_down, ord("S"));
keyboard_set_map(vk_right, ord("D"));

//Particle Stuff!
global.PARTICLE_SYSTEM = part_system_create_layer(PARTICLE_LAYER, true);

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
	global.PARTICLE_DIGIT_7, global.PARTICLE_DIGIT_8, global.PARTICLE_DIGIT_9, global.PARTICLE_DIGIT_PLUS])

//Create fade in effect
transition_effect = new FadeTransition(1, 0)
transition_effect.transition_in();