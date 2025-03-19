/// @description Initialize variables and data structures

unit_name = "Sample Gunner";

max_health = 100;
current_health = 100;
health_state = UNIT_STATE.ACTIVE;
recovery_rate = 10; //In health points per second

radius = 2.5; //TODO: Maybe make name clearer
range = new CircularRange(id, x + sprite_width/2, y + sprite_height/2, tilesize_to_pixels(radius));

shooting_speed = 8;
seconds_per_shot = 2;

bullet_damage = 10;

unit_buffs = [];

//Stat Upgrades
stat_upgrade_1 = new SampleGunnerAttackSpeedUpgrade(self.id);
stat_upgrade_2 = new SampleGunnerDamageUpgrade(self.id);
stat_upgrade_3 = new SampleGunnerRangeUpgrade(self.id);
stat_upgrade_4 = undefined;

//Unit Upgrades
unit_upgrade_1 = new UpgradeToSampleGunnerUpgrade1(); //TODO: If this is just reference data, don't need to create a new one for each individual unit, just create once
unit_upgrade_2 = new UpgradeToSampleGunnerUpgrade1();
unit_upgrade_3 = new UpgradeToSampleGunnerUpgrade1();


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

shot_timer = 90; //When the unit is placed, takes less time to take a shot.

sell_price = 100 * SELL_PRICE_REDUCTION;

animation_controller = new AnimationController(self.id, spr_sample_gunner);



