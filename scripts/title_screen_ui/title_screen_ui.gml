/*
This file contains UI components on the title screen
*/

#region LevelSelectButton (Class)
/*
	Defines a button that can be clicked to take you to a level select screen
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
*/
function LevelSelectButton(_x_pos, _y_pos) :
	Button(_x_pos, _y_pos, spr_play_game_button) constructor {
		
		static on_released = function() {
			room_goto(LevelSelectScreen);
		}
}
#endregion


#region OptionsButton (Class)
/*
	Defines a button that can be clicked to take you to an options menu
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
*/
function OptionsButton(_x_pos, _y_pos) :
	Button(_x_pos, _y_pos, spr_options_button) constructor {
		
		static on_released = function() {
			parent.options_menu.activate();
		}
}
#endregion


#region QuitGameButton (Class)
/*
	Defines a button that can be clicked to exit the game
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	x_pos: Horizontal coordinate of the button's top-left corner (relative to the menu's origin).
	y_pos: Vertical coordinate of the button's top-left corner (relative to the menu's origin).
*/
function QuitGameButton(_x_pos, _y_pos) :
	Button(_x_pos, _y_pos, spr_quit_game_button) constructor {
		
		static on_released = function() {
			game_end();
		}
}
#endregion


#region StartMenuUI (Class)
/*
	Used for managing the entire UI as a unit. Allows you to enable and disable parts of the UI as needed
*/
#macro PLAY_BUTTON_X ((camera_get_view_width(view_camera[0]) - sprite_get_width(spr_play_game_button)) / 2)
#macro PLAY_BUTTON_Y TILE_SIZE*2

#macro OPTIONS_BUTTON_X ((camera_get_view_width(view_camera[0]) - sprite_get_width(spr_options_button)) / 2)
#macro OPTIONS_BUTTON_Y TILE_SIZE*4

#macro QUIT_BUTTON_X ((camera_get_view_width(view_camera[0]) - sprite_get_width(spr_quit_game_button)) / 2)
#macro QUIT_BUTTON_Y TILE_SIZE*6

/*
	In charge of drawing UI elements on the start menu.
	
	Argument Variables:
	_purchase_data: The purchase data needed for the purchase menu
	(All other argument variables correspond with non-underscored data variables)
	
	Data Variables:
	start_button: Button for starting the game (takes you to the Level Select screen)
	quit_button: Quits the game, closing the application.
	
	TODO: Finish this comment
*/
function StartMenuUI() : UIComponent() constructor {		
	//Buttons
	start_button = new LevelSelectButton(PLAY_BUTTON_X, PLAY_BUTTON_Y);
	start_button.activate();
	
	options_button = new OptionsButton(OPTIONS_BUTTON_X, OPTIONS_BUTTON_Y);
	options_button.activate();
	
	quit_button = new QuitGameButton(QUIT_BUTTON_X, QUIT_BUTTON_Y);
	quit_button.activate();
	
	options_menu = new OptionsMenu((1/2), (1/2));
	
	children = [start_button, options_button, quit_button, options_menu];
	
	active = true //We can just do this here instead of calling activate/deactivate, since this UI should always be active
	
	
	static draw_parent = draw;
	
	static draw = function() {
		draw_parent();
		draw_text(TILE_SIZE, view_h - (TILE_SIZE/2), "Music + Sound Effects by Eric Matyas, www.soundimage.org");
	}
}
#endregion