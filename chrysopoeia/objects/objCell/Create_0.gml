// -- Game state

// neighboring cells
neighbors = []
hint_value = 0 // sum of neighboring cell machines

// device types (see config for each below)
// -1 - matrix
// 0 - calcinator (power 1)
// 1 - quern (power 2)
// 2 - alembic (power 4)
// 3 - athanor (power 8)
// 4 - aludel (power 16)
DEVMATRIX = -1
device_type = DEVMATRIX
device_power = 0
device_name = "Matrix"

STATE_HIDDEN = 0
STATE_HINTING = 1
STATE_PROBED = 2
cell_state = STATE_HIDDEN


// -- UI state
is_hovering = false

// -- Skin
sprite_decal = sprDev00


function cc(_power, _sprite, _name, _procname) {
	return {
		devpower: _power,
		devrune: _sprite, // sprite
		devname: _name, // device
		procname: _procname // element being added, unused for now
	}
}

configs = [
	cc(1, sprDev01, "Calcinator", "Fire"),
	cc(2, sprDev02, "Quern", "Earth"),
	cc(4, sprDev04, "Alembic", "Water"),
	cc(8, sprDev08, "Athanor", "Air"),
	cc(16, sprDev16, "Aludel", "Aether"),
]

// Initializing the cell
function configure(_device_type) {
	device_type = _device_type
	
	var _config = configs[device_type]
	device_power = _config.devpower
	sprite_decal = _config.devrune
	device_name = _config.devname
}


// -----
function probe() {
	if cell_state == STATE_PROBED {
		show_debug_message("noop")
		return
	}
	
	if device_type == DEVMATRIX {
		show_debug_message("boop")
		matrix_reveal()
		reveal()
		return
	}
	
	var _cost = 2
	var _benefit = 1
	if device_type == 0 {
		_cost = 1
	}
	
	var _materia_prima = objBoard.inventory[device_type]
	if _materia_prima < _cost {
		show_debug_message("lose")
		return
	}
	
	// animate or whatever
	show_debug_message("good")
	objBoard.inventory[device_type] -= _cost
	objBoard.inventory[device_type + 1] += _benefit
	reveal()
}

/* Reveal cell if possible */
function reveal() {
	if cell_state == STATE_PROBED {
		show_debug_message("noop")
		return
	}
	cell_state = STATE_PROBED
	device_power = 0 // No longer count for sums
	objBoard.refresh_cells()
	show_debug_message("woosh")
}

/* Switch to hint state if possible */
function hint() {
	if cell_state != STATE_HIDDEN {
		return
	}
	cell_state = STATE_HINTING
}

// Special behavior for matrix which triggers hints
function matrix_reveal() {
	// TODO: still deciding how to balance this.
	for (var i = 0; i < array_length(neighbors); i++) {
		var _neighbor = neighbors[i];
		if (_neighbor == noone) continue;
		
		neighbors[i].hint()
	}
}

/* refresh cells values */
function post_config() {
    var _total_power = 0;
    
    for (var i = 0; i < array_length(neighbors); i++) {
        var _neighbor = neighbors[i];
		if (_neighbor == noone) continue;

        if (_neighbor != noone) {
            _total_power += _neighbor.device_power;
        }
    }
    
    hint_value = _total_power
}