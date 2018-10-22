/// @description
depth = -y;

var vw = camera_get_view_width(view_camera[0]);
var vh = camera_get_view_height(view_camera[0]);
var cx = camera_get_view_x(view_camera[0]);
var cy = camera_get_view_y(view_camera[0]);

if (point_in_rectangle(x, y, cx, cy, cx+vw, cy+vh)) {
	audio_sound_pitch(snd_slash, random_range(0.8, 1.2));
	audio_play_sound(snd_slash, 10, false);
}