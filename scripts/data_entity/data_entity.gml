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
}


/*
	Units and Enemies share some additional data + functionality that Targets don't need, which is defined here.
*/
function CombatantData() : EntityData() constructor {
	
	buffs = []; //NOTE: Also includes debuffs
	direction_facing = DIRECTION_LEFT;
	can_block = false; //Determines whether an entity can block opposing units/enemies

}