/// @description


switch (conn_state) {
case CONNSTATE.error:
case CONNSTATE.disconnected:
	debug_text = "Disconnected";
	break;
		
case CONNSTATE.connect_start:
	// create socket and connection
	server_socket = network_create_socket(network_socket_tcp);
	network_connect_raw(server_socket, server_addr, server_port);

	scr_debug("Starting new connection to ", server_addr, ":", string(server_port));
	conn_state = CONNSTATE.connect_wait;
		
	// fallthrough
		
case CONNSTATE.connect_wait:
	// Wait for connection to complete
	debug_text = "Connecting to server...";
	break;
	
case CONNSTATE.handshake_start:
	// Send handshake packet
	handshake_rpcid = jsonrpc_uuid();
	var handshake = jsonrpc_create_request("handshake", [global.game_version, os_type, os_version], handshake_rpcid);
	ds_queue_enqueue(transmit_queue, handshake);
	conn_state = CONNSTATE.handshake_wait;

case CONNSTATE.handshake_wait:
	// wait for RPC reply
	debug_text = "Handshaking...";
	if (jsonrpc_resultmap_exists(handshake_rpcid, result_map)) {
		var result = jsonrpc_resultmap_pop(handshake_rpcid, result_map);
		if (result > 0) {
			conn_state = CONNSTATE.connected;
			scr_debug("Handshake success");
			room_goto(rm_login);
		}
		else {
			conn_state = CONNSTATE.error;
			scr_debug("Handshake failed, returned result ", result);
		}
		
	}
	break;
		
case CONNSTATE.connected:
	// connected state
	debug_text = "Connected"
	break;
}

// Transmit queue
if (not ds_queue_empty(transmit_queue)) {
	var buff = buffer_create(1024, buffer_grow, 1);
	while (not ds_queue_empty(transmit_queue)) {
		buffer_write(buff, buffer_string, ds_queue_dequeue(transmit_queue));
	}
	network_send_raw(server_socket, buff, buffer_tell(buff));
	//scr_debug("TX: ", string(buffer_tell(buff)), " bytes");
	buffer_delete(buff);
}