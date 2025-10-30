/// @description Things to do when the unit is deleted
broadcast_hub.broadcast_event(EVENT_ENTITY_DELETED, [self]);
for(var i = 0, len = array_length(events_registered_for); i < len; ++i) {
	var _event = events_registered_for[i];
	_event.remove_subscriber(self);
}

broadcast_hub.clear_current_subscribers();

ds_list_destroy(entities_in_range);