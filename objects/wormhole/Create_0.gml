/// @description Insert description here
frames_per_worm_spawn = seconds_to_roomspeed_frames(1.5);
worm_spawn_timer = 0;

existence_time_limit = seconds_to_roomspeed_frames(100);
existence_timer = 0;

round_manager = get_round_manager();

wormhole_state = SLIDING_MENU_STATE.OPENING //Lol I'm using the sliding menu state here, might change this later.

animation_controller = new AnimationController(self, global.ANIMBANK_KINGWORM_WORMHOLE);
animation_controller.set_animation("OPENING", 1, function(){ wormhole_state = SLIDING_MENU_STATE.OPEN; });

show_debug_message("(" + string(x) + ", " + string(y) + ")");