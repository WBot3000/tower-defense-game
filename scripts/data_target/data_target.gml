/*
This file contains the entity data for targets.
For now, I'm not defining specific classes for each target, as all of them will be rather simple for now, only differing in a few stats
*/
function TargetData(_max_health) : EntityData() constructor {
	max_health = _max_health;
}