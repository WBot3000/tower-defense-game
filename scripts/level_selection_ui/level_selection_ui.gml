/*
This file contains UI components on the level selection screen
*/

#region LevelCard (Class)
/*
	Draws a level card that can be clicked on to select a level
	
	Argument Variables:
	Correspond to data variables
	
	Data Variables:
	x_pos: X-coordinate of the level card
	y_pos: Y-coordinate of the level card
	level_data: The data of the level that this card corresponds to (global.DATA_LEVEL_MAIN_[LEVELNAME])
*/
function LevelCard(_x_pos, _y_pos, _level_data) :
	Button(_x_pos, _y_pos, spr_level_select_base) constructor {
		
		level_data = _level_data;
		
		static draw_parent = self.draw;
		
		static draw = function() {
			shader_set(shader_levelcards);
			shader_set_uniform_f_array( shader_get_uniform(shader_levelcards, "cardColor"),
				level_data.card_color);
			draw_parent();
			shader_reset();
			draw_sprite(level_data.level_portrait, 1,
				x_pos + 16, y_pos + 16)
			draw_text_color(x_pos + 16, y_pos + 100, level_data.level_name,
				c_black, c_black, c_black, c_black, 1)
		}
		
		static on_released = function() {
			room_goto(level_data.level_room);
		}
}
#endregion


#region LevelSelectFrame (Class)
#macro LEVEL_SELECT_FRAME_THICKNESS 16
function LevelSelectFrame() : UIComponent() constructor {
	static draw = function() {
		draw_rectangle_color(0, 0, LEVEL_SELECT_FRAME_THICKNESS, view_h, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
		draw_rectangle_color(view_w - LEVEL_SELECT_FRAME_THICKNESS, 0, view_w, view_h, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
		draw_rectangle_color(0, 0, view_w, LEVEL_SELECT_FRAME_THICKNESS*3, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
		draw_rectangle_color(0, view_h - LEVEL_SELECT_FRAME_THICKNESS, view_w, view_h, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
		draw_set_halign(fa_center);
		draw_text_color(view_w/2, LEVEL_SELECT_FRAME_THICKNESS*1.5, "Select a Level", c_white, c_white, c_white, c_white, 1);
		draw_set_halign(fa_left);
	}
	
	static is_highlighted = function() {
		var _view_x = device_mouse_x_to_gui(0);
		var _view_y = device_mouse_y_to_gui(0);
		
		return !(_view_x >= LEVEL_SELECT_FRAME_THICKNESS*2 && _view_x <= view_w - LEVEL_SELECT_FRAME_THICKNESS &&
			_view_y >= LEVEL_SELECT_FRAME_THICKNESS && _view_y <= view_h - LEVEL_SELECT_FRAME_THICKNESS);
	}
}
#endregion


#region LevelSelectUI
/*
	Handles the UI for the Level Selection Menu
*/
function LevelSelectUI() : UIComponent() constructor {
	level_select_frame = new LevelSelectFrame();
	level_select_frame.activate();
	
	//Buttons (NOTE: Positions don't use enums since these are more than likely temporary)
	button_samplelevel1 = new LevelCard(TILE_SIZE * 0.5, TILE_SIZE, global.DATA_LEVEL_MAIN_SAMPLELEVEL1);
	button_samplelevel1.activate();
	
	button_samplelevel2 = new LevelCard(TILE_SIZE * 5.5, TILE_SIZE, global.DATA_LEVEL_MAIN_SAMPLELEVEL2);
	button_samplelevel2.activate();
	
	button_samplelevel3 = new LevelCard(TILE_SIZE * 10.5, TILE_SIZE, global.DATA_LEVEL_MAIN_SAMPLELEVEL3);
	button_samplelevel3.activate();
	
	children = [level_select_frame, button_samplelevel1, button_samplelevel2, button_samplelevel3];
	
	active = true //We can just do this here instead of calling activate/deactivate, since this UI should always be active
}
#endregion