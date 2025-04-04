/*
	data_unit.gml
	
	This file contains data for all the different types of units in the game.
	Sometimes, we might need to refer to some stats that a unit has before initializing any instances of that unit.
	This data can be used to refer to units in these instances.
	This data is also used when the corresponding unit is created.
*/

//Used to determine whether a unit should perform its tasks, or whether it needs to recover first.
enum UNIT_STATE {
	ACTIVE,
	KNOCKED_OUT
}


function Unit() constructor {
}


#region StatUpgrade
/*
	Contains code that keep tracks of a unit's "level" in a certain stat.
	Increasing the level of the upgrade will increase that stat by a certain amount.
	
	Argument Variables:
	_starting_level: The level at which the upgrade should start at.
		TODO: Should standard "starting level" be 0 or 1?
	(All other argument variables correspond with non-underscored data variables)
	
	Data Variables:
	unit: The unit that this upgrade level belongs to.
	title: What this stat is referred to when checking the highlighted information.
	current_level: The current level at which the upgrade is at.
	max_level: The maximum level that the upgrade can be.
	upgrade_stats_fn: A function that determines what happens upon the upgrade's purchase.
	on_upgrade: A function that calls upgrade_stats_fn, as well as increasing the level, updating the unit's sell price, and updating it's own sell price based on the price_fn
	description: A short description of what upgrading this stat does.
	current_price: The current cost of purchasing the next level.
	price_fn: A function that can be used to calculate the cost of purchasing upgrade level n.
		- Should take in a level parameter.
		- Useful for not hardcoding in any costs.
	upgrade_spr: The sprite used in the Unit Info Card
*/
function StatUpgrade(_unit, _title = "No Name", _max_level = 5, _starting_level = 0,
	_description = "No description provided", _upgrade_spr = spr_increase_attack_speed_icon) constructor {
	unit = _unit;
	title = _title;
	
	current_level = _starting_level;
	max_level = _max_level;
	
	//This function should perform the actual changing of stats and nothing else.
	//The on_upgrade function will call this IN ADDITION to performing all the background tasks, such as:
		// increasing the level of the upgrade
		// adjusting the next upgrade's price
		// adjusting the unit's sell value
	static upgrade_stats_fn = function() {};
	
	//Call when an upgrade is purchased.
	static on_upgrade = function() {
		upgrade_stats_fn();
		unit.sell_price = (unit.sell_price ?? 0) + (current_price * SELL_PRICE_REDUCTION)
		current_level++;
		current_price = price_fn(current_level+1);
	};
	
	description = _description;
	
	static price_fn = function(upgrade_level) { return 0; };
	current_price = price_fn(_starting_level+1);
	
	upgrade_spr = _upgrade_spr;
}
#endregion


#region UnitUpgrade
/*
	Contains code for upgrading one unit into a stronger version of itself. Contains the pre-requisites and cost of the upgrade.
	
	Argument Variables:
	(All argument variables correspond with non-underscored data variables)
	
	Data Variables:
	upgrade_to: The unit that should be upgraded into upon getting the upgrade.
	price: How much the upgrade costs to purchase.
	level_req_1: The level the unit's first upgradable stat needs to be in order to get purchased
	level_req_2: The level the unit's second upgradable stat needs to be in order to get purchased
	level_req_3: The level the unit's third upgradable stat needs to be in order to get purchased
	
*/
function UnitUpgrade(_upgrade_to, _price, _level_req_1 = 0, _level_req_2 = 0, _level_req_3 = 0) constructor {
	upgrade_to = _upgrade_to;
	price = _price;
	
	level_req_1 = _level_req_1;
	level_req_2 = _level_req_2;
	level_req_3 = _level_req_3;
}
#endregion


#region Sample Gunner Data

#region Sample Gunner Stat Upgrades
#region SampleGunnerAttackSpeedUpgrade
/*
	Attack speed upgrade for Sample Gunner
	
	TODO: Write variables for this
*/
function SampleGunnerAttackSpeedUpgrade(_unit) : 
	StatUpgrade(_unit, "Faster Firing", 5, 0, 
		"Decrease attack speed by 0.3 seconds with each upgrade.", spr_increase_attack_speed_icon) constructor {
	/*
	price_fn = function(upgrade_level) {
		return 10*upgrade_level;
	}
	current_price = price_fn(1);
	
	on_upgrade = function() {
		unit.seconds_per_shot -= 0.3;
		current_level++;
		current_price = price_fn(current_level+1);
	}*/
	static upgrade_stats_fn = function() {
		unit.seconds_per_shot -= 0.3
	}
	
	static price_fn = function(upgrade_level) {
		return upgrade_level * 10;
	}
	//Need to reset the starting price if we update the price function, as the intialized starting price was called with the base price function (which always returns 0)
	current_price = price_fn(current_level+1);
}
#endregion


#region SampleGunnerDamageUpgrade
/*
	Damage upgrade for Sample Gunner
	
	TODO: Write variables for this
*/
function SampleGunnerDamageUpgrade(_unit) : 
	StatUpgrade(_unit, "Stronger Shots", 5, 0,
		"Increase damage by 10 with each upgrade.", spr_increase_damage_icon) constructor {

	static upgrade_stats_fn = function() {
		unit.bullet_damage += 10;
	}
	
	static price_fn = function(upgrade_level) {
		return upgrade_level * 10;
	}
	current_price = price_fn(current_level+1);
}
#endregion


#region SampleGunnerRangeUpgrade
/*
	Range for Sample Gunner
	
	TODO: Write variables for this
*/
function SampleGunnerRangeUpgrade(_unit) : 
	StatUpgrade(_unit, "Binocular Power", 5, 0,
		"Increase radius by half a tile with each upgrade.", spr_increase_range_icon) constructor {

	static upgrade_stats_fn = function() {
		unit.range.radius += TILE_SIZE/2;
	}
	
	static price_fn = function(upgrade_level) {
		return upgrade_level * 10;
	}
	current_price = price_fn(current_level+1);
}
#endregion
#endregion


#region Sample Gunner Unit Upgrades
/*
	Upgrade from Sample Gunner to Sample Gunner Upgrade 1
*/
function UpgradeToSampleGunnerUpgrade1() :
	UnitUpgrade(sample_gunner_upgrade_1, 100, 2, 0, 3) constructor {
}
#endregion

#endregion