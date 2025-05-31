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
				absolute_x_pos + 16, absolute_y_pos + 16)
			draw_text_color(absolute_x_pos + 16, absolute_y_pos + 100, level_data.level_name,
				c_black, c_black, c_black, c_black, 1)
		}
		
		static on_released = function() {
			room_goto(level_data.level_room);
		}
}
#endregion


#region LevelSelectUI
/*
	Handles the UI for the Level Selection Menu
*/
function LevelSelectUI() : UIComponent() constructor {
	//Buttons (NOTE: Positions don't use enums since these are more than likely temporary)
	button_samplelevel1 = new LevelCard(TILE_SIZE * 0.5, TILE_SIZE, global.DATA_LEVEL_MAIN_SAMPLELEVEL1);
	button_samplelevel1.activate();
	
	button_samplelevel2 = new LevelCard(TILE_SIZE * 5.5, TILE_SIZE, global.DATA_LEVEL_MAIN_SAMPLELEVEL2);
	button_samplelevel2.activate();
	
	button_samplelevel3 = new LevelCard(TILE_SIZE * 10.5, TILE_SIZE, global.DATA_LEVEL_MAIN_SAMPLELEVEL3);
	button_samplelevel3.activate();
	
	children = [button_samplelevel1, button_samplelevel2, button_samplelevel3];
	
	active = true //We can just do this here instead of calling activate/deactivate, since this UI should always be active
}
#endregion