/// @description
var left = keyboard_check_pressed(vk_left);
var right = keyboard_check_pressed(vk_right);
var space = keyboard_check_pressed(vk_space);


if (space) {
	instance_destroy();
	with(obj_player) {
		player_state = PLAYERSTATE.spawn_in;	
		character_class = other.select;
		audio_play_sound(snd_portal_down, 10, false);
	}
}

if (left and select != CHARACTERCLASS.cookie) {
	audio_sound_pitch(snd_click, random_range(0.8, 1.2));
	audio_play_sound(snd_click, 10, false);
	select = CHARACTERCLASS.cookie;
}
if (right and select != CHARACTERCLASS.cat) {
	audio_sound_pitch(snd_click, random_range(0.8, 1.2));
	audio_play_sound(snd_click, 10, false);
	select = CHARACTERCLASS.cat;
}