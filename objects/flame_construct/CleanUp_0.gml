/// @description Clean up data structures and unregister from events
event_inherited();

ds_list_destroy(enemies_in_range);

flamethrower_effect.destroy_particle_beam();