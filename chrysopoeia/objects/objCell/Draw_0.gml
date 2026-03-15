// Hover & pseudohover
sprite_index = sprTile
if is_hovering {
	sprite_index = sprtilehover
} else if is_pseudo_hovering {
	sprite_index = sprCellPseudoHover
}

draw_self()

// STATE_HIDDEN draw nothing
if cell_state == STATE_HINTING {
	/*
	if device_type == DEVMATRIX {
		if hint_value != 0 {
			draw_text(x + 32, y + 32, hint_value)
		}
	} else {
		draw_sprite(sprDevXX, 0, x, y)
	}
	*/
	draw_set_font(font_blackletter);
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	draw_set_color(c_white);
	draw_text(x + sprite_width / 2, y + sprite_height / 2, hint_value)
	
} else if cell_state == STATE_PROBED {
	if is_hovering {
		draw_sprite(sprite_decal2, 0, x, y)
	} else {
		draw_sprite(sprite_decal1, 0, x, y)
	}
} else if cell_state == STATE_USED {
	// TODO: used variant
	draw_sprite(sprite_decal3, 0, x, y)
}


// DEBUG
draw_text(x, y, device_power)
draw_text(x, y+16, hint_value)