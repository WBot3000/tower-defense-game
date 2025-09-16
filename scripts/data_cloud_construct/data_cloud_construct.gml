/*
This file contains data about the Cloud Construct and its upgrades
*/
//TODO: Make a static ANIMBANK inside the appropriate entities for these instead of a global one
global.ANIMBANK_CLOUD = new UnitAnimationBank(spr_cloud_construct);
global.ANIMBANK_CLOUD.add_animation("SHOOT", spr_cloud_construct/*_shooting*/);

global.ANIMBANK_CLOUD_U1 = new UnitAnimationBank(spr_cloud_construct_u1);
global.ANIMBANK_CLOUD_U1.add_animation("SHOOT", spr_cloud_construct_u1/*_shooting*/);

global.ANIMBANK_CLOUD_ATTACK_NORMAL = new AnimationBank(spr_cloud_attack);
global.ANIMBANK_CLOUD_ATTACK_NORMAL.add_animation("FORMING", spr_cloud_attack_forming);
global.ANIMBANK_CLOUD_ATTACK_NORMAL.add_animation("DISSIPATING", spr_cloud_attack_dissipating);

global.ANIMBANK_CLOUD_ATTACK_STORM = new AnimationBank(spr_cloud_attack_storm);
global.ANIMBANK_CLOUD_ATTACK_STORM.add_animation("FORMING", spr_cloud_attack_storm_forming);
global.ANIMBANK_CLOUD_ATTACK_STORM.add_animation("DISSIPATING", spr_cloud_attack_storm_dissipating);
global.ANIMBANK_CLOUD_ATTACK_STORM.add_animation("LIGHTNING", spr_cloud_attack_storm_lightning);

#region CloudConstruct (Class)
function CloudConstruct() : CombatantData() constructor {
	name = "Cloud Construct"
	
	//Health variables
	max_health = 60;
	
	//Stat modifiers
	defense_factor = 1; //All taken damage is divided by this value
	recovery_rate = 10; //Health points per second
	frames_per_cloud = seconds_to_roomspeed_frames(8);
	frames_per_lightning = seconds_to_roomspeed_frames(3);

	sight_range = new GlobalRange(inst);
	
	projectile_data = {
				owner: inst,
				damage: 10, 
				travel_speed: 10,
				frames_to_damage: seconds_to_roomspeed_frames(1),
				frames_to_linger: seconds_to_roomspeed_frames(8),
				frames_to_lightning: seconds_to_roomspeed_frames(3)
			};
}
#endregion


#region Cloud Construct Stat Upgrades

#endregion


#region Cloud Construct Unit Upgrades
/*
	Upgrade from Cloud Construct to Static Shock
*/
function UpgradeCloudConstruct1(_unit = other) :
	UnitUpgrade("Root'n Shoot'n", 100, 0, 0, 0) constructor {
		new_animbank = global.ANIMBANK_CLOUD_U1;
		//new_stat_upgrade = new DirtConstructU1PierceUpgrade(_unit);
		
		static upgrade_fn = function() {
			unit_to_upgrade.projectile_obj = cloud_attack_storm;
		}
}
#endregion