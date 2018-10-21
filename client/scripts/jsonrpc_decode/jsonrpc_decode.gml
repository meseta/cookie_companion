/// @description  decodes and routes the jsonrpc
/// @argument jsonstring	The json string to decode
/// @argument call_map		The ds_queue for RPC calls
/// @argument result_map	The ds_map for results

var jsonrpc = json_decode(argument0);
if (jsonrpc == -1) {
	scr_debug("Could not decode JSON", argument0);
	return;
}
//scr_debug("Decoded ", argument0);

var call_map = argument1;
var result_map = argument2;

if (ds_map_exists(jsonrpc, "method")) {
	// it's an RPC call
	//scr_debug("RPC call ", jsonrpc[? "method"]);
	jsonrpc_callmap_push(jsonrpc[? "method"], jsonrpc[? "params"], jsonrpc[? "id"], call_map);
}
else if (ds_map_exists(jsonrpc, "results") and ds_map_exists(jsonrpc, "id")) {
	// it's a result, push onto result map
	//scr_debug("RPC result ", jsonrpc[? "id"]);
	jsonrpc_resultmap_push(jsonrpc[? "id"], jsonrpc[? "results"], result_map);
}
else {
	scr_debug("Invalid JsonRPC ", jsonrpc);
	ds_map_destroy(jsonrpc);
}