/// @description

if (character_class == CHARACTERCLASS.unknown) exit;

var yy = y - animation_height;
var shadow_scale = max(0, 1-(animation_height/200));
var xx = x + (shake? irandom_range(-2, 2): 0);

draw_sprite_ext(spr_shadow, 0, x, y, shadow_scale, shadow_scale, 0, c_white, 0.1);
if (character_class == CHARACTERCLASS.cat) {
	draw_sprite_ext(spr_ghostcathand, (attacking? 1: 0), xx, yy, 1, 1, 0, c_white, 0.5);
}
else {
	if (attacking) {
		draw_sprite_ext(spr_ghosthand, 2, xx, yy, 1, 1, 0, c_white, 0.5);
	}
	else {
		draw_sprite_ext(spr_ghosthand, 0, xx, yy, 1, 1, 0, c_white, 0.5);

		if (has_cookie) {
			draw_sprite(spr_cookieheld, 0, xx, yy);	
		}

		draw_sprite_ext(spr_ghosthand, 1, xx, yy, 1, 1, 0, c_white, 0.5);
	}
}


draw_set_color(c_blue);
draw_set_font(fnt_default);
draw_set_halign(fa_middle);
draw_text(x, y+8, username);
draw_set_halign(fa_left);

var stars = sqrt(myscore);
for (var i=0; i < 5 and i < stars; i++) {
	draw_sprite_ext(spr_star, 0, x+(i-2)*8, y+20, 1, 1, 0, c_green, 1.0);
}
draw_set_color(c_white);