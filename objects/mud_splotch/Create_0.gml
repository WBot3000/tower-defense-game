/// @description Initialize variables
existence_time_limit = seconds_to_roomspeed_frames(10);
existence_timer = 0;

splotch_state = SLIDING_MENU_STATE.OPENING //Lol I'm using the sliding menu state here, might change this later.
enemy_collision_list = ds_list_create();

animation_controller = new AnimationController(self, global.ANIMBANK_MUD_SPLOTCH);
animation_controller.set_animation("GROWING", 1, function(){ splotch_state = SLIDING_MENU_STATE.OPEN; });