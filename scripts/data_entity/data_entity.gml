enum STATS {
	SIGHT_RANGE, //Determines how far an entity can see other entities
	MOVEMENT_SPEED, //Movement speed of an entity (usually an enemy along a path)
	ATTACK_POWER,
	ATTACK_SPEED, //How quickly an entity attacks
	DEFENSE, //Damage reduction (or increased damage taken if this value is less than 1)
	HEALTH_REGEN_SPEED, //How quickly an entity (usually units) regenerate health
	MONEY_GEN_SPEED, //How quickly an entity generates extra money
	LENGTH //Doesn't correspond to an actual stat, just used to get the length of this
}

/*
function StatMultipliers() constructor { //TODO: Should all entities have all of these stats, or should they only have the ones they require?
	multipliers = array_create(STATS.LENGTH, 1)
	
	static get_stat_multiplier = function(_stat_type) {
		return multipliers[_stat_type];
	}
	
	//TODO: What about multiplication rounding errors (ex. 0.1 + 0.2 = 0.30000000000000004)
	static apply_new_multiplier = function(_stat_type, _multiplier) {
		multipliers[_stat_type] *= _multiplier;
	}
}*/

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
	max_health = 100;
	
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