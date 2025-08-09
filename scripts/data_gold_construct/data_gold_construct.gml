/*
This file contains data about the Gold Construct and its upgrades
*/
global.ANIMBANK_GOLD = new UnitAnimationBank(spr_gold_construct)
global.ANIMBANK_GOLD.add_animation("GENERATE", spr_gold_construct_generate);

#region GoldConstruct (Class)
function GoldConstruct() : CombatantData() constructor {
	name = "Gold Construct"
	
	//Health variables
	max_health = 100;
	
	//Stat modifiers
	defense_factor = 0.75; //All taken damage is divided by this value
	recovery_rate = 5; //Health points per second
	frames_per_generation = seconds_to_roomspeed_frames(8);
	money_generation_amount = 50;
	
	sight_range = new CircularRange(inst, 0, 0, tilesize_to_pixels(3));
}
#endregion


#region Gold Construct Stat Upgrades

#endregion


#region Gold Construct Unit Upgrades

#endregion