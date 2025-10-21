/// @description Initialize entity data

//Entity stats
entity_data = new FlameConstruct();

//Current health (start at max by default)
//TODO: Move these up to base unit
current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;

//Flamethrower functionality
targeting_tracker = 
new TargetingTracker([
				global.TARGETING_CLOSE,
				global.TARGETING_FIRST,
				global.TARGETING_LAST,
				global.TARGETING_HEALTHY,
				global.TARGETING_WEAK,
]);

flamethrowers = [new FlameConstructFlamethrower(self)];
enemies_in_range = ds_list_create();
current_targets = [];

			
//Buying + selling data
sell_price = global.DATA_PURCHASE_FLAME.price * SELL_PRICE_REDUCTION;

stat_upgrades = [new DirtConstructAttackSpeedUpgrade(), new DirtConstructAttackSpeedUpgrade(), 
	new DirtConstructAttackSpeedUpgrade(), undefined]; //Just placeholders so unit upgrades work

unit_upgrades = [new UpgradeFlameConstruct1(), undefined, undefined];

//Set up animation bank
animation_bank = global.ANIMBANK_FLAME;
event_inherited();
