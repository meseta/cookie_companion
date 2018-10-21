/// @description
switch (player_state) {
case PLAYERSTATE.spawn_in:
	x = 60;
	y = 60;
	if (--animation_height <= 0) {
		animation_height = 0;
	}
	shake = false;
	break;
	
case PLAYERSTATE.spawn_out:
	if (++animation_height >= 100) {
		animation_height = 100;
	}
	break;
	
	
case PLAYERSTATE.dunk_1:
	animation_height += 3;
	if (animation_height >= 300) {
		animation_height = 300;
	}
	break;

case PLAYERSTATE.dunk_2:
	shake = true;
	dunk_target = instance_nearest(x, y, obj_milk);
	x += clamp(dunk_target.x - x, -1, 1);
	y += clamp(dunk_target.y - y, -1, 1);;
	animation_height -= 2;
	if (animation_height <= 25) {
		animation_height = 25;
	}
	break;

case PLAYERSTATE.dunk_3:
	shake = false;
	dunk_target = noone;
	if (++animation_height >= 300) {
		animation_height = 100;
		x = 60;
		y = 60;
	}
	break;
	
default:
	animation_height = 0;
}

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
	ds_map_delete(obj_playerhandler.player_map, player_id);
	instance_destroy();
}

depth = -y;