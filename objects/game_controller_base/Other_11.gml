/// @description Called when game has been lost
//game_state = GAME_STATE.DEFEAT;
game_state_manager.lose_game();
global.defense_health = 0;
music_manager.fade_out_current_music(MUSIC_FADING_TIME, Music_Defeat);