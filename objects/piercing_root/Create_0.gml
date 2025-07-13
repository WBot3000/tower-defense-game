/// @description Initialize data structures

//Sets the image direction of the projectile based on the direction it's travelling
//Need to make the y negative, since "going up" is represented with a negative value since the y value goes up as the physical location goes down
image_angle = darctan2(-y_speed, x_speed)

enemies_in_range = ds_list_create();

//pierce_count = 3
//Prevents the same enemy from getting hit by the bullet more than once
enemies_already_hit = []