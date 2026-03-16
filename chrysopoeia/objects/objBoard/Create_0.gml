// Game config
board_width_cells = 8
board_height_cells = 8
total_cells = board_width_cells * board_height_cells

// 4 means types: 4, 3, 2, 1, 0
// Power will be: 16, 8, 4, 2, 1
largest_device_type = 4;

// containers
flatcells = [] //1d array
cells = [] //2d array
inventory = []


// UI config
cell_size_px = 48

board_width_px = board_width_cells * cell_size_px
board_height_px = board_height_cells * cell_size_px

board_topleft_x = cell_size_px*1.5
board_topleft_y = cell_size_px*1


gamestate = 0; // 1 is win, 2 is lose


// Resets all game state necessary and make a fresh board
// TODO: re-gen board if first click isn't in a good spot
function generate_board() {
	// 1. Create cells & registry
	flatcells = array_create(total_cells, noone) // for random generation
	cells = array_create(board_width_cells, noone)
	_x = board_topleft_x
	for (var col = 0; col < board_width_cells; col++) {
		_y = board_topleft_y
		cells[col] = array_create(board_height_cells, noone)

		for (var row = 0; row < board_height_cells; row++) {
			 var _cell = instance_create_layer(_x, _y, "Instances", objCell)
			 _y += cell_size_px
			 cells[col][row] = _cell
			 flatcells[col*board_height_cells + row] = _cell
		}
		_x += cell_size_px
	}
	
	// 2. Generate Device Data
    var devices = [];
    var current_type = largest_device_type;
    var count_to_add = 1; 
    
    while (current_type >= 0) {
        
        repeat(count_to_add) {
            if (array_length(devices) < total_cells) {
                array_push(devices, current_type);
            }
        }
        
        current_type -= 1;
        count_to_add *= 2;
    }
    
    // 3. Shuffle and Apply
	
	var corners = [
		cells[0][0], // Top-Left
		cells[board_width_cells - 1][0], // Top-Right
		cells[0][board_height_cells - 1], // Bottom-Left
		cells[board_width_cells - 1][board_height_cells - 1] // Bottom-Right
	];
	
	// Pre-configure the corners with 0
	var valid_cells = [];
	for (var i = 0; i < array_length(flatcells); i++) {
		var _cell = flatcells[i];
		var _is_corner = (_cell == corners[0] || _cell == corners[1] || _cell == corners[2] || _cell == corners[3]);
		
		if (!_is_corner) {
			array_push(valid_cells, _cell);
		}
	}
	
    array_shuffle_ext(devices);
    array_shuffle_ext(valid_cells);
    
	var fill_limit = min(array_length(devices), array_length(valid_cells));
	for (var i = 0; i < fill_limit; i++) {
		valid_cells[i].configure(devices[i]);
	}
	
	// 4. Set neighbors
	for (var col = 0; col < board_width_cells; col++) {
        for (var row = 0; row < board_height_cells; row++) {
            var _cell = cells[col][row];
            
            // Order: N, NE, E, SE, S, SW, W, NW
            _cell.neighbors = array_create(8, noone);
            
            var _directions = [
                [ 0, -1], // 0: North
                [ 1, -1], // 1: North-East
                [ 1,  0], // 2: East
                [ 1,  1], // 3: South-East
                [ 0,  1], // 4: South
                [-1,  1], // 5: South-West
                [-1,  0], // 6: West
                [-1, -1]  // 7: North-West
            ];
            
            for (var i = 0; i < 8; i++) {
                var _check_col = col + _directions[i][0];
                var _check_row = row + _directions[i][1];
                
                if (_check_col >= 0 && _check_col < board_width_cells && 
                    _check_row >= 0 && _check_row < board_height_cells) {
                    _cell.neighbors[i] = cells[_check_col][_check_row];
                }
            }
        }
    }
	
	// Post-cconfiguration
	refresh_cells()
	
	// 5. Reset inventory
	inventory = array_create(largest_device_type + 1, 0)
	count_to_add /= 2
	inventory[0] = count_to_add
	show_debug_message(inventory)
	/*
	for (var i = 0; i < count_to_add; i++) {
		var _item = instance_create_layer(invposx, invposy, "Instances", objItem)
		_item.config(0)
		invposy += invgap
	}
	*/
	
	for (var i = 0; i < 4; i++) {
		corners[i].probe()
	}
}

// Re-calculates all cell values
function refresh_cells() {
	for (var i = 0; i < array_length(flatcells); i++) {
		flatcells[i].post_config()
	}
}

generate_board()

material_sprites = [
	sprLead,
	blackash,
	calyx,
	selene,
	ether,
]

material_colors = [
	c_dkgray,
	c_black,
	c_teal,
	c_aqua,
	c_orange,
]

creationparticles = -1
destructionparticles = -1
