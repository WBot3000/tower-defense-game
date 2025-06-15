/// @description Initialize variables for the Dirt Construct

//event_inherited(); //TODO: Use event inheritance?

unit_name = "Cloud Construct";

//Variables for managing unit health
max_health = 60;
current_health = 60;
health_state = UNIT_STATE.ACTIVE;
recovery_rate = 10; //In health points per second
defense_factor = 1;

direction_facing = DIRECTION_LEFT;

//Variables for managing unit's attack
range = new GlobalRange(self.id);
enemies_in_range = global.ALL_ENEMIES_LIST;
targeting_tracker = 
	new TargetingTracker([
					global.TARGETING_CLOSE,
					global.TARGETING_FIRST,
					global.TARGETING_LAST,
					global.TARGETING_HEALTHY,
					global.TARGETING_WEAK,
	]);
frames_per_cloud = seconds_to_roomspeed_frames(6);
cloud_timer = 0;
cloud_damage = 10;
cloud_speed = 10;

unit_buffs = [];

//Stat Upgrades
stat_upgrades = [undefined, undefined, undefined, undefined];

//Unit Upgrades
unit_upgrade_1 = undefined;
unit_upgrade_2 = undefined;
unit_upgrade_3 = undefined;

sell_price = global.DATA_PURCHASE_DIRT.price * SELL_PRICE_REDUCTION;

//TODO: Animation controller?