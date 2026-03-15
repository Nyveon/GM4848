// -- Game state

// sum of neighboring cell machines
neighbors_value = 0

// device types
// -1 - matrix
// 0 - calcinator (power 1)
// 1 - quern (power 2)
// 2 - alembic (power 4)
// 3 - athanor (power 8)
// 4 - aludel (power 16)
device_type = -1
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
	
	if device_type == -1 {
		show_debug_message("boop")
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

function reveal() {
	cell_state = STATE_PROBED
	show_debug_message("woosh")
}