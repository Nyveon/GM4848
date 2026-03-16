for (var col = board_width_cells - 1; col >= 0; col--) {
	for (var row = board_height_cells - 1; row >= 0; row--) {
			var _cell = cells[col][row]
			draw_sprite(spr_frame, 0, _cell.x - 5, _cell.y - 5);
	}
}

// draw inventory


anchory = board_topleft_y + board_height_px 

invposx = 16
invposy = anchory
invgap = 28

for (var element = array_length(inventory) - 1; element >= 0; element--) {
	if (creationparticles == element) {
		particles(invposx + 8, invposy + 8, 64, -2, material_colors[element], 64)
		audio_play_sound(dcreate, 0, false);
		creationparticles = -1
	}
	
	var _spr = material_sprites[element]
	repeat (inventory[element]) {
		draw_sprite(_spr, 0, invposx, invposy)
		invposy -= invgap
	}
	
	if (destructionparticles == element) {
		particles(invposx + 8, invposy + 8, 64, 3, material_colors[element], 8)
		audio_play_sound(ddestroy, 0, false);
		destructionparticles = -1
	}
}


_xcenter = room_width / 2
_ycenter = room_height / 2

if gamestate == 1 {
	var _wintext = "Chryospeia. You win. [space] to restart."
	draw_set_font(font_blackletter_big);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	
	draw_set_color(c_black);
	draw_text(_xcenter + 1, _ycenter + 1, _wintext)
	draw_text(_xcenter - 1, _ycenter - 1, _wintext)
	draw_text(_xcenter - 1, _ycenter + 1, _wintext)
	draw_text(_xcenter + 1, _ycenter - 1, _wintext)
	
	draw_set_color(#FFD700);
	draw_text(_xcenter, _ycenter, _wintext)
} else if gamestate == 2 {
	var _wintext = "You broke the tablet. [space] to try again."
	draw_set_font(font_blackletter_big);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	
	draw_set_color(c_black);
	draw_text(_xcenter + 1, _ycenter + 1, _wintext)
	draw_text(_xcenter - 1, _ycenter - 1, _wintext)
	draw_text(_xcenter - 1, _ycenter + 1, _wintext)
	draw_text(_xcenter + 1, _ycenter - 1, _wintext)
	
	draw_set_color(#780606);
	draw_text(_xcenter, _ycenter, _wintext)	
}