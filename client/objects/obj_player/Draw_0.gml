/// @description

if (character_class == CHARACTERCLASS.unknown) exit;

var yy = y - animation_height;
var shadow_scale = max(0, 1-(animation_height/200));
var xx = x + (shake? irandom_range(-2, 2): 0);

var dist_to_top = max(0, yy - 48)
draw_sprite_ext(spr_shadow, 0, x, y, shadow_scale, shadow_scale, 0, c_white, 0.2);

if (character_class == CHARACTERCLASS.cat) {
	draw_sprite_part_ext(spr_cathand, 0, 0, 0, 32, 1, xx-sprite_get_xoffset(spr_cathand), 0, 1, dist_to_top, c_white, 1.0);
	draw_sprite(spr_cathand, (attacking? 1: 0), xx, yy);
}
else {
	draw_sprite_part_ext(spr_myhand, 0, 0, 0, 32, 1, xx-sprite_get_xoffset(spr_myhand), 0, 1, dist_to_top, c_white, 1.0);

	if (attacking) {
		draw_sprite(spr_myhand, 2, xx, yy);
	}
	else {
		draw_sprite(spr_myhand, 0, xx, yy);

		if (has_cookie) {
			draw_sprite(spr_cookieheld, 0, xx, yy);	
		}

		draw_sprite(spr_myhand, 1, xx, yy);
	}
}

draw_set_color(c_green);
draw_set_font(fnt_default);
draw_set_halign(fa_middle);
draw_text(x, y+8, username);
draw_set_halign(fa_left);

var stars = sqrt(myscore);
for (var i=0; i < 5 and i < stars; i++) {
	draw_sprite_ext(spr_star, 0, x+(i-2)*8, y+20, 1, 1, 0, c_green, 1.0);
}
draw_set_color(c_white);