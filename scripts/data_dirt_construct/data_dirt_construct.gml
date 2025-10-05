/*
This file contains data about the Dirt Construct and its upgrades
*/
global.ANIMBANK_DIRT = new UnitAnimationBank(spr_dirt_construct)
global.ANIMBANK_DIRT.add_animation("SHOOT", spr_dirt_construct_shooting);

global.ANIMBANK_DIRT_U1 = new UnitAnimationBank(spr_dirt_construct_u1);
global.ANIMBANK_DIRT_U1.add_animation("SHOOT", spr_dirt_construct_u1_shooting);

#region DirtConstruct (Class)
function DirtConstruct() : CombatantData() constructor {
	name = "Dirt"
	
	//Stats
	max_health = 100;
	defense_factor = 1; //All taken damage is divided by this value
	recovery_rate = 10; //Health points per second
	frames_per_shot = seconds_to_roomspeed_frames(2);
	
	sight_range = new CircularRange(inst, 0, 0, tilesize_to_pixels(3));

	projectile_data = {
				damage: 10, 
				travel_speed: 15,
				pierce: 1
			};
}
#endregion


#region Dirt Construct Stat Upgrades

#region DirtConstructDamageUpgrade
/*
	Damage upgrade for Dirt Construct
*/
function DirtConstructDamageUpgrade(_unit = other) : 
	StatUpgrade("Dirty Trick", 5, 0,
		"Increase damage by 10 with each upgrade.", spr_increase_damage_icon, _unit) constructor {

	static upgrade_stats_fn = function() {
		unit.entity_data.projectile_data.damage += 10;
	}
	
	static price_fn = function(upgrade_level) {
		return upgrade_level * 10;
	}
	current_price = price_fn(current_level+1);
}
#endregion


#region DirtConstructAttackSpeedUpgrade
/*
	Attack speed upgrade for Dirt Construct
*/
function DirtConstructAttackSpeedUpgrade(_unit = other) : 
	StatUpgrade("Muck-chine Gun", 5, 0, 
		"Decrease attack speed by 0.3 seconds with each upgrade.", spr_increase_attack_speed_icon, _unit) constructor {
			
	static upgrade_stats_fn = function() {
		unit.entity_data.frames_per_shot -= seconds_to_roomspeed_frames(0.3)
	}
	
	static price_fn = function(upgrade_level) {
		return upgrade_level * 10;
	}
	//Need to reset the starting price if we update the price function, as the intialized starting price was called with the base price function (which always returns 0)
	current_price = price_fn(current_level+1);
}
#endregion


#region DirtConstructRestorationUpgrade
/*
	Restoration rate upgrade for Dirt Construct
*/
function DirtConstructRestorationUpgrade(_unit = other) : 
	StatUpgrade("Hearty Soil", 5, 0,
		"Increase recovery rate by 5 HP/second with each upgrade.", spr_increase_health_icon, _unit) constructor {

	static upgrade_stats_fn = function() {
		unit.entity_data.recovery_rate += 5;
	}
	
	static price_fn = function(upgrade_level) {
		return upgrade_level * 10;
	}
	current_price = price_fn(current_level+1);
}
#endregion


#region DirtConstructU1PierceUpgrade
/*
	Restoration rate upgrade for Sample Gunner
	
	TODO: Write variables for this
*/
function DirtConstructU1PierceUpgrade(_unit = other) : 
	StatUpgrade("Sharp-rooter", 5, 0,
		"Lets the root projectile pierce an additional enemy with each upgrade.", spr_increase_attack_speed_icon, _unit) constructor {

	static upgrade_stats_fn = function() {
		unit.entity_data.projectile_data.pierce++;
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
function UpgradeDirtConstruct1(_unit = other) :
	UnitUpgrade("Root'n Shoot'n", 100, 3, 0, 0) constructor {
		new_animbank = global.ANIMBANK_DIRT_U1;
		new_stat_upgrade = new DirtConstructU1PierceUpgrade(_unit);
		
		static upgrade_fn = function() {
			
			unit_to_upgrade.projectile_obj = piercing_root;
			unit_to_upgrade.entity_data.projectile_data.pierce = 3;
		}
}
#endregion