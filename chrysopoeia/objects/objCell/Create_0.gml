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
STATE_PROBED = 1
STATE_DEAD = 2 // if it lost the game
STATE_GATHERED = 3
cell_state = STATE_HIDDEN
is_hinting = false

// -- UI state
was_hovering = false
is_hovering = false
is_pseudo_hovering = false

// -- Skin
sprite_decal1 = matrixclosed
sprite_decal2 = matrixopen
sprite_decal3 = matrixspent


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
	is_hinting = true
}


/* Activate cell if possible */
function reveal() {
	if (cell_state != STATE_HIDDEN) return;
	cell_state = STATE_PROBED
	show_debug_message("swish")
}

/* Activate a cells power */
function activate() {
	if device_type == DEVMATRIX {
		show_debug_message("boop")
		hint()
		/*
		for_orthogonal(function(_neighbor) {
	        _neighbor.hint();
	    });
		*/
	} else {
		// is alcheming time
		var _cost = 2
		if device_type == 0 {
			_cost = 1
		}
	
		var _materia_prima = objBoard.inventory[device_type]
		if _materia_prima < _cost {
			// TODO: dead state
			objBoard.gamestate = 2;
			cell_state = STATE_PROBED
			show_debug_message("lose")
			return
		}
	
		// animate or whatever
		show_debug_message("good")
		objBoard.destructionparticles = device_type
		objBoard.inventory[device_type] -= _cost
	}
	
	cell_state = STATE_PROBED
	show_debug_message("woosh")
}

// second click on device gathers the resource
function gather() {
	if (device_type == DEVMATRIX) return;
	
	if (device_type == 4) {
		particles(x + 24, y + 24, 256, 3, #FFD700, 48)
		objBoard.gamestate = 1;
		return
	}
	
	var _benefit = 1
	objBoard.inventory[device_type + 1] += _benefit
	objBoard.creationparticles = device_type + 1
	cell_state = STATE_GATHERED
	device_power = 0 // No longer count for sums
	objBoard.refresh_cells()
	show_debug_message("clink")

}

// -----
function probe() {
	switch (cell_state) {
		case STATE_HIDDEN: // Showing nothing
			activate()
			break;
			
		case STATE_PROBED: // Showing device
			gather()
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


// gets color corresponding to last digit
function get_color_from_number(_value) {
    var _digit = abs(_value) % 10;

    static _colors = [
        #e3ab63, // 0: Sunlit Clay
        #81bbfc, // 1: Baby Blue Ice
        #f59d85, // 2: Tangerine Dream
        #57ceb9, // 3: Turquoise
        #da9edf, // 4: Plum
        #bdbc64, // 5: Golden Sand
        #52c8e4, // 6: Sky Aqua
        #f198b4, // 7: Pink Mist
        #8aca89, // 8: Willow Green
        #b3abfa  // 9: Periwinkle
    ];
    
    return _colors[_digit];
}