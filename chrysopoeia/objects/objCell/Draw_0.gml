if is_hovering {
	sprite_index = sprCellHover
} else {
	sprite_index = sprCell
}


draw_self()


// STATE_HIDDEN draw nothing
if cell_state == STATE_HINTING {
	// draw number or question marks
	//draw_text()
} else if cell_state == STATE_PROBED {
	draw_sprite(sprite_decal, 0, x, y)
}


// DEBUG
draw_text(x, y, device_value)