/// @description Attack any units and targets in your path

event_inherited();

//Check to see if the enemy needs to be destroyed
if(current_health <= 0) {
	standard_on_enemy_defeat_actions();
	exit; 
	/*
		NOTE: Whenever an instance is destroyed and data structures need to be cleaned up, you need to exit the Step event right after.
		This is because, if you don't, the Destroy/Clean-Up event will be called immediately, and then the Step event will CONTINUE, now with an invalid reference to a data structure.
	*/
}

entity_data.sight_range.get_entities_in_range([base_unit, base_target], entities_in_range);
for(var i = 0; i < ds_list_size(entities_in_range); i++) {
	var _entity = entities_in_range[| i];
	if(can_be_attacked(_entity)) {
		var _entity_just_added = entity_attack_cooldown_queue.add_entity(_entity, entity_data.frames_per_attack);
		if(_entity_just_added) {
			deal_damage(entities_in_range[| i], entity_data.attack_damage);
			draw_damage_effect(entities_in_range[| i], spr_slash);
		}
	}
}
ds_list_clear(entities_in_range);

entity_attack_cooldown_queue.tick();
movement_controller.on_step();