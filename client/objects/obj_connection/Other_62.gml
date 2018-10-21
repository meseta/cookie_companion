/// @description

var async_id = ds_map_find_value(async_load,"id")
if(async_id == serverlist_req) {
	// check status
	var async_status = ds_map_find_value(async_load,"status")
	var async_http_status = ds_map_find_value(async_load, "http_status")
	var async_result = ds_map_find_value(async_load, "result")
		
	if(async_status >= 0 and async_http_status == 200) { // success
		var servers = json_decode(async_result);
		show_debug_message("decode");
		show_debug_message(async_result);
		if (servers) {
			show_debug_message("ok");
			var server_list = servers[? "servers"];
			ds_list_shuffle(server_list);
			var top_server = server_list[| 0]
			server_name = top_server[? "name"]
			server_addr = top_server[? "host"]
			server_port = top_server[? "port"]
			serverlist_req = undefined;
			conn_state = CONNSTATE.connect_start;
			
			ds_map_destroy(servers);
		}
	}
}

