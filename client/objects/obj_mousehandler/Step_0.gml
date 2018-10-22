/// @description
while (jsonrpc_callmap_exists("mouseupdate", obj_connection.call_map)) {
	var rpc = jsonrpc_callmap_pop("mouseupdate", obj_connection.call_map);
	var update = json_decode(rpc[? "params"]);
	if (update) {
		//scr_debug("Got moveupdate", json_encode(update));
		
		for (var key=ds_map_find_first(update); not is_undefined(key); key=ds_map_find_next(update, key)) { 
		    var value = ds_map_find_value(update, key);
		    
			// get player from playerlist
			var instance = ds_map_find_value(mouse_map, key)
			if (is_undefined(instance)) {
				instance = instance_create_depth(0, 0, 0, obj_othermouse);
				instance.mouse_id = key;
				ds_map_add(mouse_map, key, instance)
			}
			
			// death sound
			if (instance.alive == true and value[|4] == false) {
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
			
			instance.next_x = value[| 2];
			instance.next_y = value[| 3];
			instance.alive = value[| 4];
			instance.lastseen = 0;
		}
		ds_map_destroy(update);
	}
	else {
		scr_debug("Could not decode mouseupdate");
	}
	ds_map_destroy(rpc);
}


// spawn local mice
var mice_count = ds_stack_size(local_mouse_list);
var target_count = 1;
with (obj_player) {
	target_count += clamp(myscore, 0, 5);
}

if (target_count > mice_count) {
	repeat(target_count - mice_count) {
		var inst = instance_create_depth(0, 0, 0, obj_mouse);
		with (inst) {
			var test_x;
			var test_y;
			do {
				test_x = random(room_width);
				test_y = random(room_height);
			} until  (not place_meeting(test_x, test_y, obj_collidable));
			x = test_x;
			y = test_y;
		}
		ds_stack_push(local_mouse_list, inst);
	}
}
else if (mice_count > target_count) {
	repeat(mice_count - target_count) {
		var inst = ds_stack_pop(local_mouse_list);	
		instance_destroy(inst);
	}
}