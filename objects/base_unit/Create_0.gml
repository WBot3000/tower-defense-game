/// @description Initialize data structures

unit_name = "NAME_NOT_PROVIDED";

max_health = 0;
current_health = 0;
health_state = UNIT_STATE.ACTIVE;
recovery_rate = 0; //In health points per second

radius = 0.0;

unit_buffs = [];

//Stat Upgrades
stat_upgrades = [undefined, undefined, undefined, undefined];

//Unit Upgrades
unit_upgrade_1 = undefined;
unit_upgrade_2 = undefined;
unit_upgrade_3 = undefined;

sell_price = 0;

//Variables to keep track of things
enemies_in_range = ds_list_create();

targeting_tracker = new TargetingTracker([]);


