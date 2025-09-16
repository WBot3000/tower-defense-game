/// @description Initialize data structures
state = CLOUD_STATE.TRAVELING_TO_TARGET;
if(!variable_instance_exists(self.id, "owner")) {
	owner = noone
}

//seconds_to_linger = seconds_to_roomspeed_frames(8); //Should be in data passed to projectile
//seconds_to_damage = seconds_to_roomspeed_frames(1); //Should be in data passed to projectile

linger_timer = 0;
damage_timer = data.frames_to_damage/2; //Start the first hit of damage sooner, so that the cloud isn't just hovering over the enemy for an odd period of time.

range = new GlobalRange(self.id)
enemies_in_range = global.ALL_ENEMIES_LIST; //Remember, don't destroy this! It's used globally.

rain_emitter = part_emitter_create(global.PARTICLE_SYSTEM);
part_emitter_region(global.PARTICLE_SYSTEM, rain_emitter, x - 8, x + 8, y + sprite_height, y + sprite_height, ps_shape_rectangle, ps_distr_linear);

animation_controller = new AnimationController(self, global.ANIMBANK_CLOUD_ATTACK_NORMAL);
animation_controller.set_animation("FORMING", 1);