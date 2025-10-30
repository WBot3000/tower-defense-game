/*
	buffs_and_debuffs.gml
	
	This file contains information for unit and enemy buffs and debuffs.
	
	
*/

/*
	Enums for different kinds of buffs.
	Buffs consists of one of these types and a multiplier
		- 1 < x multiplier indicates a buff
		- 0 < x < 1 multiplier indicates a debuff
*/
enum BUFF_IDS {
	NONE,
	ON_FIRE,
	GOLD_RUSH
}

global.BUFF_IDS_TO_STRUCTS = {}
global.BUFF_IDS_TO_STRUCTS[$ string(BUFF_IDS.ON_FIRE)] = OnFireBuff;
global.BUFF_IDS_TO_STRUCTS[$ string(BUFF_IDS.GOLD_RUSH)] = GoldRushBuff;


function Buff(_applied_to, _additional_arguments) constructor {
	static buff_id = BUFF_IDS.NONE;
	static buff_name = "Placeholder Buff Name";
	static buff_sprite = spr_default_buff_icon;
	//static stats_multiplied = [];//Stats affected by the buff's buff_multiplier
	//static buff_multiplier = 1; //Used for buffs/debuffs that multiplicatively alter a stat. Can just ignore for ones that don't
	applied_to = _applied_to;
	
	static on_initial_application = function() {};
	static on_duplicate_application = function() {};
	static on_step = function() {};
	static on_removal = function() {};
}


function PresenceBasedBuff(_applied_to, _additional_arguments) : Buff(_applied_to, _additional_arguments) constructor {
	//Stores all of the units that are applying this buff. That way, if multiple units are applying the buff, and only one of them is gotten rid of, the buff will still be applied by the other one.
	applied_by = [_additional_arguments[0]];
	
	add_broadcast_subscriber(_additional_arguments[0], EVENT_ENTITY_DELETED, function(_args) {
		remove_applier(_args[0]);
	}, false, applied_to);
	
	//Add the unit to the current applied_by list
	//Since this buff is initialized with the applier as the first argument in the list, we can take that first list object and append it to this buff's list.
	static on_duplicate_application = function(_additional_arguments_2) {
		var _applier = _additional_arguments_2[0];
		array_push(applied_by, _applier);
		add_broadcast_subscriber(_additional_arguments_2[0], EVENT_ENTITY_DELETED, function(_args) {
			remove_applier(_args[0]);
		}, false, applied_to);
	};
	
	static remove_applier = function(_applier) {
		for(var i = 0, len = array_length(applied_by); i < len; ++i) {
			if(applied_by[i] == _applier) {
				array_delete(applied_by, i, 1);
				break;
			}
		}
		if(array_length(applied_by) == 0) {
			//If there are no more people applying the buff, get rid of it
			applied_to.buffs.remove_buff(buff_id);
		}
	}
}


#macro ON_FIRE_TIME_LIMIT seconds_to_roomspeed_frames(10)
#macro ON_FIRE_STEPS_PER_BURN seconds_to_roomspeed_frames(1)
function OnFireBuff(_applied_to, _additional_arguments) : Buff(_applied_to, _additional_arguments) constructor {
	static buff_id = BUFF_IDS.ON_FIRE;
	static buff_name = "On Fire!";
	static buff_sprite = spr_on_fire_icon;

	burn_timer = 0;
	seconds_to_burn = _additional_arguments[0];
	
	static on_duplicate_application = function(_additional_arguments_2) { seconds_to_burn += _additional_arguments_2[0] }; //Just reset the burn timer
	
	static on_step = function() {
		burn_timer++;
		if(burn_timer % ON_FIRE_STEPS_PER_BURN == 0) {
			deal_damage(applied_to, 2, true);
		}
		if(burn_timer > seconds_to_burn) {
			applied_to.buffs.remove_buff(BUFF_IDS.ON_FIRE);
		}
	}
}


#macro GOLD_RUSH_ARROW_TIME seconds_to_roomspeed_frames(1)
function GoldRushBuff(_applied_to, _additional_arguments) : PresenceBasedBuff(_applied_to, _additional_arguments) constructor {
	static buff_id = BUFF_IDS.GOLD_RUSH;
	static buff_name = "Gold Rush";
	static buff_sprite = spr_gold_rush_icon;
	
	arrow_timer = 0;
	
	static on_initial_application = function() {
		with(applied_to) {
			stat_multipliers[STATS.ATTACK_SPEED] *= 2;
			image_speed = 2;
		}
	}
	
	static on_removal = function() {
		with(applied_to) {
			stat_multipliers[STATS.ATTACK_SPEED] /= 2;
			image_speed = 1;
		}
	}
	
	static on_step = function() {
		arrow_timer++;
		if(arrow_timer > GOLD_RUSH_ARROW_TIME) {
			part_particles_create(global.PARTICLE_SYSTEM, applied_to.x + random_range(-16, 16),
				applied_to.y - random_range(8, 24), global.PARTICLE_ARROW_GOLD_RUSH, 1);
			arrow_timer = 0;
		}
	}
}


#macro NUM_BUFFS_PER_ROW 4
//NOTE: Also stores debuffs
//TODO: Allow multiples of a buff?
function BuffList(_owner = other) constructor {
	owner = _owner;
	buff_list = [];
	
	static on_step = function() {
		for (var i = 0, len = array_length(buff_list); i < len; ++i) {
		    buff_list[i].on_step();
		}
	}
	
	
	static on_draw = function() {
		for (var i = 0, len = array_length(buff_list); i < len; ++i) {
		    buff_list[i].on_draw();
		}
	}
	
	//Call this inside an enitty to apply a buff to them
	//Returns the buff if it needs to be modified after it's been applied.
	//TODO: Currently requires the creation of another instance. Maybe change this so it takes an ID and only creates an instance if needed
	static apply_buff = function(_buff_id, _additional_arguments) {
		for (var i = 0, len = array_length(buff_list); i < len; ++i) {
		    if(buff_list[i].buff_id == _buff_id) {
				buff_list[i].on_duplicate_application(_additional_arguments);
				return buff_list[i];
			}
		}
		var _buff_class = variable_struct_get(global.BUFF_IDS_TO_STRUCTS, string(_buff_id));
		var _new_buff = new _buff_class(owner, _additional_arguments);
		array_push(buff_list, _new_buff);
		_new_buff.on_initial_application(_additional_arguments);
		return _new_buff;
	}
	
	
	//Currently only supports one buff per ID
	static remove_buff = function(_buff_id) {
		for (var i = 0, len = array_length(buff_list); i < len; ++i) {
		    if(buff_list[i].buff_id == _buff_id) {
				buff_list[i].on_removal();
				array_delete(buff_list, i, 1);
				return;
			}
		}
	}
	
	
	static get_buff_from_id = function(_id) {
		for (var i = 0, len = array_length(buff_list); i < len; ++i) {
		    if(buff_list[i].buff_id == _id) {
				return buff_list[i];
			}
		}
		return undefined;
	}
	
	
	static get_buffs_from_category = function(_category) {
		var _filtered_buff_list = [];
		for (var i = 0, len = array_length(buff_list); i < len; ++i) {
		    if(array_contains(buff_list[i].buff_categories, _category)) {
				array_push(_filtered_buff_list, buff_list[i]);
			}
		}
		return _filtered_buff_list;
	}
	
	
	static draw_buff_icons = function() {
		var _num_buffs = array_length(buff_list);
		var _num_rows = floor(_num_buffs / NUM_BUFFS_PER_ROW) + 1;
		for(var r = 0; r < _num_rows; ++r) {
			for(var c = 0; c < NUM_BUFFS_PER_ROW && r*NUM_BUFFS_PER_ROW + c < _num_buffs; ++c) {
				//TODO: Reformat this code so it doesn't make me wanna jump off a cliff.
				draw_sprite(buff_list[r*NUM_BUFFS_PER_ROW + c].buff_sprite, 1, owner.x - (TILE_SIZE/2) + (TILE_SIZE/NUM_BUFFS_PER_ROW * c), owner.bbox_top - (16 * (_num_rows - r + 1)))
			}
		}
	}
}