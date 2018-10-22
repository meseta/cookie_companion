/// @description

// partial boid code

if (not alive) {
	if (alarm[0] == -1) {
		alarm[0] = irandom_range(300, 900);	
	}
	exit;	
}

var xvect = 0;
var yvect = 0;

with (obj_playerparent) {
	var weight = 0;
	var rangemax = 0;
	if (character_class == CHARACTERCLASS.cat) {
		weight = -0.5;
		rangemax = 250;
	}
	else {
		rangemax = 2000;
		if (has_cookie) {
			weight = 2;
			if (place_meeting(x, y, obj_spawnpoint)) {
				weight = 0.1;
			}
		}
		else {
			weight = 0.1;
		}
	}
	var range = max(0.1, point_distance(x, y, other.x, other.y));
	if (range < rangemax) {
		xvect += (x - other.x) * weight / range;
		yvect += (y - other.y) * weight / range;
	}

}
with (obj_mouse) {
	var weight = -0.5;
	var range = max(0.1, point_distance(x, y, other.x, other.y));
	if (range < 50) {
		xvect += (x - other.x) * weight / range;
		yvect += (y - other.y) * weight / range;
	}
}
with (obj_cookie) {
	var weight = 3;
	var range = max(0.1, point_distance(x, y, other.x, other.y));
	if (range < 100) {
		xvect += (x - other.x) * weight / range;
		yvect += (y - other.y) * weight / range;
	}
}
with (obj_spawnpoint) {
	var weight = -3;
	var range = max(0.1, point_distance(x, y, other.x, other.y));
	if (range < 300) {
		xvect += (x - other.x) * weight / range;
		yvect += (y - other.y) * weight / range;
	}
}

spd = min(point_distance(0, 0, xvect, yvect), max_spd);
spd = max_spd;
dir -= clamp(angle_difference(dir, point_direction(0, 0, xvect, yvect)), -8, 8);

hspd = lengthdir_x(spd, dir);
vspd = lengthdir_y(spd, dir);


// collisions
if(place_meeting(x+hspd, y, obj_collidable)) {
	while(!place_meeting(x+sign(hspd), y, obj_collidable)) {
		x += sign(hspd);
	}
	hspd = 0;
}
x += hspd;

if(place_meeting(x, y+vspd, obj_collidable)) {
	while(!place_meeting(x, y+sign(vspd), obj_collidable)) {
		y += sign(vspd);
	}
	vspd = 0;
}
y += vspd;

depth = -y;
