if is_hovering {
	sprite_index = sprCellHover
} else {
	sprite_index = sprCell
}

draw_self()

// STATE_HIDDEN draw nothing
if cell_state == STATE_HINTING {
	if device_type == DEVMATRIX {
		if hint_value != 0 {
			draw_text(x + 32, y + 32, hint_value)
		}
	} else {
		draw_sprite(sprDevXX, 0, x, y)
	}
} else if cell_state == STATE_PROBED {
	draw_sprite(sprite_decal, 0, x, y)
}


// DEBUG
draw_text(x, y, device_power)
draw_text(x, y+16, hint_value)