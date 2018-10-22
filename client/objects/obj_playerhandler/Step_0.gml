/// @description
while (jsonrpc_callmap_exists("moveupdate", obj_connection.call_map)) {
	var rpc = jsonrpc_callmap_pop("moveupdate", obj_connection.call_map);
	var update = json_decode(rpc[? "params"]);
	if (update) {
		//scr_debug("Got moveupdate", json_encode(update));
		
		for (var key=ds_map_find_first(update); not is_undefined(key); key=ds_map_find_next(update, key)) { 
		    var value = ds_map_find_value(update, key);
		    
			// get player from playerlist
			var instance = ds_map_find_value(player_map, key)
			if (not is_undefined(instance)) {
				instance.next_x = value[| 1];
				instance.next_y = value[| 2];
				instance.attacking = value[| 3];
				instance.has_cookie = value[| 4];
				instance.player_state = value[| 5];
			}	
		}
		ds_map_destroy(update);
	}
	else {
		scr_debug("Could not decode moveupdate");
	}
	ds_map_destroy(rpc);
}

while (jsonrpc_callmap_exists("statusupdate", obj_connection.call_map)) {
	var rpc = jsonrpc_callmap_pop("statusupdate", obj_connection.call_map);
	var update = json_decode(rpc[? "params"]);
	if (update) {
		//scr_debug("Got statusupdate");
		
		for (var key=ds_map_find_first(update); not is_undefined(key); key=ds_map_find_next(update, key)) { 
		    var value = ds_map_find_value(update, key);
		    
			// get player from playerlist
			var instance = ds_map_find_value(player_map, key)
			if (is_undefined(instance)) {
				instance = instance_create_depth(-10, -10, 0, obj_otherplayer);
				instance.player_id = key;
				ds_map_add(player_map, key, instance);
			}
			instance.username = value[| 1];
			instance.character_class = value[| 2];
			instance.myscore = value[| 3];
			instance.lastseen = 0;
		}
		ds_map_destroy(update);
		
		players_online = ds_map_size(player_map);
	}
	else {
		scr_debug("Could not decode moveupdate");
	}
	ds_map_destroy(rpc);
}

while (jsonrpc_callmap_exists("eventtrigger", obj_connection.call_map)) {
	var rpc = jsonrpc_callmap_pop("eventtrigger", obj_connection.call_map);
	var update = json_decode(rpc[? "params"]);
	if (update) {
		// scr_debug("Got eventtrigger" + json_encode(update));
		var list = update[? "default"];
		
		// get player from playerlist
		var instance = ds_map_find_value(player_map, list[| 0]);
		if (not is_undefined(instance)) {
			switch (list[| 3]) {
			case EVENTTYPE.attack:
				if (instance.character_class == CHARACTERCLASS.cat) {
					instance_create_depth(list[| 1], list[| 2], 0, obj_slash);
				}
				break;
			case EVENTTYPE.drop:
				if (instance.has_cookie) {
					// drop cookie
					has_cookie = false;
					instance_create_depth(instance.x, instance.y, instance.depth, obj_cookie);
					
					// hit sounds
					var vw = camera_get_view_width(view_camera[0]);
					var vh = camera_get_view_height(view_camera[0]);
					var cx = camera_get_view_x(view_camera[0]);
					var cy = camera_get_view_y(view_camera[0]);

					if (point_in_rectangle(x, y, cx, cy, cx+vw, cy+vh)) {
						audio_sound_pitch(snd_hit, random_range(0.8, 1.2));
						audio_play_sound(snd_hit, 10, false);
					}	
				}
				break;
			}
		}
		ds_map_destroy(update);
	}
	else {
		scr_debug("Could not decode moveupdate");
	}
	ds_map_destroy(rpc);
}