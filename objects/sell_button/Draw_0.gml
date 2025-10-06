/// @description Draw button, labels, and appropriate stat icon
if(!visible || !layer_get_visible(layer) || entity == noone) { return; }

if(highlighted) {
	shader_set(shader_highlight);
}

draw_self();
draw_set_alignments(fa_right, fa_center);
draw_text(x + sprite_width - 8, y + sprite_height/2, string(entity.sell_price));
draw_set_alignments();

shader_reset();
