/// @description Initialize things all units use

//Buff-debuff list
buffs = new BuffList();

//Stat multipliers (based on buffs/debuffs and other stats)
stat_multipliers = array_create(STATS.LENGTH, 1);

animation_controller = new AnimationController(self, animation_bank);

broadcast_hub = new BroadcastHub();
broadcast_hub.register_event("entity_knocked_out");
broadcast_hub.register_event("entity_revived");
broadcast_hub.register_event("entity_deleted");


events_registered_for = []; //List of events this entity is registered for

//Caching the selected entity manager for drawing checks
selected_entity_manager = get_selected_entity_manager();