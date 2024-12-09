/// @description Initialize variables and data structures

//var explosion_damage = 20; //This is currently defined in the effect function.
explosion_total_length = seconds_to_roomspeed_frames(3) //Explosion should be 3 seconds

explosion_range = new RectangularRange(self.id, x, y, x + sprite_width, y + sprite_height);
explosion_hitbox = new PersistentHitbox(explosion_range, mortar_cannonball_explosion_effect, 0.5);

//Helper variables
enemies_in_range = ds_list_create();
explosion_timer = 0;