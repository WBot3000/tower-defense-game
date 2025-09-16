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


enum BUFF_CATEGORY {
	NONE,
	RANGE, //Alters size of range
	MOVEMENT_SPEED, //Alters movement speed of unit/enemy
	ATTACK_SPEED, //Alters shooting speed of unit/enemy
	DEFENSE, //Alters unit/enemy defense
	HEALTH_REGEN, //Alters unit/enemy health regen speed
	MONEY_GENERATION
}


function Buff(_applied_to) constructor {
	static buff_id = BUFF_IDS.NONE;
	static buff_name = "Placeholder Buff Name";
	static buff_category = BUFF_CATEGORY.NONE;
	applied_to = _applied_to;
	
	static on_duplicate_application = function() {};
	static on_step = function() {};
	static on_removal = function() {};
}


function PresenceBasedBuff(_applied_to, _applier = self) : Buff(_applied_to) constructor {
	//Stores all of the units that are applying this buff. That way, if multiple units are applying the buff, and only one of them is gotten rid of, the buff will still be applied by the other one.
	applied_by = [_applier];
	
	//Add the unit to the current applied_by list
	//Since this buff is initialized with the applier as the first argument in the list, we can take that first list object and append it to this buff's list.
	static on_duplicate_application = function(_second_buff) { array_push(applied_by, _second_buff.applied_by[0]) };
	
	static remove_applier = function(_applier) {
		for(var i = 0, len = array_length(applied_by); i < len; ++i) {
			if(applied_by[i] == _applier) {
				array_delete(applied_by, i, 1);
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
function OnFireBuff(_applied_to) : Buff(_applied_to) constructor {
	static buff_id = BUFF_IDS.ON_FIRE;
	static buff_name = "On Fire!";

	burn_timer = 0;
	
	static on_duplicate_application = function() { burn_timer = 0 }; //Just reset the burn timer
	
	static on_step = function() {
		burn_timer++;
		if(burn_timer % ON_FIRE_STEPS_PER_BURN == 0) {
			deal_damage(applied_to, 2, true);
		}
		if(burn_timer > ON_FIRE_TIME_LIMIT) {
			applied_to.buffs.remove_buff(BUFF_IDS.ON_FIRE);
		}
	}
}


#macro GOLD_RUSH_ARROW_TIME seconds_to_roomspeed_frames(1)
function GoldRushBuff(_applied_to, _applier = self) : PresenceBasedBuff(_applied_to, _applier) constructor {
	static buff_id = BUFF_IDS.GOLD_RUSH;
	static buff_name = "Gold Rush";
	static buff_category = BUFF_CATEGORY.ATTACK_SPEED;
	
	arrow_timer = 0;
	
	static on_step = function() {
		arrow_timer++;
		if(arrow_timer > GOLD_RUSH_ARROW_TIME) {
			part_particles_create(global.PARTICLE_SYSTEM, applied_to.x + random_range(-16, 16),
				applied_to.y - random_range(8, 24), global.PARTICLE_ARROW_GOLD_RUSH, 1);
			arrow_timer = 0;
		}
	}
}


//NOTE: Also stores debuffs
//TODO: Allow multiples of a buff?
function BuffList() constructor {
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
	
	
	static apply_buff = function(_buff) {
		for (var i = 0, len = array_length(buff_list); i < len; ++i) {
		    if(buff_list[i].buff_id == _buff.buff_id) {
				buff_list[i].on_duplicate_application(_buff);
				return;
			}
		}
		array_push(buff_list, _buff);
	}
	
	
	//Currently only supports one buff per ID
	static remove_buff = function(_buff_id) {
		for (var i = 0, len = array_length(buff_list); i < len; ++i) {
		    if(buff_list[i].buff_id == _buff_id) {
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
		    if(buff_list[i].buff_category == _category) {
				array_push(_filtered_buff_list, buff_list[i]);
			}
		}
		return _filtered_buff_list;
	}
}