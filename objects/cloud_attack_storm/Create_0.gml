/// @description Initialize data structures
state = CLOUD_STATE.TRAVELING_TO_TARGET;
if(!variable_instance_exists(self.id, "owner")) {
	owner = noone
}

//seconds_to_linger = seconds_to_roomspeed_frames(8); //Should be in data passed to projectile
//seconds_to_damage = seconds_to_roomspeed_frames(1); //Should be in data passed to projectile

linger_timer = 0;
damage_timer = data.frames_to_damage/2; //Start the first hit of damage sooner, so that the cloud isn't just hovering over the enemy for an odd period of time.
lightning_timer = 0;

range = new GlobalRange(self.id)
entities_in_range = ds_list_create();

shock_area = new RectangularRange(self, x - 8, x + 8, y + 32, y + 64);
enemies_in_shock_area = ds_list_create();

rain_emitter = part_emitter_create(global.PARTICLE_SYSTEM);
part_emitter_region(global.PARTICLE_SYSTEM, rain_emitter, x - 8, x + 8, y + sprite_height, y + sprite_height, ps_shape_rectangle, ps_distr_linear);

spark_emitter = part_emitter_create(global.PARTICLE_SYSTEM);
part_emitter_region(global.PARTICLE_SYSTEM, spark_emitter, x - 8, x + 8, y + 32, y + 64, ps_shape_ellipse, ps_distr_gaussian);

animation_controller = new AnimationController(self, global.ANIMBANK_CLOUD_ATTACK_STORM);
animation_controller.set_animation("FORMING", 1);