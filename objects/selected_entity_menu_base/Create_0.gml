/// @description Initialize needed variables
event_inherited();
state = SLIDING_MENU_STATE.CLOSED;
view_h = camera_get_view_height(view_camera[0]);

game_state_manager = undefined;

ui_panel = flexpanel_node_get_child(
	layer_get_flexpanel_node(GUI_IN_GAME), "SelectedEntityMenu"
);

flexpanel_calculate_layout(ui_panel, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), flexpanel_direction.LTR);