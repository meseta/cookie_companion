/// @description

draw_set_color(c_black);
draw_rectangle(64, 64, display_get_gui_width()-64, display_get_gui_height()-64, false);

draw_set_color(c_white);
draw_set_halign(fa_middle);
draw_text(display_get_gui_width()/2, 84, "CLASS SELECT");

draw_set_color(c_dkgray);
draw_text(display_get_gui_width()/2, 185, "LEFT/RIGHT to select.  SPACE to start.");

if (select == CHARACTERCLASS.cookie) {
	draw_set_color(c_green);
	draw_text(display_get_gui_width()/2, 110, "Move the cookie");
	draw_text(display_get_gui_width()/2, 122, "using ARROW KEYS");
	draw_text(display_get_gui_width()/2, 134, "to the milk to");
	draw_text(display_get_gui_width()/2, 146, "dunk that cookie");
}
else if (select == CHARACTERCLASS.cat) {
	draw_set_color(c_orange);
	draw_text(display_get_gui_width()/2, 110, "Defend cookies");
	draw_text(display_get_gui_width()/2, 122, "by swatting the");
	draw_text(display_get_gui_width()/2, 134, "mice with SPACE");
}

if (select == CHARACTERCLASS.cookie) {
	draw_set_color(c_dkgray)
	draw_rectangle(84, 84, 84+64, 84+64, false);
	draw_set_color(c_green);
}
else {
	draw_set_color(c_white);
}
draw_rectangle(84, 84, 84+64, 84+64, true);
draw_sprite(spr_myhand, 0, 84+16+sprite_get_xoffset(spr_myhand) , 84+sprite_get_yoffset(spr_myhand));
draw_sprite(spr_cookieheld, 0, 84+16+sprite_get_xoffset(spr_myhand) , 84+sprite_get_yoffset(spr_myhand));
draw_sprite(spr_myhand, 1, 84+16+sprite_get_xoffset(spr_myhand) , 84+sprite_get_yoffset(spr_myhand));
draw_text(84+32, 84+64+5, "COOKIE");

if (select == CHARACTERCLASS.cat) {
	draw_set_color(c_dkgray)
	draw_rectangle(display_get_gui_width()-84, 84, display_get_gui_width()-84-64, 84+64, false);
	draw_set_color(c_orange);
}
else {
	draw_set_color(c_white);
}

draw_rectangle(display_get_gui_width()-84, 84, display_get_gui_width()-84-64, 84+64, true);
draw_sprite(spr_cathand, 0, display_get_gui_width()-84-64+16+sprite_get_xoffset(spr_cathand), 84+sprite_get_yoffset(spr_cathand))
draw_text(display_get_gui_width()-84-32, 84+64+5, "COMPANION");