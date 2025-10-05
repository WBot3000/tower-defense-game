/// @description Draw text next to and above slider
draw_self();
draw_sprite(spr_slider_circle_default, 1, nob_x, y);
//TODO: Should probably cache current value of nob so that map_value doesn't need to be called each frame
draw_set_font(fnt_smalltext);
draw_text_color(right_bound + 32, y - 8, string(floor(map_value(nob_x, left_bound, right_bound, 0, 100))), c_white, c_white, c_white, c_white, 1);
draw_set_halign(fa_center);
draw_text_color(x + sprite_width/2, y - 40, label, c_white, c_white, c_white, c_white, 1);
draw_set_halign(fa_left);
