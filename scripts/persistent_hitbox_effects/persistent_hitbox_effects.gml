/*
	persistent_hitbox_effects.gml
	This file contains functions for various types of persistent hitbox effects.
	All of these take the id of the entity they will affect.
*/

#region mortar_cannonball_explosion_effect (Function)
#macro MORTAR_CANNONBALL_EXPLOSION_DAMAGE 10

function mortar_cannonball_explosion_effect(_enemy_to_damage){
	deal_damage(_enemy_to_damage, MORTAR_CANNONBALL_EXPLOSION_DAMAGE);
}
#endregion