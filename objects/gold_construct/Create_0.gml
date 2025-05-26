/// @description Initialize variables for the Dirt Construct

//event_inherited(); //TODO: Use event inheritance?

unit_name = "Gold Construct";

//Variables for managing unit health
max_health = 100;
current_health = 100;
health_state = UNIT_STATE.ACTIVE;
recovery_rate = 5; //In health points per second
defense_factor = 0.75;

direction_facing = DIRECTION_LEFT;

//Variables for managing unit's attack
range = new CircularRange(self.id, get_bbox_center_x(self), get_bbox_center_y(self), tilesize_to_pixels(3));
targeting_tracker = 
	new TargetingTracker([
					global.TARGETING_CLOSE,
					global.TARGETING_FIRST,
					global.TARGETING_LAST,
					global.TARGETING_HEALTHY,
					global.TARGETING_WEAK,
	]);

unit_buffs = [];

money_generation_amount = 25;
frames_per_generation = seconds_to_roomspeed_frames(10);
money_generation_timer = 0;

cached_round_manager = get_round_manager();

//Stat Upgrades
stat_upgrades = [undefined, undefined, undefined, undefined];

//Unit Upgrades
unit_upgrade_1 = undefined;
unit_upgrade_2 = undefined;
unit_upgrade_3 = undefined;

sell_price = global.DATA_PURCHASE_GOLD.price * SELL_PRICE_REDUCTION;

//TODO: Animation controller?

/*
//Particle Stuff!
particle_system = part_system_create_layer(PARTICLE_LAYER, false);
particle_sparkle = part_type_create();

// This defines the particle's shape
part_type_sprite(particle_sparkle, spr_sparkle, true, true, false);
// This is for the size
part_type_size(particle_sparkle,1,1,0,0);

// This sets its colour. There are three different codes for this
//part_type_color2(particle_sparkle,c_yellow,c_white);

// This is its alpha. There are three different codes for this
part_type_alpha2(particle_sparkle,1,0);

// The particles speed
part_type_speed(particle_sparkle,0.0,0,0,0);

// The direction
part_type_direction(particle_sparkle,0,0,0,0);

// This changes the rotation of the particle
part_type_orientation(particle_sparkle,0,0,0,0,true);

// This is the blend mode, either additive or normal
part_type_blend(particle_sparkle,0);

// This is its lifespan in steps
part_type_life(particle_sparkle,20,40);*/