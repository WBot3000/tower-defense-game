/*
This file contains code for a publish-subscribe broadcasting system, used to run code in certain instances when certian events occur (so you don't have to check as much stuff in step events)
Not to be confused with GameMaker's native broadcast stuff (which involves sprites/sequences sending messages to object events)
*/

function BroadcastData(_entity, _on_event_func, _remove_after_broadcast = false) constructor {
	entity = _entity; //Should be an instance
	on_event_func = _on_event_func; //Should be a function that accepts an array as an argument
	remove_after_broadcast = _remove_after_broadcast //Should be a boolean that determines whether or not the listener should be removed after the event is broadcast
}

#macro EVENT_UNIT_PURCHASED "unit_purchased"

#macro EVENT_ENTITY_DELETED "entity_deleted"
#macro EVENT_ENTITY_KO "entity_knocked_out"
#macro EVENT_ENTITY_REVIVED "entity_revived"

#macro EVENT_END_BLOCK "entity_end_block" //Called whenever a blocking unit should let enemies move foward (usually once the entity is defeated)


function BroadcastEvent(_label = "No Label Given") constructor {
	label = _label;
	subscribers = []; //Contains BroadcastDatas
	
	static broadcast_event = function(_args) { //Publish event (can pass an argument array into it)
		for(var i = 0, len = array_length(subscribers); i < len; ++i) {
			var _func = subscribers[i].on_event_func;
			with(subscribers[i].entity) {
				_func(_args);
			}
			if(subscribers[i].remove_after_broadcast) {
				array_delete(subscribers, i, 1);
				i--; //Need to decrement i so the loop remains in the same place
				len--; //Length is now one item less
			}
		}
	}
	
	static add_subscriber = function(_new_entity, _on_event_func, _remove_after_broadcast = false) {
		for(var i = 0, len = array_length(subscribers); i < len; ++i) {
			if(subscribers[i].entity == _new_entity) {
				subscribers[i].on_event_func = _on_event_func;
				return; //Prevent duplicate entries, just change the on_event_func
			}
		}
		array_push(subscribers, new BroadcastData(_new_entity, _on_event_func, _remove_after_broadcast));
	}
	
	static remove_subscriber = function(_entity) {
		for(var i = 0, len = array_length(subscribers); i < len; ++i) {
			if(subscribers[i].entity == _entity) {
				array_delete(subscribers, i, 1);
				return;
			}
		}
		show_debug_message("Entity " + string(_entity.id) + " attempted to be removed from broadcast event " + label + ", despite not being registered.");
	}
	
	static change_subscriber_function = function(_entity, _on_event_func) { //NOTE: This can be done within the "add_subscriber" function technically, but this provides a more explicit way to do it.
		for(var i = 0, len = array_length(subscribers); i < len; ++i) {
			if(subscribers[i].entity == _entity) {
				subscribers[i].on_event_func = _on_event_func;
				return;
			}
		}
		show_debug_message("Entity " + string(_entity.id) + " attempted to have function changed from broadcast event " + label + ", despite not being registered.");
	}
}


function BroadcastHub() constructor { //Contains all of the broadcast events an entity has
	broadcast_events = {};
	
	static register_event = function(_event_label) {
		broadcast_events[$ _event_label] = new BroadcastEvent(_event_label);
	}

	static broadcast_event = function(_event_label = "NO_LABEL_GIVEN!", _args = []) {
		var _event = broadcast_events[$ _event_label];
		if(_event != undefined) {
			_event.broadcast_event(_args);
		}
		else {
			show_debug_message("Attempt to call unregistered event " + _event_label + " on Broadcast Hub " + string(self));
		}
	}
	
	static clear_current_subscribers = function() {
		var _event_names = variable_struct_get_names(broadcast_events);
		for(var i = 0, len = array_length(_event_names); i < len; ++i) {
			var _event = variable_struct_get(broadcast_events, _event_names[i]);
			for(var j = 0, len2 = array_length(_event.subscribers); j < len2; ++j) {
				var _subscriber = _event.subscribers[j];
				//Unbounded triple nested loop makes me sad
				//TODO: Maybe I should just change some of these to structs for code-readability purposes
				//The reason they aren't structs now is because arrays are faster when the input is significantly small, but the scale might increase past that point anyways.
				for(var k = 0, len3 = array_length(_subscriber.events_registered_for); k < len3; ++k) {
					if(_subscriber.events_registered_for[k] == _event) {
						array_delete(_subscriber.events_registered_for, k, 1);
						break;
					}
				}
			}
		}
	}
}


function add_broadcast_subscriber(_broadcaster, _event_label, _on_event_func, _remove_after_broadcast = false, _subscriber = self) {
	var _event = _broadcaster.broadcast_hub.broadcast_events[$ _event_label];
	_event.add_subscriber(_subscriber, _on_event_func, _remove_after_broadcast);
	array_push(_subscriber.events_registered_for, _event);
}


function remove_broadcast_subscriber(_broadcaster, _event_label, _subscriber = self) {
	var _event = _broadcaster.broadcast_hub.broadcast_events[$ _event_label];
	//TODO: Put check here if event exists?
	_event.remove_subscriber(_subscriber);
	for(var i = 0, len = array_length(_subscriber.events_registered_for); i < len; ++i) {
		if(_subscriber.events_registered_for[i] == _event) {
			array_delete(_subscriber.events_registered_for, i, 1);
			return;
		}
	}
}