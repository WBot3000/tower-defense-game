/// @description Check to see if image is finished animating, and if so, destroy
//TODO: Decide on instant destroy, or fade out

if (image_speed > 0 && image_index >= image_number - 1) {
    instance_destroy();
}
