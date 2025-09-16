/// @description Free up any data structures
part_emitter_destroy(global.PARTICLE_SYSTEM, rain_emitter);
part_emitter_destroy(global.PARTICLE_SYSTEM, spark_emitter);

ds_list_destroy(enemies_in_shock_area);