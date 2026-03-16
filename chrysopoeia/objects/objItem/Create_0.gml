material = 0 // lead


material_sprites = [
	sprLead,
	blackash,
	calyx,
	selene,
	ether,
]

function config(_material) {
	material = _material
	sprite_index = material_sprites[material]
}