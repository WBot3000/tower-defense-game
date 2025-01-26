/// @description Initialize variables and data structures

name = "Sample Mortar";

max_health = 100;
current_health = 100;
health_state = UNIT_STATE.ACTIVE;
recovery_rate = 10; //In health points per second

radius = 4; //TODO: Maybe make name clearer
range = new CircularRange(id, x + sprite_width/2, y + sprite_height/2, tilesize_to_pixels(radius));

shooting_speed = 6;
seconds_per_shot = 4;

special = false; //Determines if you can have more than one of a unit out

unit_buffs = [];

//Variables to keep track of and control things
enemies_in_range = ds_list_create();

shot_timer = 120; //When the unit is placed, takes less time to take a shot.

animation_controller = new AnimationController(self.id, spr_sample_mortar);
