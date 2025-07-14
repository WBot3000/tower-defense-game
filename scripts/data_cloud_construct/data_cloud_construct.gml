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
function CloudConstruct() : Unit() constructor {
	name = "Cloud Construct"
	
	//Health variables
	max_health = 60;
	current_health = 60;
	health_state = HEALTH_STATE.ACTIVE;
	
	//Stat modifiers
	defense_factor = 1; //All taken damage is divided by this value
	recovery_rate = 10; //Health points per second
	
	//Purchasable upgrades
	stat_upgrades = [undefined, undefined, undefined, undefined];
	unit_upgrades = [undefined, undefined, undefined];
	
	//Things to be kept track of
	range = new GlobalRange(inst);
	targeting_tracker = 
	new TargetingTracker([
					global.TARGETING_CLOSE,
					global.TARGETING_FIRST,
					global.TARGETING_LAST,
					global.TARGETING_HEALTHY,
					global.TARGETING_WEAK,
	]);
	buffs = []
	
	//List of all the "things" the unit can do while active
	var _projectile_data = {
				owner: inst,
				damage: 10, 
				travel_speed: 10,
				seconds_to_damage: seconds_to_roomspeed_frames(1),
				seconds_to_linger: seconds_to_roomspeed_frames(8)
			};
			
	action_queue = [
		new ShootProjectileAction("SHOOT", cloud_attack, [base_enemy], seconds_to_roomspeed_frames(6), _projectile_data)
	];
	
	//Unit sell price
	sell_price = global.DATA_PURCHASE_CLOUD.price * SELL_PRICE_REDUCTION;
	
	//Internal variables mainly to make things easier
	animation_controller = new AnimationController(inst, global.ANIMBANK_CLOUD);
}
#endregion


#region Cloud Construct Stat Upgrades

#endregion


#region Cloud Construct Unit Upgrades

#endregion