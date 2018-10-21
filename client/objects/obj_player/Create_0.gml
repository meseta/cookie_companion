/// @description

enum CHARACTERCLASS {
	unknown=0,
	cookie=1,
	cat=2
}

has_cookie = 1;
character_class = CHARACTERCLASS.unknown;
username = ""

x = 60;
y = 60;
hspd = 0;
vspd = 0;
accel = 0.3;
decel = 0.2;
max_spd = 3;

alarm_reload_value = 5
alarm[0] = alarm_reload_value;

attacking = false;
attack_cooldown = 0;

enum PLAYERSTATE {
	char_select,
	spawn_in,
	spawn_out,
	movement,
	dunk_1,
	dunk_2,
	dunk_3
}

dunk_target = noone;
player_state = PLAYERSTATE.char_select;
animation_height = 100;
shake = false;

enum EVENTTYPE {
	attack,
	drop
}

myscore = 0;