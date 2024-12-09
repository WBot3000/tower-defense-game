/// @description Checks to see if enemy falls below zero health, and to destroy it if it does.
// NOTE: In most damage functions, the destruction of the enemy is called by what does the damage, not what takes it. However, this is a check just to make sure that there aren't any "zombie" enemies.
if(current_health <= 0) {
	instance_destroy();
}