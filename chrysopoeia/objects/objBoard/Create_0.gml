// Game config
board_width_cells = 8
board_height_cells = 8
total_cells = board_width_cells * board_height_cells

// 4 means types: 4, 3, 2, 1, 0
// Power will be: 16, 8, 4, 2, 1
largest_device_type = 4;

// containers
cells = []
inventory = []

// UI config
cell_size_px = 64

board_width_px = board_width_cells * cell_size_px

board_topleft_x = 128
board_topleft_y = 128



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
	
	show_debug_message(devices)
    
    // 3. Shuffle and Apply
    array_shuffle_ext(devices);
    array_shuffle_ext(flatcells);
    
    var fill_limit = min(array_length(devices), array_length(flatcells));
    for (var i = 0; i < fill_limit; i++) {
        var _cell = flatcells[i];
        var _data = devices[i];
        
		_cell.configure(_data)
    }
	
	// 4. Reset inventory
	inventory = array_create(largest_device_type + 1, 0)
	inventory[0] = count_to_add
	show_debug_message(inventory)
}

generate_board()

