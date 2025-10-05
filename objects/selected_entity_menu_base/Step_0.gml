/// @description Move the menu if needed
if(!visible || !layer_get_visible(layer)) { return; }

var _toggle_button_pressed = keyboard_check_pressed(ord(global.GAME_CONFIG_OPTIONS.controls.open_selected_entity_menu_key))

switch (state) {
		case SLIDING_MENU_STATE.CLOSED:
			if( _toggle_button_pressed &&
				game_state_manager && game_state_manager.state == GAME_STATE.RUNNING) { //Only allow toggling if the game is running
				play_sound_effect(SFX_Menu_Open);
				state = SLIDING_MENU_STATE.OPENING;
			}
			break;
		case SLIDING_MENU_STATE.CLOSING:
			var _current_y_pos = flexpanel_node_layout_get_position(ui_panel, false).top;
			var _new_y_pos = _current_y_pos + min(SLIDING_MENU_MOVEMENT_SPEED, view_h - _current_y_pos); //min(SLIDING_MENU_MOVEMENT_SPEED, view_h - _current_y_pos) is _y_delta
			flexpanel_node_style_set_position(ui_panel, flexpanel_edge.top, _new_y_pos, flexpanel_unit.point);
			flexpanel_calculate_layout(ui_panel, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), flexpanel_direction.LTR);
			if(_new_y_pos >= view_h) {
				state = SLIDING_MENU_STATE.CLOSED;
			}
			break;
		case SLIDING_MENU_STATE.OPENING:
			var _current_y_pos = flexpanel_node_layout_get_position(ui_panel, false).top;
			var _new_y_pos = _current_y_pos + max(SLIDING_MENU_MOVEMENT_SPEED * -1, view_h - sprite_height - _current_y_pos); //max(SLIDING_MENU_MOVEMENT_SPEED * -1, view_h - 128 - screen_y) is _y_delta
			flexpanel_node_style_set_position(ui_panel, flexpanel_edge.top, _new_y_pos, flexpanel_unit.point);
			flexpanel_calculate_layout(ui_panel, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), flexpanel_direction.LTR);
			if(_new_y_pos <= view_h - sprite_height) {
				state = SLIDING_MENU_STATE.OPEN;
			}
			break;
		case SLIDING_MENU_STATE.OPEN:
			if(_toggle_button_pressed &&
				game_state_manager && game_state_manager.state == GAME_STATE.RUNNING) {
				play_sound_effect(SFX_Menu_Open);
				state = SLIDING_MENU_STATE.CLOSING;
			}
			break;
		default:
			break;
	}