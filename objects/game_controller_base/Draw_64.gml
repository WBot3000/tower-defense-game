/// @description Prints out current round, how much money you have, and wall health on screen
var _view_w = camera_get_view_width(view_camera[0]);
var _view_h = camera_get_view_height(view_camera[0]);

//Draw basic game stats
if(game_state == GAME_STATE.VICTORY) {
	draw_text(TILE_SIZE, TILE_SIZE, "Victory!");
}
else {
	draw_text(TILE_SIZE, TILE_SIZE, "Round: " + string(round_manager.current_round));
}
draw_text(TILE_SIZE, TILE_SIZE*2, "Money: " + string(global.player_money));
draw_text(TILE_SIZE, TILE_SIZE*3, "Wall Health: " + string(global.wall_health));


//Draw purchase menu if it should be present on screen
if(purchase_menu_state != PURCHASE_MENU_STATE.CLOSED) {
	purchase_menu.draw();
}


//Draw pause menu or not
//TODO: Needs a little bit more work to implement actual pausing functionality
if(game_state == GAME_STATE.PAUSED) {
	if(!surface_exists(pause_screen_surface)) {
		if(pause_screen_surface == -1) {
			instance_deactivate_all(true); //What actually causes the pausing
        }
		pause_screen_surface = surface_create(_view_w, _view_h);
		surface_set_target(pause_screen_surface);
		draw_surface(application_surface, 0, 0);
		surface_reset_target();
	}
	else {
	    draw_surface(pause_screen_surface, 0, 0);
		//Need to draw components of the GUI, since the pause_screen_surface only draws instances
		if(purchase_menu_state != PURCHASE_MENU_STATE.CLOSED) { //TODO: Need to disable button highlighting
			purchase_menu.draw(false);
		}
	    draw_set_alpha(0.5);
	    draw_rectangle_colour(0, 0, _view_w, _view_h, c_black, c_black, c_black, c_black, false);
	    draw_set_alpha(1);
		pause_menu.draw();
    }
}