/// @description Initialize data structures

name = "Sample Brawler";

max_health = 100;
current_health = 100;
health_state = UNIT_STATE.ACTIVE;
recovery_rate = 10; //In health points per second

radius = 1.0;
range = new BrawlerRange(id); //CircularRange(id, x + sprite_width/2, y + sprite_height/2, tilesize_to_pixels(radius));

punch_damage = 5
seconds_per_punch = 0.5

special = false; //Determines if you can have more than one of a unit out

unit_buffs = [];

//Variables to keep track of and control things
enemies_in_range = ds_list_create();

punch_timer = 15;
curr_direction = DIRECTION.DOWN;

animation_controller = new AnimationController(self.id, spr_sample_brawler_down);

