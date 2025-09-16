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
flamethrower_damage_timer = entity_data.frames_per_damage - 2;
enemies_in_range = ds_list_create();
flamethrower_target = noone;

//Flamethrower particles
flamethrower_effect = new ParticleBeam(spr_flame, self, noone, 1, BEAM_SPEED_DEFAULT, tilesize_to_pixels(0.5));
			
//Buying + selling data
sell_price = global.DATA_PURCHASE_FLAME.price * SELL_PRICE_REDUCTION;

stat_upgrades = [undefined, undefined, undefined, undefined];

unit_upgrades = [undefined, undefined, undefined];

//Set up animation bank
animation_bank = global.ANIMBANK_FLAME;
event_inherited();
