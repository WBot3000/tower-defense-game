/// @description Remove enemy from the round manager (if one is present)
var _round_manager = get_round_manager();
if(_round_manager != undefined) {
	_round_manager.remove_enemy(self.id, round_spawned_in);
}
