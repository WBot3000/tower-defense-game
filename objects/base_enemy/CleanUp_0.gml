/// @description Remove enemy from the round manager (if one is present)
var _round_manager = get_round_manager();
if(_round_manager != undefined) {
	_round_manager.remove_enemy(self.id, round_spawned_in);
}

broadcast_hub.broadcast_event("entity_deleted", [self]);
for(var i = 0, len = array_length(events_registered_for); i < len; ++i) {
	var _event = events_registered_for[i];
	_event.remove_subscriber(self);
}