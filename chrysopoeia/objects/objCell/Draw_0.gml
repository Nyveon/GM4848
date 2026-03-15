// Hover & pseudohover
sprite_index = sprTile
if is_hovering {
	sprite_index = sprtilehover
} else if is_pseudo_hovering {
	sprite_index = sprCellPseudoHover
}

draw_self()


_xcenter = x + sprite_width / 2
_ycenter = y + sprite_height / 2


if (cell_state == STATE_PROBED) {
	if (device_type == DEVMATRIX) {
		if (hint_value != 0) {
			if (is_hovering) {
				draw_sprite(sprite_decal2, 0, x, y)
			} else {
				draw_sprite(sprite_decal1, 0, x, y)
			}
		} else {
			draw_sprite(sprite_decal3, 0, x, y)
		}
	} else {
		draw_sprite(sprite_decal2, 0, x, y)
	}
} else if (cell_state == STATE_GATHERED) {
	draw_sprite(sprite_decal1, 0, x, y)
}

if (is_hinting && hint_value != 0) {
	draw_set_font(font_blackletter);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	
	draw_set_color(c_black);
	draw_text(_xcenter + 1, _ycenter + 1, hint_value)
	draw_text(_xcenter - 1, _ycenter - 1, hint_value)
	draw_text(_xcenter - 1, _ycenter + 1, hint_value)
	draw_text(_xcenter + 1, _ycenter - 1, hint_value)
	
	var _col = get_color_from_number(hint_value)
	draw_set_color(_col);
	draw_text(_xcenter, _ycenter, hint_value)
}


// DEBUG
//draw_text(x, y, device_power)
//draw_text(x, y+16, hint_value)