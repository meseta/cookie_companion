/// @description

#region singleton pattern
	if(instance_number(object_index) > 1) {
	    if(debug_mode) {
	        show_error("More than one "+object_get_name(object_index)+" exists in "+room_get_name(room), true);
	    }
	    else {
	        instance_destroy();
	        exit;
	    }
	}
#endregion singleton pattern

#region server config
	serverlist_address = "http://cookie.gmcloud.org/server_list.json"
	serverlist_req = undefined;

	server_name = "default"
	server_addr = "cookie.gmcloud.org"
	server_port = 61220
	server_socket = undefined;
	network_set_config(network_config_use_non_blocking_socket, 1);
	network_set_config(network_config_connect_timeout, 4000);
	packet_chunk = ""
#endregion server config

#region state machine
	enum CONNSTATE {
		serverlist_start,
		serverlist_wait,
		error,
		disconnected,
		connect_start,
		connect_wait,
		handshake_start,
		handshake_wait,
		connected
	}

	conn_state = CONNSTATE.serverlist_start;
	debug_text = "Undefined";

#endregion state machine

#region jsonrpc structures
	call_map = ds_map_create();
	result_map = ds_map_create();
	transmit_queue = ds_queue_create();

	heartbeat_rpcid = undefined;
#endregion jsonrpc structures
