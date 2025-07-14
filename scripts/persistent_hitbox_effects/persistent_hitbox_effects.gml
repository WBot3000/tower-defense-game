/*
	persistent_hitbox_effects.gml
	
	This file contains functions for various types of persistent hitbox effects.
	All of these take the id of the entity they will affect.
*/
#region EntityCooldownList (Class)
/*
	A list that stores and removes entities based on a timer.
	Used for attacks and hitboxes that can only affect a certain enemy every X frames
*/
function EntityCooldownList() constructor {
	frame_timer = 0;
	entities_on_cooldown = {};
	entity_list = [];
	
	static tick = function() {
		//You can do this because the trigger times are in order from earliest started to most recently started.
		while(array_length(entity_list) > 0) {
			if(entity_list[0][1] > frame_timer) { //Cooldown hasn't expired yet, so none of the later cooldowns on the list will have expired either.
				break;
			}
			struct_set_from_hash(entities_on_cooldown, entity_list[0][0], undefined);
			array_shift(entity_list);
		}
		frame_timer++;
	}
	
	//Returns false if the entity is already on cooldown, returns true if it wasn't
	static add_entity = function(_entity, _time_in_frames) {
		var _entity_id_hash =  variable_get_hash(_entity.id);
		var _is_on_cooldown = struct_get_from_hash(entities_on_cooldown, _entity_id_hash);
		if(_is_on_cooldown == undefined) {
			struct_set_from_hash(entities_on_cooldown, _entity_id_hash, true);
			array_push(entity_list, [_entity_id_hash, frame_timer + _time_in_frames]);
			return true;
		}
		return false;
	}
	
	//Check to see if an entity is currently on cooldown already
	static is_entity_on_cooldown = function(_entity) {
		var _entity_id_hash =  variable_get_hash(_entity.id);
		return struct_get_from_hash(entities_on_cooldown, _entity_id_hash);
	}
}
#endregion


#region PersistentHitbox (Class)
/*
	Persistent hitboxes are used for when you want to do something to entities within a hitbox every so often.
	Originated from a need to damage enemies within an explosion hitbox
	- Damanging them every frame would be excessive
	Not strictly necesary if you just plan on inflicting the effect every frame.
	
	- Just using current time like this will break upon pausing the game. Time sources can be paused, so this issue goes away easily without having to manage multiple timers
	TODO: Enable different effects for different kinds of entities?
	- Specify this relationship using another struct
	
	TODO: Use with new TimerList?
	
	range: The range used to detect what entities should be affected by the specified effect.
	effect: A function that's applied to any entities in the range if they aren't on cooldown.
	- Effect takes entity as an argument
	- This effect will be called on every entity will be found, so make sure this function will work 
	cooldown: The amount of time that should be waited before applying the effect again.
	hitbox_timer: The number of frames the hitbox has been active for.
	entities_on_cooldown: A struct that contains all of the entities that shouldn't be affected by the effect on the current frame.
	entity_trigger_times: A 2D array that contains all of the times the effect was last applied to.
	- While it's somewhat redundant to have both this and entities_on_cooldown, the purpose is to save time by leveraging the advantages of both structs and arrays.
		- When checking if the entity is on cooldown, we can just use the struct instead of iterating through the array multiple times.
		- When removing entities from cooldown, we can just check the beginning of the array (it'll be sorted from earliest added to latest), instead of having to turn struct into an array each time.
*/
function PersistentHitbox(_range, _effect, _cooldown) constructor {
	range = _range;
	effect = _effect;
	cooldown = _cooldown;
	
	hitbox_timer = 0;
	entities_on_cooldown = {};
	entity_trigger_times = [];
	
	//Arguments come from the "get_entities_in_range" function for the Range.
	//Currently assumes that each entity instance handles it's own list. TODO: Determine whether this is good or should be changed.
	static on_step = function(_entity_type, _storage_list, _ordered = false) {
		range.get_entities_in_range(_entity_type, _storage_list, _ordered);
		//var _curr_time = current_time; //All entities should be "marked" at the same time, which is why this is stored in a variable instead of referenced each time.
		
		//You can do this because the trigger times are in order from earliest started to most recently started.
		while(array_length(entity_trigger_times) > 0) {
			var _time_difference = milliseconds_to_seconds(hitbox_timer - entity_trigger_times[0][1]);
			if(_time_difference < cooldown) { //Cooldown hasn't expired yet, so none of the later cooldowns on the list will have expired either.
				break;
			}
			var _removed_entity_id_hash =  entity_trigger_times[0][0]
			array_shift(entity_trigger_times) //Otherwise effect can be activated for this entity again.
			struct_set_from_hash(entities_on_cooldown, _removed_entity_id_hash, undefined);
		}
		
		for(var i = 0; i < ds_list_size(_storage_list); ++i) {
			var _added_entity_id = _storage_list[| i]
			//Optimization. Faster than just directly accessing 
			var _added_entity_id_hash = variable_get_hash(_added_entity_id);
			var _is_on_cooldown = struct_get_from_hash(entities_on_cooldown, _added_entity_id_hash);
			if(_is_on_cooldown == undefined) { //Call effect on enemy
				effect(_added_entity_id);
				//Add hash instead of entity id so we don't have to recalculate it later.
				//NOTE: This would have to be changed if we ever wanted to display the cooldown list to the player, but tbh that's very unlikely
				array_push(entity_trigger_times, [_added_entity_id_hash, hitbox_timer]);
				struct_set_from_hash(entities_on_cooldown, _added_entity_id_hash, true);
			}
		}
		
		hitbox_timer++;
	}
	
}
#endregion


#region mortar_cannonball_explosion_effect (Function)

#macro MORTAR_CANNONBALL_EXPLOSION_DAMAGE 10

function mortar_cannonball_explosion_effect(_enemy_to_damage){
	deal_damage(_enemy_to_damage, MORTAR_CANNONBALL_EXPLOSION_DAMAGE);
}
#endregion