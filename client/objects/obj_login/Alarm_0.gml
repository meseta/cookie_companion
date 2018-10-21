/// @description

if (obj_connection.conn_state == CONNSTATE.connected) {
	ping_rpcid = jsonrpc_uuid();
	
	var send_class = CHARACTERCLASS.unknown;
	var send_score = 0;
	with (obj_player) {
		send_class = character_class;
		send_score = myscore;
	}
	
	var ping = jsonrpc_create_request("ping", [player_id, username, send_class, send_score, get_timer()], ping_rpcid);
	ds_queue_enqueue(obj_connection.transmit_queue, ping);
}