/*
	damage.gml
	This file contains the damage function, used for dealing damage to enemies and units.

	Currently just a wrapper around setting and max functions
	
	NOTE:
	Because this is such a nothing-burger file, I'm not even bothering with any sort of regioning as of right now.
	
	TODO: No clue if I want to keep this or not.
		The reason this exists in the first place is because entity health being less than zero caused issues with the health bar and health regeneration.
		But having negative health might be useful somewhere? Who knows.
*/
function deal_damage(entity_to_damage, damage_amount){
	entity_to_damage.current_health -= max(damage_amount, 0);
}