/// @description
username = "Anon";

enum LOGINSTATE {
	player_input,
	login_start,
	login_wait,
	success,
	error
}

login_state = LOGINSTATE.player_input;
debug_text = "Undefined";
player_id = 0

ping_text = "";
ping_rpcid = undefined;
alarm[0] = room_speed/2;