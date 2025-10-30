///@description Initialize things all enemies use
if(!variable_instance_exists(self, "entity_data")) {
	throw ("No entity data for instance " + string(self.id))
}

if(!variable_instance_exists(self, "path_data")) {
	show_debug_message("Enemy " + string(self.id) + " created with no path data");
	path_data = global.DATA_LEVEL_PATH_DUMMYPATH;
}

if(!variable_instance_exists(self, "round_spawned_in")) {
	show_debug_message("Enemy " + string(self.id) + " created with no round spawn data");
}

animation_controller = new AnimationController(self, animation_bank);
buffs = new BuffList();

stat_multipliers = array_create(STATS.LENGTH, 1)

broadcast_hub = new BroadcastHub();
broadcast_hub.register_event(EVENT_ENTITY_DELETED);

entities_in_range = ds_list_create();

events_registered_for = []; //List of events this entity is registered for

movement_controller = new entity_data.movement_controller_type(self)