/// @description Create StartMenuUI and some global stuff
start_menu_ui = new StartMenuUI();

//Play title music
global.BACKGROUND_MUSIC_MANAGER.set_music(Music_Title_Theme);

//Create fade in effect
//transition_effect = new FadeTransition(1, 0)
//transition_effect.transition_in();
layer_sequence_create(TRANSITION_LAYER, 0, 0, screen_fade_in);