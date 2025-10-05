/// @description Create StartMenuUI and some global stuff
//start_menu_ui = new StartMenuUI();

//Play title music
global.BACKGROUND_MUSIC_MANAGER.set_music(Music_Title_Theme);

//Create fade in effect
//transition_effect = new FadeTransition(1, 0)
//transition_effect.transition_in();
set_ui(GUI_TITLE_SCREEN);
change_options_menu_page(OPTIONS_PAGE_AUDIO);
close_options_menu();
room_intro_transition(screen_fade_in);