/// @description

switch (player_state) {
case PLAYERSTATE.char_select:
	if (not instance_exists(obj_charselect)) {
		instance_create_depth(0, 0, 0, obj_charselect);
	}
	break;
	
case PLAYERSTATE.spawn_in:
	shake = false;
	if (--animation_height <= 0) {
		animation_height = 0;
		player_state = PLAYERSTATE.movement;
	}
	
	break;
	
case PLAYERSTATE.spawn_out:
	if (++animation_height >= 100) {
		animation_height = 100;
		player_state = PLAYERSTATE.char_select;
		
		if (character_class == CHARACTERCLASS.cookie) {
			has_cookie = true;
		}
		attacking = false;
		attack_cooldown = 0;
	}
	break;
	
case PLAYERSTATE.dunk_1:
	animation_height += 3;
	if (animation_height >= 300) {
		animation_height = 300;
		player_state = PLAYERSTATE.dunk_2;
		audio_sound_pitch(snd_dunk, 0.5);
		audio_play_sound(snd_dunk, 10, false);
		shake = true;
	}
	break;

case PLAYERSTATE.dunk_2:
	x += clamp(dunk_target.x - x, -1, 1);
	y += clamp(dunk_target.y - y, -1, 1);;
	animation_height -= 2;
	if (animation_height <= 25) {
		animation_height = 25;
		player_state = PLAYERSTATE.dunk_3;
		has_cookie = false;
		dunk_target = noone;
		myscore ++;
	}
	break;

case PLAYERSTATE.dunk_3:
	shake = false;
	if (++animation_height >= 300) {
		animation_height = 100;
		player_state = PLAYERSTATE.spawn_in;
		has_cookie = true;
		x = 60;
		y = 60;
	}
	break;
	
case PLAYERSTATE.movement:
	// attack
	var attack = keyboard_check(vk_space);
	
	// despawn
	if (attack and place_meeting(x, y, obj_spawnpoint)) {
		player_state = PLAYERSTATE.spawn_out;
		audio_play_sound(snd_portal_up, 10, false);
		exit;
	}
	else if (character_class == CHARACTERCLASS.cat or has_cookie == false) {
		if (attack_cooldown == 0 and attack and attacking == false) {
			attacking = true;
	
			// send netcode
			if (obj_connection.conn_state == CONNSTATE.connected and obj_login.login_state == LOGINSTATE.success) {
				var rpc = jsonrpc_create_request("event", [obj_login.player_id, x, y, EVENTTYPE.attack]);
				ds_queue_enqueue(obj_connection.transmit_queue, rpc);
			}
	
			attack_cooldown = 30;
			alarm[1] = 30;
			if (character_class == CHARACTERCLASS.cat) {
				instance_create_depth(x, y, depth, obj_slash);
			}
		}
		else if (attack_cooldown == 0 and not attack) {
			attacking = false;
		}

		if (attack_cooldown) attack_cooldown--;
	}
	
	// movement
	var left = keyboard_check(vk_left) || keyboard_check(ord("A"));
	var right = keyboard_check(vk_right) || keyboard_check(ord("D"));
	var up = keyboard_check(vk_up) || keyboard_check(ord("W"));
	var down = keyboard_check(vk_down) || keyboard_check(ord("S"));

	var horiz = (right - left);
	var vert = (down - up);

	hspd += horiz * accel;
	vspd += vert * accel;

	// friction
	spd = point_distance(0, 0, hspd, vspd);
	dir = point_direction(0, 0, hspd, vspd);
	
	spd = clamp(spd, -max_spd, max_spd);

	if (spd < decel) spd = 0;
	else {
		spd -= decel;
	}
	hspd = lengthdir_x(spd, dir);
	vspd = lengthdir_y(spd, dir);
	
	
	// win condition
	if (character_class == CHARACTERCLASS.cookie) {
		var milk = instance_place(x+hspd, y+vspd, obj_milk)
		if (has_cookie and milk != noone) {
			player_state = PLAYERSTATE.dunk_1;
			dunk_target = milk;
			hspd = 0;
			vspd = 0;
			break;
		}
	}

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
	
	// mice collision
	if (character_class == CHARACTERCLASS.cookie and has_cookie) {
		var collision_list = ds_list_create();
		if (instance_place_list(x, y, obj_mouse, collision_list, false)) {
			for (var i = 0; i < ds_list_size(collision_list); i++) {
				var inst = collision_list[| i];
				if (inst.alive) {
				
					// drop cookie
					has_cookie = false;
					instance_create_depth(x, y, depth, obj_cookie);
					myscore = max(myscore-1, 0);
	
					// send netcode
					if (obj_connection.conn_state == CONNSTATE.connected and obj_login.login_state == LOGINSTATE.success) {
						var rpc = jsonrpc_create_request("event", [obj_login.player_id, x, y, EVENTTYPE.drop]);
						ds_queue_enqueue(obj_connection.transmit_queue, rpc);
					}
	
				
					audio_sound_pitch(snd_hit, random_range(0.8, 1.2));
					audio_play_sound(snd_hit, 10, false);
					
					break;	
				}
			}
		}
		ds_list_destroy(collision_list);
	}
	
	break;
}

depth = -y;

// camera
// half-views
var vw = camera_get_view_width(view_camera[0]) / 2;
var vh = camera_get_view_height(view_camera[0]) / 2;
	
// camera center
var cx = camera_get_view_x(view_camera[0]) + vw;
var cy = camera_get_view_y(view_camera[0]) + vh;

// camera target
var tx = cx + clamp(x-cx, -10, 10);
var ty = cy + clamp(y-cy, -10, 10);

// clamp to room
tx = clamp(tx, vw, room_width-vw);
ty = clamp(ty, vh, room_height-vh);
	
// move camera
camera_set_view_pos(view_camera[0], tx - vw, ty - vh);

