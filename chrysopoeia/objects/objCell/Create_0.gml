// -- Game state

// sum of neighboring cell machines
neighbors_value = 0

// which alchemical device
// 0 - matrix
// 1 - calcinator
// 2 - quern
// 4 - alembic
// 8 - athanor
// 16 - aludel
device_value = 0

STATE_HIDDEN = 0
STATE_HINTING = 1
STATE_PROBED = 2
cell_state = STATE_HIDDEN


// -- UI state
is_hovering = false

// -- Skin
sprite_decal = sprDev00
