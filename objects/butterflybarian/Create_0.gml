/// @description Initalize entity data and initiate moving

entity_data = new Butterflybarian();

current_health = entity_data.max_health;
health_state = HEALTH_STATE.ACTIVE;

buffs = [];

entities_in_range = ds_list_create();
entity_attack_cooldown_queue = new EntityCooldownList();

animation_bank = global.ANIMBANK_BUTTERFLYBARIAN;
animation_controller = new AnimationController(self, animation_bank);

set_facing_direction(DIRECTION_RIGHT);
path_start(path_data.default_path, entity_data.default_movement_speed, path_action_stop, false);