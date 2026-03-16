_xcenter = room_width / 2
_ycenter = room_height / 2

if gamestate == 1 {
	var _wintext = "Chryospeia, you win. [space] to restart."
	draw_set_font(font_blackletter_big);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	
	draw_set_color(c_black);
	draw_text(_xcenter + 2, _ycenter + 2, _wintext)
	draw_text(_xcenter - 2, _ycenter - 2, _wintext)
	draw_text(_xcenter - 2, _ycenter + 2, _wintext)
	draw_text(_xcenter + 2, _ycenter - 2, _wintext)
	
	draw_set_color(#FFD700);
	draw_text(_xcenter, _ycenter, _wintext)
} else if gamestate == 2 {
	var _wintext = "You broke the tablet. [space] to try again."
	draw_set_font(font_blackletter_big);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	
	draw_set_color(c_black);
	draw_text(_xcenter + 2, _ycenter + 2, _wintext)
	draw_text(_xcenter - 2, _ycenter - 2, _wintext)
	draw_text(_xcenter - 2, _ycenter + 2, _wintext)
	draw_text(_xcenter + 2, _ycenter - 2, _wintext)
	
	draw_set_color(#780606);
	draw_text(_xcenter, _ycenter, _wintext)	
}