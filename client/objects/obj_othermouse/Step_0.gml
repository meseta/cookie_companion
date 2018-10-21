if (not is_undefined(next_y) and not is_undefined(next_x)) {
	
	var dist = point_distance(x, y, next_x, next_y);
	
	if (dist > 30) {
		x = next_x;
		y = next_y;
		hspd = 0;
		vspd = 0;
	}
	else {
		dir = point_direction(x, y, next_x, next_y);
		spd = clamp(dist, -max_spd, max_spd);

		hspd = lengthdir_x(spd, dir);
		vspd = lengthdir_y(spd, dir);
	
		y += vspd;
		x += hspd;
	}
}

lastseen++;

if (lastseen > max_lastseen) {
	ds_map_delete(obj_mousehandler.mouse_map, mouse_id);
	instance_destroy();
}

depth = -y;