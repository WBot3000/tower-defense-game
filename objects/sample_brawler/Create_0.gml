/// @description Initialize data structures

//NOTE: This unit is somewhat broken and kind of outdated, probably won't resemble how the game handles melee combat.
//NOTE 2: Wait, I think it might actually be an issue with the enemies having a larger attack radius.

name = "Sample Brawler";

max_health = 100;
current_health = 100;
health_state = UNIT_STATE.ACTIVE;
recovery_rate = 10; //In health points per second

radius = 1.0;
range = new BrawlerRange(id); //CircularRange(id, x + sprite_width/2, y + sprite_height/2, tilesize_to_pixels(radius));

punch_damage = 5
seconds_per_punch = 0.5

unit_buffs = [];

//Stat Upgrades
stat_upgrade_1 = undefined;
stat_upgrade_2 = undefined;
stat_upgrade_3 = undefined;
stat_upgrade_4 = undefined;

//Unit Upgrades
unit_upgrade_1 = undefined;
unit_upgrade_2 = undefined;
unit_upgrade_3 = undefined;

//Variables to keep track of and control things
enemies_in_range = ds_list_create();

punch_timer = 15;
curr_direction = DIRECTION.DOWN;

sell_price = 100 * SELL_PRICE_REDUCTION;

animation_controller = new AnimationController(self.id, spr_sample_brawler_down);

