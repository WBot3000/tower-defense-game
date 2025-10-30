/// @description Initialize data structures

//Sets the image direction of the projectile based on the direction it's travelling
image_angle = get_angle_from_vector_in_degrees([-y_speed, x_speed])

entities_in_range = ds_list_create();

//pierce_count = 3
//Prevents the same enemy from getting hit by the bullet more than once
enemies_already_hit = []