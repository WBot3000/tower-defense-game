/*
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


#region UnitUpgrade
/*
	Contains code that keep tracks of a unit's "level" in a certain stat.
	Increasing the level of the upgrade will increase that stat by a certain amount.
	
	Argument Variables:
	_starting_level: The level at which the upgrade should start at.
		TODO: Should standard "starting level" be 0 or 1?
	(All other argument variables correspond with non-underscored data variables)
	
	Data Variables:
	unit: The unit that this upgrade level belongs to.
	current_level: The current level at which the upgrade is at.
	max_level: The maximum level that the upgrade can be.
	description: A short description of what upgrading this stat does.
	current_cost: The current cost of purchasing the next level.
	cost_fn: A function that can be used to calculate the cost of purchasing upgrade level n.
		- Should take in a level parameter.
		- Useful for not hardcoding in any costs.
	on_upgrade: A function that determines what happens upon the upgrade's purchase. Responsible for increasing any relevant stats and updating the cost.
	upgrade_spr: The sprite used in the Unit Info Card
*/
function UnitUpgrade(_unit, _max_level, _starting_level = 0, _description = "No description provided", _upgrade_spr = spr_increase_attack_speed_icon) constructor {
	unit = _unit;
	
	current_level = _starting_level;
	max_level = _max_level;
	
	description = _description;
	
	cost_fn = function(){};
	current_cost = 0;
	
	on_upgrade = function(){};
	
	upgrade_spr = _upgrade_spr;
}
#endregion

#region Sample Gunner Upgrades
#region SampleGunnerAttackSpeedUpgrade
/*
	Attack speed upgrade for Sample Gunner
	
	TODO: Write variables for this
*/
function SampleGunnerAttackSpeedUpgrade(_unit) : 
	UnitUpgrade(_unit, 5, 0, "Decrease attack speed by 0.3 seconds with each upgrade.", spr_increase_attack_speed_icon) constructor {
		
	cost_fn = function(upgrade_level) {
		return 10*upgrade_level;
	}
	current_cost = cost_fn(1);
	
	on_upgrade = function() {
		unit.seconds_per_shot -= 0.3;
		current_level++;
		current_cost = cost_fn(current_level+1);
	}
}
#endregion


#region SampleGunnerDamageUpgrade
/*
	Damage upgrade for Sample Gunner
	
	TODO: Write variables for this
*/
function SampleGunnerDamageUpgrade(_unit) : 
	UnitUpgrade(_unit, 5, 0, "Increase damage by 10 with each upgrade.", spr_increase_damage_icon) constructor {
		
	cost_fn = function(upgrade_level) {
		return 10*upgrade_level;
	}
	current_cost = cost_fn(1);
	
	on_upgrade = function() {
		unit.bullet_damage += 10;
		current_level++;
		current_cost = cost_fn(current_level+1);
	}
}
#endregion


#region SampleGunnerRangeUpgrade
/*
	Range for Sample Gunner
	
	TODO: Write variables for this
*/
function SampleGunnerRangeUpgrade(_unit) : 
	UnitUpgrade(_unit, 5, 0, "Increase radius by half a tile with each upgrade.", spr_increase_range_icon) constructor {
		
	cost_fn = function(upgrade_level) {
		return 10*upgrade_level;
	}
	current_cost = cost_fn(1);
	
	on_upgrade = function() {
		unit.range.radius += TILE_SIZE/2;
		current_level++;
		current_cost = cost_fn(current_level+1);
	}
}
#endregion
#endregion