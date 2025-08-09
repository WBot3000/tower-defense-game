/*
This file contains data about the Cloud Construct and its upgrades
*/
//TODO: Make a static ANIMBANK inside the appropriate entities for these instead of a global one
global.ANIMBANK_CLOUD = new UnitAnimationBank(spr_cloud_construct);
global.ANIMBANK_CLOUD.add_animation("SHOOT", spr_cloud_construct/*_shooting*/);

global.ANIMBANK_CLOUD_ATTACK = new AnimationBank(spr_cloud_attack);
global.ANIMBANK_CLOUD_ATTACK.add_animation("FORMING", spr_cloud_attack_forming);
global.ANIMBANK_CLOUD_ATTACK.add_animation("DISSIPATING", spr_cloud_attack_dissipating);

#region CloudConstruct (Class)
function CloudConstruct() : CombatantData() constructor {
	name = "Cloud Construct"
	
	//Health variables
	max_health = 60;
	
	//Stat modifiers
	defense_factor = 1; //All taken damage is divided by this value
	recovery_rate = 10; //Health points per second
	frames_per_cloud = seconds_to_roomspeed_frames(8);

	sight_range = new GlobalRange(inst);
	
	projectile_data = {
				owner: inst,
				damage: 10, 
				travel_speed: 10,
				seconds_to_damage: seconds_to_roomspeed_frames(1),
				seconds_to_linger: seconds_to_roomspeed_frames(8)
			};
}
#endregion


#region Cloud Construct Stat Upgrades

#endregion


#region Cloud Construct Unit Upgrades

#endregion