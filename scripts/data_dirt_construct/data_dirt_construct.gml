/*
This file contains data about the Dirt Construct and its upgrades
*/
global.DATA_UNIT_DIRT_ANIMBANK = new UnitAnimationBank(spr_dirt_construct)
global.DATA_UNIT_DIRT_ANIMBANK.add_animation("SHOOT", spr_dirt_construct_shooting);

global.DATA_UNIT_DIRT_U1_ANIMBANK = new UnitAnimationBank(spr_dirt_construct_u1);
global.DATA_UNIT_DIRT_U1_ANIMBANK.add_animation("SHOOT", spr_dirt_construct_u1_shooting);

#region Dirt Construct Stat Upgrades
#region DirtConstructAttackSpeedUpgrade
/*
	Attack speed upgrade for Dirt Construct
	
	TODO: Write variables for this
*/
function DirtConstructAttackSpeedUpgrade(_unit) : 
	StatUpgrade(_unit, "Faster Firing", 5, 0, 
		"Decrease attack speed by 0.3 seconds with each upgrade.", spr_increase_attack_speed_icon) constructor {
			
	static upgrade_stats_fn = function() {
		unit.frames_per_shot -= seconds_to_roomspeed_frames(0.3)
	}
	
	static price_fn = function(upgrade_level) {
		return upgrade_level * 10;
	}
	//Need to reset the starting price if we update the price function, as the intialized starting price was called with the base price function (which always returns 0)
	current_price = price_fn(current_level+1);
}
#endregion


#region DirtConstructDamageUpgrade
/*
	Damage upgrade for Dirt Construct
	
	TODO: Write variables for this
*/
function DirtConstructDamageUpgrade(_unit) : 
	StatUpgrade(_unit, "Stronger Shots", 5, 0,
		"Increase damage by 10 with each upgrade.", spr_increase_damage_icon) constructor {

	static upgrade_stats_fn = function() {
		unit.shot_damage += 10;
	}
	
	static price_fn = function(upgrade_level) {
		return upgrade_level * 10;
	}
	current_price = price_fn(current_level+1);
}
#endregion


#region DirtConstructRestorationUpgrade
/*
	Restoration rate upgrade for Sample Gunner
	
	TODO: Write variables for this
*/
function DirtConstructRestorationUpgrade(_unit) : 
	StatUpgrade(_unit, "Quicker Recovery", 5, 0,
		"Increase recovery rate by 5 HP/second with each upgrade.", spr_increase_health_icon) constructor {

	static upgrade_stats_fn = function() {
		unit.recovery_rate += 5;
	}
	
	static price_fn = function(upgrade_level) {
		return upgrade_level * 10;
	}
	current_price = price_fn(current_level+1);
}
#endregion
#endregion


#region Dirt Construct Unit Upgrades
/*
	Upgrade from Dirt Construct to Root'n Shoot'n
*/
function UpgradeDirtConstruct1() :
	UnitUpgrade(dirt_construct_u1, 100, 3, 0, 0) constructor {
}
#endregion