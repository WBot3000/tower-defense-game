/// @description Draw name, sprite, and health
if(!visible || !layer_get_visible(layer) || entity == noone || 
	!variable_instance_exists(entity, "targeting_tracker")) { return; }

draw_self();
draw_set_font(fnt_smalltext);
draw_set_alignments(fa_center, fa_center);
draw_text_color(x, y, entity.targeting_tracker.get_current_targeting_type().targeting_name, c_white, c_white, c_white, c_white, 1);
draw_set_alignments();
