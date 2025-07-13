/// @description Move along the path and occasionally bite a unit

//Check to see if the enemy needs to be destroyed
if(current_health <= 0) {
	instance_destroy();
	exit; 
	/*
		NOTE: Whenever an instance is destroyed and data structures need to be cleaned up, you need to exit the Step event right after.
		This is because, if you don't, the Destroy/Clean-Up event will be called immediately, and then the Step event will CONTINUE, now with an invalid reference to a data structure.
	*/
}

//Increment state timer
//state_timer++;

range.move_range(get_bbox_center_x(self.id), get_bbox_center_y(self.id)); //If the enemy is in the attacking state, it's not moving, so you only need to update it here
range.get_entities_in_range(base_unit, entities_in_range, true);
range.get_entities_in_range(base_target, entities_in_range, true);
for(var i = 0; i < ds_list_size(entities_in_range); i++) {
	var _entity = entities_in_range[| i];
	if(can_be_attacked(_entity)) {
		var _entity_just_added = entity_attack_cooldown_queue.add_entity(_entity, frames_per_attack);
		if(_entity_just_added) {
			deal_damage(entities_in_range[| i], melee_damage);
			draw_damage_effect(entities_in_range[| i], spr_slash);
		}
	}
}
ds_list_clear(entities_in_range);

entity_attack_cooldown_queue.tick();