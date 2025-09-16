/// @description Destroy data structures and unregister from events
event_inherited();

for(var i = 0, len = array_length(applying_buffs_to); i < len; ++i) {
	var _unit = applying_buffs_to[i];
	if(!instance_exists(_unit)) { continue }
	
	var _unit_gold_rush_buff = _unit.buffs.get_buff_from_id(BUFF_IDS.GOLD_RUSH);
	if(_unit_gold_rush_buff != undefined) { 
		_unit_gold_rush_buff.remove_applier(self);
	}
}

ds_list_destroy(entities_in_range);