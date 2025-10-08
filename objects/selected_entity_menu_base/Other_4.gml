/// @description Get appropriate game state manager
game_state_manager = get_game_state_manager();

//Close menu if open
flexpanel_node_style_set_position(ui_panel, flexpanel_edge.top, view_h, flexpanel_unit.point);
flexpanel_calculate_layout(ui_panel, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), flexpanel_direction.LTR);
state = SLIDING_MENU_STATE.CLOSED;