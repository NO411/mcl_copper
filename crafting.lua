minetest.register_craft({
	output = "mcl_copper:block_raw",
	recipe = {
		{ "mcl_copper:raw_copper", "mcl_copper:raw_copper", "mcl_copper:raw_copper" },
		{ "mcl_copper:raw_copper", "mcl_copper:raw_copper", "mcl_copper:raw_copper" },
		{ "mcl_copper:raw_copper", "mcl_copper:raw_copper", "mcl_copper:raw_copper" },
	}
})
minetest.register_craft({
	output = "mcl_copper:block",
	recipe = {
		{ "mcl_copper:copper_ingot", "mcl_copper:copper_ingot" },
		{ "mcl_copper:copper_ingot", "mcl_copper:copper_ingot" },
	}
})
minetest.register_craft({
	output = "mcl_copper:block_cut 4",
	recipe = {
		{ "mcl_copper:block", "mcl_copper:block" },
		{ "mcl_copper:block", "mcl_copper:block" },
	}
})
minetest.register_craft({
	output = "mcl_copper:block_exposed_cut 4",
	recipe = {
		{ "mcl_copper:block_exposed", "mcl_copper:block_exposed" },
		{ "mcl_copper:block_exposed", "mcl_copper:block_exposed" },
	}
})
minetest.register_craft({
	output = "mcl_copper:block_oxidized_cut 4",
	recipe = {
		{ "mcl_copper:block_oxidized", "mcl_copper:block_oxidized" },
		{ "mcl_copper:block_oxidized", "mcl_copper:block_oxidized" },
	}
})
minetest.register_craft({
	output = "mcl_copper:mcl_copper:block_weathered_cut 4",
	recipe = {
		{ "mcl_copper:block_weathered", "mcl_copper:block_weathered" },
		{ "mcl_copper:block_weathered", "mcl_copper:block_weathered" },
	}
})
minetest.register_craft({
	output = "mcl_copper:copper_ingot 4",
	recipe = {
		{ "mcl_copper:block" },
	}
})
minetest.register_craft({
	output = "mcl_copper:raw_copper 9",
	recipe = {
		{ "mcl_copper:block_raw" },
	}
})
minetest.register_craft({
	type = "cooking",
	output = "mcl_copper:copper_ingot",
	recipe = "mcl_copper:raw_copper",
	cooktime = 10,
})
minetest.register_craft({
	type = "cooking",
	output = "mcl_copper:copper_ingot",
	recipe = "mcl_copper:stone_with_copper",
	cooktime = 10,
})