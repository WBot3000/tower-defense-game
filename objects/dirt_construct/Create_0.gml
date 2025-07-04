/// @description Initialize variables for the Dirt Construct

//event_inherited(); //TODO: Use event inheritance?

unit_name = "Dirt Construct";

//Variables for managing unit health
max_health = 100;
current_health = 100;
health_state = UNIT_STATE.ACTIVE;
recovery_rate = 10; //In health points per second
defense_factor = 1;

direction_facing = DIRECTION_LEFT;

//Variables for managing unit's attack
range = new CircularRange(self.id, get_bbox_center_x(self), get_bbox_center_y(self), tilesize_to_pixels(3));
enemies_in_range = ds_list_create();
targeting_tracker = 
	new TargetingTracker([
					global.TARGETING_CLOSE,
					global.TARGETING_FIRST,
					global.TARGETING_LAST,
					global.TARGETING_HEALTHY,
					global.TARGETING_WEAK,
	]);
frames_per_shot = seconds_to_roomspeed_frames(2);
shot_timer = 0;
shot_damage = 10;
shot_speed = 15;

unit_buffs = [];

//Stat Upgrades (TODO: Currently bugged, probably need to update some UI code too)
stat_upgrades = [new DirtConstructDamageUpgrade(self.id), new DirtConstructAttackSpeedUpgrade(self.id), 
	new DirtConstructRestorationUpgrade(self.id), undefined];

//Unit Upgrades
unit_upgrade_1 = new UpgradeDirtConstruct1();
unit_upgrade_2 = undefined;
unit_upgrade_3 = undefined;

sell_price = global.DATA_PURCHASE_DIRT.price * SELL_PRICE_REDUCTION;

//TODO: Animation controller?
animation_controller = new AnimationController(self, global.DATA_UNIT_DIRT_ANIMBANK);