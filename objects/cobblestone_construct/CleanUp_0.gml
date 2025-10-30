/// @description Clean up data structures
event_inherited();

//release_enemies_from_block();
broadcast_hub.broadcast_event(EVENT_END_BLOCK, [self]);