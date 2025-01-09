/// @description Checks to see if enemy falls below zero health, and to destroy it if it does.
if(current_health <= 0) {
	instance_destroy();
	exit;
}