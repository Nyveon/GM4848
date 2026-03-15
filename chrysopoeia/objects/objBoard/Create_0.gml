// Game config
board_width_cells = 8
board_height_cells = 8
total_cells = board_width_cells * board_height_cells
largest_device_value = 16

// 2d array of cell instances
cells = []

// UI config
cell_size_px = 64

board_width_px = board_width_cells * cell_size_px

board_topleft_x = 128
board_topleft_y = 128




function generate_board() {
	// 1. Create cells & registry
	flatcells = array_create(total_cells, noone) // for random generation
	cells = array_create(board_width_cells, noone)
	_x = board_topleft_x
	for (var col = 0; col < board_width_cells; col++) {
		_y = board_topleft_y
		cells[col] = array_create(board_height_cells, noone)

		for (var row = 0; row < board_height_cells; row++) {
			 _cell = instance_create_layer(_x, _y, "Instances", objCell)
			 _y += cell_size_px
			 cells[col][row] = _cell
			 flatcells[col*board_height_cells + row] = _cell
		}
		_x += cell_size_px
	}
	
    // 2. Generate Dynamic Device List
    var devices = [];
    var current_val = largest_device_value;
    var count_to_add = 1;
    
    while (current_val >= 1) {
        repeat(count_to_add) {
            if (array_length(devices) < total_cells) {
                array_push(devices, current_val);
            }
        }
        
        current_val /= 2;   // Half the value (e.g., 16 -> 8)
        count_to_add *= 2;  // Double the quantity (e.g., 1 -> 2)
    }
    
    // 3. Populate
    array_shuffle_ext(devices);
    array_shuffle_ext(flatcells);
    
    // Only loop up to the length of devices or flatcells, whichever is smaller
    var fill_limit = min(array_length(devices), array_length(flatcells));
    for (var i = 0; i < fill_limit; i++) {
        flatcells[i].device_value = devices[i];
    }
	
}

generate_board()