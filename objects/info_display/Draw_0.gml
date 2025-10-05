/// @description Draw round + cash amount
draw_self();
draw_set_font(fnt_smalltext);
//TODO: Maybe some caching?
draw_text_color(x + 16, y + 20, "Round " + (round_manager != undefined ? string(round_manager.current_round) : "???"), c_black, c_black, c_black, c_black, 1);
draw_text_color(x + 32, y + 54, string(global.player_money), c_black, c_black, c_black, c_black, 1);