/*
This file contains data about the Dirt Construct and its upgrades
*/
global.ANIMBANK_COBBLESTONE = new UnitAnimationBank(spr_cobblestone_construct)
global.ANIMBANK_COBBLESTONE.add_animation("ATTACK", spr_cobblestone_construct);

#region CobblestoneConstruct (Class)
function CobblestoneConstruct() : Unit() constructor {
	name = "Cobblestone Construct"
	
	//Health variables
	max_health = 100;
	current_health = 100;
	health_state = HEALTH_STATE.ACTIVE;
	
	//Stat modifiers
	defense_factor = 1.5; //All taken damage is divided by this value
	recovery_rate = 10; //Health points per second
	
	//Purchasable upgrades
	stat_upgrades = [undefined, undefined, undefined, undefined];
	unit_upgrades = [undefined, undefined, undefined];
	
	//Things to be kept track of
	range = new MeleeRange(inst);
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
		new DirectDamageAction("PUNCH", [base_enemy], seconds_to_roomspeed_frames(0.5), 5, spr_punch)
	];
	
	//Unit sell price
	sell_price = global.DATA_PURCHASE_COBBLESTONE.price * SELL_PRICE_REDUCTION;
	
	//Internal variables mainly to make things easier
	animation_controller = new AnimationController(inst, global.ANIMBANK_COBBLESTONE);
}
#endregion


#region Cobblestone Construct Stat Upgrades

#endregion


#region Dirt Construct Unit Upgrades

#endregion