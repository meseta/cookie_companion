/// @description
var left = keyboard_check_pressed(vk_left);
var right = keyboard_check_pressed(vk_right);
var space = keyboard_check_pressed(vk_space);


if (space) {
	instance_destroy();
	with(obj_player) {
		player_state = PLAYERSTATE.spawn_in;	
		character_class = other.select;
	}
}

if (left) select = CHARACTERCLASS.cookie;
if (right) select = CHARACTERCLASS.cat;