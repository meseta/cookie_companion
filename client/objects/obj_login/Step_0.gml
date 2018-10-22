/// @description


switch(login_state) {
case LOGINSTATE.player_input:
	username = get_string("Username", "Anon");
	if (string_length(username) > 10) {
		username = string_copy(username, 1, 10);	
	}
	login_state = LOGINSTATE.login_start;
	break;
	
case LOGINSTATE.login_start:
	login_rpcid = jsonrpc_uuid();
	var login = jsonrpc_create_request("login", [username], login_rpcid);
	ds_queue_enqueue(obj_connection.transmit_queue, login);
	login_state = LOGINSTATE.login_wait;
	
case LOGINSTATE.login_wait:
	debug_text = "Logging in...";
	if (jsonrpc_resultmap_exists(login_rpcid, obj_connection.result_map)) {
		var result = jsonrpc_resultmap_pop(login_rpcid, obj_connection.result_map);
		if (is_string(result)) {
			login_state = LOGINSTATE.success;
			player_id = result;
			scr_debug("Login success, session_id ", player_id);
			
			var player = instance_create_depth(0, 0, 0, obj_player);
			player.username = username;
			
			room_goto(rm_game);
		}
		else {
			login_state = LOGINSTATE.error;
			scr_debug("Login failed, returned result ", result);
		}
		
	}
	break;

case LOGINSTATE.success:
	if (jsonrpc_resultmap_exists(ping_rpcid, obj_connection.result_map)) {
		var result = jsonrpc_resultmap_pop(ping_rpcid, obj_connection.result_map);
		var ms = (get_timer() - real(result)) div 1000;
		ping_text = " (PING: " + string(ms) + "ms)";
		alarm[0] = room_speed/2;
	}
	var online = 0;
	with (obj_playerhandler) {
		online = players_online;
	}
	online ++;
	
	debug_text = string(online) + " players online" + ping_text;
	break;
	
case LOGINSTATE.error:
	debug_text = "Login fail";
	break;

}