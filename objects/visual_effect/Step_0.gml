/// @description Check to see if image is finished animating, and if so, fade out, then destroy

switch (fading_status) {
    case VISUAL_EFFECT_STATUS.STILL:
        if (image_speed > 0 && image_index >= image_number - 1) {
			image_speed = 0;
			fading_status = VISUAL_EFFECT_STATUS.FADING_OUT;
		}
        break;
    case VISUAL_EFFECT_STATUS.FADING_OUT:
        image_alpha -= 0.1;
		if(image_alpha <= 0) {
			instance_destroy();
		}
        break;
    default:
        break;
}

