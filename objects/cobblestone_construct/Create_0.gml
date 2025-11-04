/// @description Initialize entity data

//Entity stats
entity_data = new CobblestoneConstruct();

//Current health (start at max by default)
current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;

//Punching functionality
targeting_tracker = 
new TargetingTracker([
				global.TARGETING_CLOSE,
				global.TARGETING_FIRST,
				global.TARGETING_LAST,
				global.TARGETING_HEALTHY,
				global.TARGETING_WEAK,
]);
	
punch_timer = 0;
punch_counter = 0; //Amount of punches needed for earthquake event for first upgraded

			
//Buying + selling data
sell_price = global.DATA_PURCHASE_COBBLESTONE.price * SELL_PRICE_REDUCTION;

stat_upgrades = [new DirtConstructAttackSpeedUpgrade(), new DirtConstructAttackSpeedUpgrade(), 
	new DirtConstructAttackSpeedUpgrade(), undefined];

unit_upgrades = [new UpgradeCobblestoneConstruct1(), undefined, undefined];
upgrade_purchased = 0;

//Set up animation bank
animation_bank = global.ANIMBANK_COBBLESTONE;
event_inherited();

//Blocking functionality
//TODO: Wrap all the stuff required for setting up blocking in a function of some sort maybe
broadcast_hub.register_event(EVENT_END_BLOCK);