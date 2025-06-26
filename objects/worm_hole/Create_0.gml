/// @description Insert description here
frames_per_worm_spawn = seconds_to_roomspeed_frames(1.5);
worm_spawn_timer = 0;

existence_time_limit = seconds_to_roomspeed_frames(10);
existence_timer = 0;

round_manager = get_round_manager();

worm_hole_state = SLIDING_MENU_STATE.OPENING //Lol I'm using the sliding menu state here, might change this later.

animation_controller = new OldAnimationController(self, spr_worm_hole_opening, spr_worm_hole);
animation_controller.set_animation(spr_worm_hole_opening);