/// @description If the enemy has stopped moving, attack the wall. Also check to see if the enemy has been defeated

//Damage the wall
if(movement_path != pth_dummypath && path_position == 1) {
	attack_timer++;
	if(attack_timer >= seconds_to_roomspeed_frames(seconds_per_attack)) {
		global.wall_health -= melee_damage;
		attack_timer = 0;
	}
}

event_inherited(); //Check to see if the enemy needs to be destroyed