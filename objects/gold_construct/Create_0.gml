/// @description Initialize entity data

//Entity stats
entity_data = new GoldConstruct();

//Current health (start at max by default)
current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;

//Used for money generation
cached_round_manager = get_round_manager();
money_generation_timer = 0;

//Used for Midas Missile upgrade if purchased
targeting_tracker = 
new TargetingTracker([
				global.TARGETING_CLOSE,
				global.TARGETING_FIRST,
				global.TARGETING_LAST,
				global.TARGETING_HEALTHY,
				global.TARGETING_WEAK,
]);
enemies_in_range = ds_list_create();

//Buff-debuff list
buffs = [];

//Buying + selling data
sell_price = global.DATA_PURCHASE_GOLD.price * SELL_PRICE_REDUCTION;

stat_upgrades = [undefined, undefined, 
	undefined, undefined];

unit_upgrades = [undefined, undefined, undefined];
	
//Set up animation bank
animation_bank = global.ANIMBANK_GOLD;
event_inherited();