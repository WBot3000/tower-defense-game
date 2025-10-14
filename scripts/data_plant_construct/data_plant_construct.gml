/*
This file contains data about the Plant Construct and its upgrades
*/
global.ANIMBANK_PLANT = new UnitAnimationBank(spr_plant_construct)

//global.ANIMBANK_PLANT_U1 = new UnitAnimationBank(spr_plant_construct_u1);


#region PlantConstruct (Class)
function PlantConstruct() : CombatantData() constructor {
	name = "Plant"
	
	//Stats
	max_health = 100;
	defense_factor = 1; //All taken damage is divided by this value
	recovery_rate = 5; //Health points per second
	frames_per_restoration = seconds_to_roomspeed_frames(5);
	healing_amount = 10;
	
	sight_range = new CircularRange(inst, 0, 0, tilesize_to_pixels(2));
}
#endregion


#region Plant Construct Stat Upgrades
#endregion


#region Plant Construct Unit Upgrades
#endregion