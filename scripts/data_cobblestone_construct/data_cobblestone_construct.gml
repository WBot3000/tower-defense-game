/*
This file contains data about the Cobblestone Construct and its upgrades
*/
global.ANIMBANK_COBBLESTONE = new UnitAnimationBank(spr_cobblestone_construct)
global.ANIMBANK_COBBLESTONE.add_animation("ATTACK", spr_cobblestone_construct);

#region CobblestoneConstruct (Class)
function CobblestoneConstruct() : CombatantData() constructor {
	name = "Cobblestone"
	
	//Health variables
	max_health = 100;

	//Stat modifiers
	defense_factor = 1.5; //All taken damage is divided by this value
	recovery_rate = 10; //Health points per second
	can_block = true; //TODO: Make this actually do something
	
	//Punch stuff
	frames_per_punch = seconds_to_roomspeed_frames(1);
	punch_damage = 10;
	
	sight_range = new MeleeRange(inst);
}
#endregion


#region Cobblestone Construct Stat Upgrades

#endregion


#region Cobblestone Construct Unit Upgrades

#endregion