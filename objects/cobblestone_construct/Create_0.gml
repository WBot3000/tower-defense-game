/// @description Initialize data structures

unit_name = "Cobblestone Construct";

max_health = 100;
current_health = 100;
health_state = UNIT_STATE.ACTIVE;
recovery_rate = 10; //In health points per second
defense_factor = 1.5;

direction_facing = DIRECTION_LEFT;

radius = 1.0;
range = new MeleeRange(self.id);
punch_damage = 5
frames_per_punch = seconds_to_roomspeed_frames(0.5)
punch_timer = 0;

unit_buffs = [];

//Stat Upgrades
stat_upgrades = [undefined, undefined, undefined, undefined];

//Unit Upgrades
unit_upgrade_1 = undefined;
unit_upgrade_2 = undefined;
unit_upgrade_3 = undefined;

//Variables to keep track of and control things
enemies_in_range = ds_list_create();

targeting_tracker = 
	new TargetingTracker([
					global.TARGETING_CLOSE,
					global.TARGETING_FIRST,
					global.TARGETING_LAST,
					global.TARGETING_HEALTHY,
					global.TARGETING_WEAK,
	]);


//curr_direction = DIRECTION.DOWN;

sell_price = 100 * SELL_PRICE_REDUCTION;

//animation_controller = new OldAnimationController(self.id, spr_sample_brawler_down);

