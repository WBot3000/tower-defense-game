/// @description Clean up data structures
ds_list_destroy(units_in_range);
ds_list_destroy(targets_in_range);

event_inherited(); //Remove from spawned enemies list in round manager