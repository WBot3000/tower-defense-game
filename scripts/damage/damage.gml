/*
This file contains the damage function, used for dealing damage to enemies and units.

Currently just a wrapper around setting and max functions
*/
function deal_damage(entity_to_damage, damage_amount){
	entity_to_damage.current_health -= max(damage_amount, 0);
}