/// @description Insert description here
event_inherited();
state = SLIDING_MENU_STATE.CLOSED;
view_w = camera_get_view_width(view_camera[0]);

purchase_list = [[]];
current_page = 0;
game_state_manager = undefined;

ui_panel = flexpanel_node_get_child(
	layer_get_flexpanel_node(GUI_IN_GAME), "UnitPurchaseMenu"
);



