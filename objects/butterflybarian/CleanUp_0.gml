/// @description Clean up data structures and unregister from events
ds_list_destroy(entities_in_range);
event_inherited(); //Remove from spawned enemies list in round manager