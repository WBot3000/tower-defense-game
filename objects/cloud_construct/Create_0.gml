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
projectile_obj = cloud_attack;
			
//Buying + selling data
sell_price = global.DATA_PURCHASE_CLOUD.price * SELL_PRICE_REDUCTION;

stat_upgrades = [new DirtConstructAttackSpeedUpgrade(), new DirtConstructAttackSpeedUpgrade(), 
	new DirtConstructAttackSpeedUpgrade(), undefined]; //Just placeholders so unit upgrades work

unit_upgrades = [new UpgradeCloudConstruct1(), undefined, undefined];

//Set up animation bank
animation_bank = global.ANIMBANK_CLOUD;
event_inherited();