/// @description Draw sprite and additional effects
draw_self();

if(buffs.get_buff_from_id(BUFF_IDS.ON_FIRE) != undefined) {
	draw_sprite(spr_flame, 5 + (current_time % 2), get_bbox_center_x(self), get_bbox_center_y(self));
}