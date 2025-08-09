/*
This file contains the base EntityData struct, which contains data that all entities need. There are three kinds of entities:
	1) Units (the entities the player uses to protect the Targets)
	2) Enemies (the entities that intend to destroy or help with the destroying of Targets)
	3) Targets (the entities that the player needs to keep in tact)
*/
function EntityData() constructor {
	inst = other;
	name = "Unnamed";
	
	//Health variables
	health_state = HEALTH_STATE.ACTIVE; //Not really needed for targets, but makes targeting code a bit simpler
	max_health = 100;
	current_health = 100;
	
	//Stat modifiers
	defense_factor = 1; //All taken damage is divided by this value
	
	animation_controller = undefined; //TODO: Maybe move this to Combatant, Targets are simple enough to where animations can probably just be controlled manually.
}


/*
	Units and Enemies share some additional data + functionality that Targets don't need, which is defined here.
*/
function CombatantData() : EntityData() constructor {
	
	buffs = []; //NOTE: Also includes debuffs
	direction_facing = DIRECTION_LEFT;
	can_block = false; //Determines whether an entity can block opposing units/enemies
	
	//Action system
	//List of all the "things" the entity can do while active
	//TODO: Split up actions from data? (Would have to refer to action queue through inst)
	action_queue = [];
	
	static get_action_from_id = function(_id) {
		for(var i = array_length(action_queue) - 1; i >= 0; --i) {
			if(action_queue[i].action_id == _id) {
				return action_queue[i];
			}
		}
		return undefined;
	}
	
	
	//Handles anything that needs to be cleaned up once the unit is deleted
	static on_deletion = function() {
		for(var i = 0; i < array_length(action_queue); ++i) {
				action_queue[i].on_deletion();
		}
	}
}