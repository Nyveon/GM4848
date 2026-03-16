// Hover Interactions

if objBoard.gamestate == 0 {
	if (position_meeting(mouse_x, mouse_y, id)) {
	    is_hovering = true
	} else {
	    is_hovering = false
	}

	/*
	if (was_hovering && !is_hovering) {
		for_each_neighbor(function(_neighbor) {
	        _neighbor.is_pseudo_hovering = false
	    });
	} else if (!was_hovering && is_hovering && cell_state == STATE_HINTING) {
		for_each_neighbor(function(_neighbor) {
	        _neighbor.is_pseudo_hovering = true
	    });
	}
	*/


	was_hovering = is_hovering
}
