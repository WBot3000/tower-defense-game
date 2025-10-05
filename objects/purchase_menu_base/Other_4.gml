/// @description Get appropriate game state manager
var _game_controller = get_logic_controller();
if(_game_controller != undefined) {
	game_state_manager = get_game_state_manager(_game_controller);
	purchase_list = _game_controller.purchase_list; //Cached for convenience
}