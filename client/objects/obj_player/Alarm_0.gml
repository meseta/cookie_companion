/// @description netcode update
if (obj_connection.conn_state == CONNSTATE.connected and obj_login.login_state == LOGINSTATE.success) {
	var move = jsonrpc_create_request("move", [obj_login.player_id, x, y, attacking, has_cookie, player_state]);
	ds_queue_enqueue(obj_connection.transmit_queue, move);
}
alarm[0] = alarm_reload_value;