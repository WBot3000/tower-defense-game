/// @description Look for enemy, then fire
// You can write your code in this editor


/*
TODO: Really only need the closest instance, so I don't technically have to sort list, just have to go through it once, then pick object with smallest distance.
		- O(n) vs O(n*log(n)) [probably anyway IDK what sorting function GameMaker uses]
		- Will see performance before changing this though
*/

//Handle animation playing
animation_controller.on_step();

//Increment shot timer
var _frames_per_shot = seconds_to_roomspeed_frames(seconds_per_shot)
shot_timer++;

if(health_state == HEALTH_STATE.KNOCKED_OUT) {
	var _amount_to_recover = recovery_rate / seconds_to_roomspeed_frames(1);
	current_health = min(max_health, current_health + _amount_to_recover);
	if(current_health >= max_health) {
		animation_controller.set_animation(spr_sample_gunner, LOOP_FOREVER);
		health_state = HEALTH_STATE.ACTIVE; 
	}
	else { //If the unit can come back this frame, let them take action (why this is in an else)
		exit; 
	}
}

if(current_health <= 0) { //If unit's health drops below zero, then it should get knocked out
	animation_controller.set_animation(spr_sample_gunner_ko, LOOP_FOREVER);
	health_state = HEALTH_STATE.KNOCKED_OUT;
	exit;
}

range.get_entities_in_range(base_enemy, enemies_in_range, true);
	
	
if(shot_timer >= _frames_per_shot && ds_list_size(enemies_in_range) > 0) { //More than seconds_per_shot have ellapsed since last shot, so you can shoot again

	var _targeting_type = targeting_tracker.get_current_targeting_type();
	
	var _enemy_to_target = _targeting_type.targeting_fn(self.id, enemies_in_range, true);
	
	//TODO: Right now, the vector is from the center of the unit to the center of the enemy unit. Will probably want to adjust these positions based on the enemy's position compared to the unit's
	var _vector_x = (_enemy_to_target.x + _enemy_to_target.sprite_width/2) - (x + sprite_width/2);
	var _vector_y = (_enemy_to_target.y + _enemy_to_target.sprite_height/2) - (y + sprite_height/2);
	var _vector_len = sqrt(sqr(_vector_x) + sqr(_vector_y));
	
	_vector_x = _vector_x / _vector_len;
	_vector_y = _vector_y / _vector_len;
	
	var _bullet = instance_create_layer(x + sprite_width/2, y + sprite_height/2, PROJECTILE_LAYER, sample_gunner_bullet,
		{
			x_speed: _vector_x * other.shooting_speed,
			y_speed: _vector_y * other.shooting_speed,
			bullet_damage: other.bullet_damage
		});
	shot_timer = 0;
}

ds_list_clear(enemies_in_range)

