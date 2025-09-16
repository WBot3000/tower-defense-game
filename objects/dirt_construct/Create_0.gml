/// @description Initialize entity data

//Entity stats
entity_data = new DirtConstruct();

//Current health (start at max by default)
//TODO: Move these up to base unit
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
	
shot_timer = 0;
enemies_in_range = ds_list_create();
projectile_obj = dirt_ball;
			
//Buying + selling data
sell_price = global.DATA_PURCHASE_DIRT.price * SELL_PRICE_REDUCTION;

stat_upgrades = [new DirtConstructDamageUpgrade(), new DirtConstructAttackSpeedUpgrade(), 
	new DirtConstructRestorationUpgrade(), undefined];

unit_upgrades = [new UpgradeDirtConstruct1(), undefined, undefined];

//Set up animation bank
animation_bank = global.ANIMBANK_DIRT;
event_inherited();
