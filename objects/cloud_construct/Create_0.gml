/// @description Initialize variables for the Cloud Construct

//Entity stats
entity_data = new CloudConstruct();

//Current health (start at max health)
current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;

//Shooting functionality
targeting_tracker = 
new TargetingTracker([
				global.TARGETING_CLOSE,
				global.TARGETING_FIRST,
				global.TARGETING_LAST,
				global.TARGETING_HEALTHY,
				global.TARGETING_WEAK,
]);
	
cloud_timer = 0;
enemies_in_range = global.ALL_ENEMIES_LIST;
projectile_obj = cloud_attack;

//Buff-debuff list
buffs = []
			
//Buying + selling data
sell_price = global.DATA_PURCHASE_CLOUD.price * SELL_PRICE_REDUCTION;

stat_upgrades = [undefined, undefined, 
	undefined, undefined];

unit_upgrades = [undefined, undefined, undefined];

//Set up animation bank
animation_bank = global.ANIMBANK_CLOUD;
event_inherited();