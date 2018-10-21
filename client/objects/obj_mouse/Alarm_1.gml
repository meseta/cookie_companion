/// @description netcode update
if (obj_connection.conn_state == CONNSTATE.connected and obj_login.login_state == LOGINSTATE.success) {
	var move = jsonrpc_create_request("mouse", [obj_login.player_id, mouse_id, x, y, alive]);
	ds_queue_enqueue(obj_connection.transmit_queue, move);
}
alarm[1] = alarm_reload_value;