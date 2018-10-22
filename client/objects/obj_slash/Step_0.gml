/// @description
if (image_index+1 >= image_number) {
	instance_destroy();	
}
var play_sound = false;
var collision_list = ds_list_create();
if (collision_circle_list(x, y, 12, obj_mouse, false, true, collision_list, false)) {
	for (var i = 0; i < ds_list_size(collision_list); i++) {
		var inst = collision_list[| i];
		
		if (inst.alive == true) {
			play_sound = true;
		}
		inst.alive = false;
		
		
	}
}
ds_list_destroy(collision_list);

if (play_sound) {
	// death sounds
	var vw = camera_get_view_width(view_camera[0]);
	var vh = camera_get_view_height(view_camera[0]);
	var cx = camera_get_view_x(view_camera[0]);
	var cy = camera_get_view_y(view_camera[0]);

	if (point_in_rectangle(x, y, cx, cy, cx+vw, cy+vh)) {
		audio_sound_pitch(snd_squeek, random_range(0.8, 1.2));
		audio_play_sound(snd_squeek, 10, false);
	}
}