/*
This file contains data about the Gold Construct and its upgrades
*/
global.ANIMBANK_GOLD = new UnitAnimationBank(spr_gold_construct)
global.ANIMBANK_GOLD.add_animation("GENERATE", spr_gold_construct_generate);

#region GoldConstruct (Class)
function GoldConstruct() : Unit() constructor {
	name = "Gold Construct"
	
	//Health variables
	max_health = 100;
	current_health = 100;
	health_state = HEALTH_STATE.ACTIVE;
	
	//Stat modifiers
	defense_factor = 0.75; //All taken damage is divided by this value
	recovery_rate = 5; //Health points per second
	
	//Purchasable upgrades
	stat_upgrades = [undefined, undefined, undefined, undefined];
	unit_upgrades = [undefined, undefined, undefined];
	
	//Things to be kept track of
	range = new CircularRange(inst, 0, 0, tilesize_to_pixels(3));
	targeting_tracker = 
	new TargetingTracker([
					global.TARGETING_CLOSE,
					global.TARGETING_FIRST,
					global.TARGETING_LAST,
					global.TARGETING_HEALTHY,
					global.TARGETING_WEAK,
	]);
	buffs = []
			
	action_queue = [
		new GenerateMoneyAction("GENERATE_MONEY", 25, seconds_to_roomspeed_frames(10))
	];
	
	//Unit sell price
	sell_price = global.DATA_PURCHASE_GOLD.price * SELL_PRICE_REDUCTION;
	
	//Internal variables mainly to make things easier
	animation_controller = new AnimationController(inst, global.ANIMBANK_GOLD);
}
#endregion


#region Gold Construct Stat Upgrades

#endregion


#region Gold Construct Unit Upgrades

#endregion