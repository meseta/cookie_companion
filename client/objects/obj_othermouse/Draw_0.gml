/// @description

if (alive) {
	var calc_dir = point_direction(xprevious, yprevious, x, y);
	var calc_dist = point_distance(xprevious, yprevious, x, y);
	var current_dir = face * 90;

	if (calc_dist > 1 and abs(angle_difference(current_dir, calc_dir)) > 90) {
		face = ((calc_dir+45) div 90) mod 4;
	}
	draw_sprite(sprite_index, face, x, y);
}
else {
	draw_sprite(sprite_index, 4, x, y);	
}