/// @description Draw text
draw_self();
draw_set_halign(fa_center);
draw_text_color(x + sprite_width/2, y - 24, label, c_white, c_white, c_white, c_white, 1);
if(flash_timer < 30) {
	draw_text_color(x + sprite_width/2, y + 4, current_key, c_white, c_white, c_white, c_white, 1);
}
draw_set_halign(fa_left);