/// @description Initialize things all units use

//Buff-debuff list
buffs = new BuffList();

animation_controller = new AnimationController(self, animation_bank);

broadcast_hub = new BroadcastHub();
broadcast_hub.register_event("unit_knocked_out");
broadcast_hub.register_event("unit_revived");
broadcast_hub.register_event("unit_deleted");


events_registered_for = []; //List of events this entity is registered for