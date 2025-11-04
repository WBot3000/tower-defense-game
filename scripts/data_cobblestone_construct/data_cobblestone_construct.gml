/*
This file contains data about the Cobblestone Construct and its upgrades
*/
global.ANIMBANK_COBBLESTONE = new UnitAnimationBank(spr_cobblestone_construct);
global.ANIMBANK_COBBLESTONE.add_animation("ATTACK", spr_cobblestone_construct);

global.ANIMBANK_COBBLESTONE_U1 = new UnitAnimationBank(spr_cobblestone_construct_u1);
global.ANIMBANK_COBBLESTONE_U1.add_animation("ATTACK", spr_cobblestone_construct_u1);

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
/*
	Upgrade from Cobblestone Construct to Rubble Rouser
*/
function UpgradeCobblestoneConstruct1(_unit = other) :
	UnitUpgrade("Rubble Rouser", 100, 0, 0, 0) constructor {
		new_animbank = global.ANIMBANK_COBBLESTONE_U1;
		//new_stat_upgrade = new DirtConstructU1PierceUpgrade(_unit);
		
		static upgrade_fn = function() {
			unit_to_upgrade.upgrade_purchased = 1;
		}
}
#endregion