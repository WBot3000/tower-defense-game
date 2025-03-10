/// @description Move the bullet

//Check left, right, top, and bottom OOB, and delete if off screen to save space
/*
if(x < DIST_OFF_SCREEN * -1 || x > room_width + DIST_OFF_SCREEN || y < DIST_OFF_SCREEN * -1 || y > room_height + DIST_OFF_SCREEN) {
	instance_destroy();
	exit;
}*/
//If old target doesn't exist, select a new one
if(target == noone || !instance_exists(target)) {
	//TODO: Should probably select a new instance based on targeting. Currently, just target the closest enemy
	target = instance_nearest(x, y, base_enemy);
	
}

//Check to see if bullet is hitting enemy (produce ordered list of enemies in between bullet's current position and next)
if(x >= 0 && x <= room_width && y >= 0 && y <= room_height) { //Only need to do boundary check if the bullet is actually in the room
	var _end_x = clamp(x + x_speed, 0, room_width)
	var _end_y = clamp(y + y_speed, 0, room_height)

	if(collision_line(x, y, _end_x, _end_y, target, false, true)) {
		//Damage the enemy
		deal_damage(target, bullet_damage);
		//TODO: Create explosion hitbox
		//Destroy the missile
		instance_destroy()
		exit;
	}
}

if(target != noone) {
	var _vector_x = (target.x + target.sprite_width/2) - (x + sprite_width/2);
	var _vector_y = (target.y + target.sprite_height/2) - (y + sprite_height/2);
	var _vector_len = sqrt(sqr(_vector_x) + sqr(_vector_y));
	
	x_speed = (_vector_x / _vector_len) * missile_speed;
	y_speed = (_vector_y / _vector_len) * missile_speed;
}

//Move the bullet
x += x_speed;
y += y_speed;

/*
	Pseudocode
	TODO: Should missile only hit intended target, or just the first unit it ends up hitting?
	1) Check if current target still exists.
		a) If it doesn't, then pick a new target (determine algorithm for this)
		TODO: WIll it always pick a new target, or only if one is in a certain range?
	2) Check if the missile will collide with the target.
	3) Calculate new vectors torwards the target.
*/