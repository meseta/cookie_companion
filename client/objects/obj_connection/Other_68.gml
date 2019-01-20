/// @description RX data

var eventid = async_load[? "id"];
var type = async_load[? "type"];
show_debug_message(json_encode(async_load));
if (eventid == server_socket) {
	
	switch (type) {
	case network_type_connect: 
	case network_type_non_blocking_connect:
		if (async_load[? "succeeded"] == 1) {
			conn_state = CONNSTATE.handshake_start;
		}
		else {
			conn_state = CONNSTATE.disconnected;
		}
		break;
			
	case network_type_disconnect:
		conn_state = CONNSTATE.disconnected;
		break;
			
	case network_type_data:
		var buff = async_load[? "buffer"];
		var size = async_load[? "size"];
		buffer_seek(buff, buffer_seek_start, 0);
		//scr_debug("RX: ", string(size), " bytes");
		
		// de-buffer text
		var read_str = "";
		var result = 0;
		while (buffer_tell(buff) < size) {
			read_str = packet_chunk + buffer_read(buff, buffer_string);
			if (buffer_peek(buff, buffer_tell(buff)-1, buffer_u8) == 0) {
				// check if correctly null-terminated string
				result = jsonrpc_decode(read_str, call_map, result_map);
				packet_chunk = "";
			}
			else {
				// otherwise assume it's a chunk of data ready to be appended to the next message
				packet_chunk = read_str;	
			}
		}
		break;
	}
	
}
