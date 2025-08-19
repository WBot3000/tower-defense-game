/// @description Declare variables and initiate moving

entity_data = new SwordBeetle(path_data, round_spawned_in);

current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;

buffs = [];

//Variables to keep track of biting
attack_timer = 0;
entities_in_range = ds_list_create();

animation_bank = global.ANIMBANK_SWORDBEETLE;
animation_controller = new AnimationController(self, animation_bank);

set_facing_direction(DIRECTION_RIGHT);
path_start(path_data.default_path, entity_data.default_movement_speed, path_action_stop, false);