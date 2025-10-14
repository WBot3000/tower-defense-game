/// @description Initialize entity data

//Entity stats
entity_data = new PlantConstruct();

//Current health (start at max by default)
current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;

//Used for health restoration
cached_round_manager = get_round_manager();
health_restoration_timer = 0;

/*
//Used for something maybe idk yet
targeting_tracker = 
new TargetingTracker([
				global.TARGETING_HEALTHY,
				global.TARGETING_WEAK,
]);*/
entities_in_range = ds_list_create();

//Buying + selling data
sell_price = global.DATA_PURCHASE_PLANT.price * SELL_PRICE_REDUCTION;

stat_upgrades = [new DirtConstructAttackSpeedUpgrade(), new DirtConstructAttackSpeedUpgrade(), 
	new DirtConstructAttackSpeedUpgrade(), undefined];

unit_upgrades = [undefined, undefined, undefined];
upgrade_purchased = 0; //Used to determine which unit upgrade was purchased after buying it.
	
//Set up animation bank
animation_bank = global.ANIMBANK_PLANT;
event_inherited();