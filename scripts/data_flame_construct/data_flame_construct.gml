/*
This file contains data about the Flame Construct and its upgrades
*/
global.ANIMBANK_FLAME = new UnitAnimationBank(spr_flame_construct)
//global.ANIMBANK_FLAME.add_animation("SHOOT", spr_flame_construct_shooting);


#region FlameConstruct (Class)
function FlameConstruct() : CombatantData() constructor {
	name = "Flame Construct"
	
	//Stats
	max_health = 100;
	defense_factor = 1; //All taken damage is divided by this value
	recovery_rate = 10; //Health points per second
	damage = 1;
	frames_per_damage = 5;
	
	sight_range = new CircularRange(inst, 0, 0, tilesize_to_pixels(3));
}
#endregion


#region Flame Construct Stat Upgrades
#endregion


#region Flame Construct Unit Upgrades
#endregion