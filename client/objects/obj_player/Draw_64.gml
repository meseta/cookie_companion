/// @description

if (character_class == CHARACTERCLASS.cookie and not has_cookie and player_state == PLAYERSTATE.movement) {
	draw_set_color(c_red);
	draw_set_halign(fa_middle);
	
    draw_text(display_get_gui_width()/2, display_get_gui_height()-32, "Press SPACE at spawn to receive new cookie");
	
}