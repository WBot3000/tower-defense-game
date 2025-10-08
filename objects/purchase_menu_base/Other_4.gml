/// @description Get appropriate game state manager
var _game_controller = get_logic_controller();
if(_game_controller != undefined) {
	game_state_manager = get_game_state_manager(_game_controller);
	purchase_list = _game_controller.purchase_list; //Cached for convenience
}

change_purchase_menu_page(0);

//Close menu if open
flexpanel_node_style_set_position(ui_panel, flexpanel_edge.left, view_w, flexpanel_unit.point);
flexpanel_calculate_layout(ui_panel, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), flexpanel_direction.LTR);
state = SLIDING_MENU_STATE.CLOSED;