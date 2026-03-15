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
STATE_USED = 3
STATE_DEAD = 4 // if it lost the game
cell_state = STATE_HIDDEN


// -- UI state
was_hovering = false
is_hovering = false
is_pseudo_hovering = false

// -- Skin
sprite_decal1 = matrixo
sprite_decal2 = matrixh
sprite_decal3 = matrixx


function cc(_power, _sprite_inactive, _sprite_active, _sprite_spent, _name, _procname) {
	return {
		devpower: _power,
		runeused: _sprite_spent,
		runeactive: _sprite_active,
		runeinactive: _sprite_inactive,
		devname: _name, // device
		procname: _procname // element being added, unused for now
	}
}

configs = [
	cc(1, calco, calch, calcx, "Calcinator", "Fire"),
	cc(2, querno, quernh, quernx, "Quern", "Earth"),
	cc(4, alemo, alemh, alemx, "Alembic", "Water"),
	cc(8, atho, athh, athx, "Athanor", "Air"),
	cc(16, aluo, aluh, aluh, "Aludel", "Aether"),
]

// Initializing the cell
function configure(_device_type) {
	device_type = _device_type
	
	var _config = configs[device_type]
	device_power = _config.devpower
	sprite_decal1 = _config.runeinactive
	sprite_decal2 = _config.runeactive
	sprite_decal3 = _config.runeused
	device_name = _config.devname
}


/* Switch to hint state if possible */
function hint() {
	if (cell_state != STATE_HIDDEN) return; 
	cell_state = STATE_HINTING
}


/* Activate cell if possible */
function reveal() {
	cell_state = STATE_PROBED
	show_debug_message("swish")
}

/* Activate a cells power */
function activate() {
	if device_type == DEVMATRIX {
		show_debug_message("boop")
		for_orthogonal(function(_neighbor) {
	        _neighbor.hint();
	    });
	} else {
		// is alcheming time
		var _cost = 2
		var _benefit = 1
		if device_type == 0 {
			_cost = 1
		}
	
		var _materia_prima = objBoard.inventory[device_type]
		if _materia_prima < _cost {
			// TODO: dead state
			show_debug_message("lose")
			return
		}
	
		// animate or whatever
		show_debug_message("good")
		objBoard.inventory[device_type] -= _cost
		objBoard.inventory[device_type + 1] += _benefit
	}
	
	cell_state = STATE_USED
	device_power = 0 // No longer count for sums
	objBoard.refresh_cells()
	
	show_debug_message("woosh")
}


// -----
function probe() {
	switch (cell_state) {
		case STATE_HIDDEN:
			hint()
			break;
			
		case STATE_HINTING:
			reveal()
			break;
			
		case STATE_PROBED:
			activate()
			break;
		
		default:
			show_debug_message(cell_state);
			break;
	}
}

/* refresh cell's values */
function post_config() {
    hint_value = 0;
	for_each_neighbor(function(_neighbor) {
        hint_value += _neighbor.device_power;
    });
	
	is_pseudo_hovering = false
}


// do thing to all neighbors
function for_each_neighbor(_thing) {
    for (var i = 0; i < array_length(neighbors); i++) {
        var _neighbor = neighbors[i];
        
        if (_neighbor != noone) {
            _thing(_neighbor);
        }
    }
}

// do to all orthogonal neighbors
function for_orthogonal(_callback) {
    // N, S, E, W
    for (var i = 0; i < 8; i += 2) {
        var _neighbor = neighbors[i];
        
        if (_neighbor != noone) {
            _callback(_neighbor);
        }
    }
}