local register_oxidation_abm = function(abm_name, node_name, oxidized_varient)
	minetest.register_abm({
		label = abm_name,
		nodenames = node_name,
		interval = 500,
		chance = 3,
		action = function(pos, node)
			minetest.swap_node(pos, {name=oxidized_varient, param2=node.param2})
		end
	})
end

local stairs = {
	{"mcl_stairs:stair_copper_exposed_cut_inner", "mcl_stairs:stair_copper_cut_inner"},
	{"mcl_stairs:stair_copper_weathered_cut_inner", "mcl_stairs:stair_copper_exposed_cut_inner"},
	{"mcl_stairs:stair_copper_exposed_cut_outer", "mcl_stairs:stair_copper_cut_outer"},
	{"mcl_stairs:stair_copper_weathered_cut_outer", "mcl_stairs:stair_copper_exposed_cut_outer"},
	{"mcl_stairs:stair_copper_oxidized_cut_outer", "mcl_stairs:stair_copper_weathered_cut_outer"},
	{"mcl_stairs:stair_copper_oxidized_cut_inner", "mcl_stairs:stair_copper_weathered_cut_inner"},
	{"mcl_stairs:slab_copper_exposed_cut","mcl_stairs:slab_copper_cut"},
	{"mcl_stairs:slab_copper_oxidized_cut","mcl_stairs:slab_copper_weathered_cut"},
	{"mcl_stairs:slab_copper_weathered_cut","mcl_stairs:slab_copper_exposed_cut"},
	{"mcl_stairs:slab_copper_exposed_cut_top","mcl_stairs:slab_copper_cut_top"},
	{"mcl_stairs:slab_copper_oxidized_cut_top","mcl_stairs:slab_copper_weathered_cut_top"},
	{"mcl_stairs:slab_copper_weathered_cut_top","mcl_stairs:slab_copper_exposed_cut_top"},
	{"mcl_stairs:slab_copper_exposed_cut_double","mcl_stairs:slab_copper_cut_double"},
	{"mcl_stairs:slab_copper_oxidized_cut_double","mcl_stairs:slab_copper_weathered_cut_double"},
	{"mcl_stairs:slab_copper_weathered_cut_double","mcl_stairs:slab_copper_exposed_cut_double"},
	{"mcl_stairs:stair_copper_exposed_cut","mcl_stairs:stair_copper_cut"},
	{"mcl_stairs:stair_copper_oxidized_cut","mcl_stairs:stair_copper_weathered_cut"},
	{"mcl_stairs:stair_copper_weathered_cut","mcl_stairs:stair_copper_exposed_cut"},	
}

local anti_oxidation_particles = function(pointed_thing)
	local pos = pointed_thing.under
	minetest.add_particlespawner({
		amount = 8,
		time = 1,
		minpos = {x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
		maxpos = {x = pos.x + 1, y = pos.y + 1, z = pos.z + 1},
		minvel = {x = 0, y = 0, z = 0},
		maxvel = {x = 0, y = 0, z = 0},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = -0.1, z = 0},
		minexptime = 0.5,
		maxexptime = 1,
		minsize = 1,
		maxsize = 2.5,
		collisiondetection = false,
		vertical = false,
		texture = "mcl_copper_anti_oxidation_particle.png",
		glow = 5,
	})
end

local add_wear = function(placer, itemstack)
	if not minetest.is_creative_enabled(placer:get_player_name()) then
		local tool = itemstack:get_name()
		local wear = mcl_autogroup.get_wear(tool, "axey")
		itemstack:add_wear(wear)
	end
end

local anti_oxidation = function(itemstack, placer, pointed_thing)
    if pointed_thing.type ~= "node" then return end

	local node = minetest.get_node(pointed_thing.under)
    local noddef = minetest.registered_nodes[minetest.get_node(pointed_thing.under).name]

    if not placer:get_player_control().sneak and noddef.on_rightclick then
        return minetest.item_place(itemstack, placer, pointed_thing)
    end

    if minetest.is_protected(pointed_thing.under, placer:get_player_name()) then
        minetest.record_protection_violation(pointed_thing.under, placer:get_player_name())
        return itemstack
    end

    if noddef._mcl_stripped_varient == nil then
		for _, c in pairs(stairs) do
			if noddef.name == c[1] then
				minetest.swap_node(pointed_thing.under, {name=c[2], param2=node.param2})
				anti_oxidation_particles(pointed_thing)
				add_wear(placer, itemstack)
			end
		end
		if noddef._mcl_anti_oxidation_varient ~= nil then
			minetest.swap_node(pointed_thing.under, {name=noddef._mcl_anti_oxidation_varient, param2=node.param2})
			anti_oxidation_particles(pointed_thing)
			add_wear(placer, itemstack)
		end
	else 
		minetest.swap_node(pointed_thing.under, {name=noddef._mcl_stripped_varient, param2=node.param2})
		add_wear(placer, itemstack)
	end
    return itemstack
end

local register_axe_override = function(axe_name)
	minetest.override_item("mcl_tools:axe_"..axe_name, {
		on_place = anti_oxidation,
	})
end

local stonelike = {"mcl_core:stone", "mcl_core:diorite", "mcl_core:andesite", "mcl_core:granite"}

if minetest.settings:get_bool("mcl_generate_ores", true) then
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "mcl_copper:stone_with_copper",
		wherein        = stonelike,
		clust_scarcity = 830,
		clust_num_ores = 5,
		clust_size     = 3,
		y_min          = mcl_vars.mg_overworld_min,
		y_max          = mcl_worlds.layer_to_y(39),
	})
	minetest.register_ore({
		ore_type       = "scatter",
		ore            = "mcl_copper:stone_with_copper",
		wherein        = stonelike,
		clust_scarcity = 1660,
		clust_num_ores = 4,
		clust_size     = 2,
		y_min          = mcl_worlds.layer_to_y(40),
		y_max          = mcl_worlds.layer_to_y(63),
	})
end

register_oxidation_abm("Copper block oxidation", {"mcl_copper:block"}, "mcl_copper:block_exposed")
register_oxidation_abm("Cut copper block oxidation", {"mcl_copper:block_cut"}, "mcl_copper:block_exposed_cut")
register_oxidation_abm("Exposed copper oxidation", {"mcl_copper:block_exposed"}, "mcl_copper:block_weathered")
register_oxidation_abm("Cut exposed copper oxidation", {"mcl_copper:block_exposed_cut"}, "mcl_copper:block_weathered_cut")
register_oxidation_abm("Weathered copper oxidation", {"mcl_copper:block_weathered"}, "mcl_copper:block_oxidized")
register_oxidation_abm("Cut weathered copper oxidation", {"mcl_copper:block_weathered_cut"}, "mcl_copper:block_oxidized_cut")
register_oxidation_abm("Cut copper slab oxidation", {"mcl_stairs:slab_copper_cut"}, "mcl_stairs:slab_copper_exposed_cut")
register_oxidation_abm("Cut exposed copper slab oxidation", {"mcl_stairs:slab_copper_exposed_cut"}, "mcl_stairs:slab_copper_weathered_cut")
register_oxidation_abm("Cut weathered copper slab oxidation", {"mcl_stairs:slab_copper_weathered_cut"}, "mcl_stairs:slab_copper_oxidized_cut")
register_oxidation_abm("Cut top copper slab oxidatiom", {"mcl_stairs:slab_copper_cut_top"}, "mcl_stairs:slab_copper_exposed_cut_top")
register_oxidation_abm("Cut exposed copper slab oxidation", {"mcl_stairs:slab_copper_exposed_cut_top"}, "mcl_stairs:slab_copper_weathered_cut_top")
register_oxidation_abm("Cut weathered top copper slab", {"mcl_stairs:slab_copper_weathered_cut_top"}, "mcl_stairs:slab_copper_oxidized_cut_double")
register_oxidation_abm("Cut double copper slab oxidation", {"mcl_stairs:slab_copper_cut_double"}, "mcl_stairs:slab_copper_exposed_cut_double")
register_oxidation_abm("Cut exposed double copper slab oxidation", {"mcl_stairs:slab_copper_exposed_cut_double_inner"}, "mcl_stairs:slab_copper_weathered_cut_double")
register_oxidation_abm("Cut weathered double copper slab oxidation", {"mcl_stairs:slab_copper_weathered_cut_double"}, "mcl_stairs:slab_copper_oxidized_cut_double")
register_oxidation_abm("Cut copper stair oxidation", {"mcl_stairs:stair_copper_cut"}, "mcl_stairs:stair_copper_exposed_cut")
register_oxidation_abm("Cut exposed copper stair oxidation", {"mcl_stairs:stair_copper_exposed_cut"}, "mcl_stairs:stair_copper_weathered_cut")
register_oxidation_abm("Cut weathered copper stair oxidation", {"mcl_stairs:stair_copper_weathered_cut"}, "mcl_stairs:stair_copper_oxidized_cut")
register_oxidation_abm("Inner cut copper stair oxidation", {"mcl_stairs:stair_copper_cut_inner"}, "mcl_stairs:stair_copper_exposed_cut_inner")
register_oxidation_abm("Inner cut exposed copper stair oxidation", {"mcl_stairs:stair_copper_exposed_cut_inner"}, "mcl_stairs:stair_copper_weathered_cut_inner")
register_oxidation_abm("Inner cut weathered copper stair oxidation", {"mcl_stairs:stair_copper_weathered_cut_inner"}, "mcl_stairs:stair_copper_oxidized_cut_inner")
register_oxidation_abm("Outer cut copper stair oxidation", {"mcl_stairs:stair_copper_cut_outer"}, "mcl_stairs:stair_copper_exposed_cut_outer")
register_oxidation_abm("Outer cut exposed copper stair oxidation", {"mcl_stairs:stair_copper_exposed_cut_outer"}, "mcl_stairs:stair_copper_weathered_cut_outer")
register_oxidation_abm("Outer cut weathered copper stair oxidation", {"mcl_stairs:stair_copper_weathered_cut_outer"}, "mcl_stairs:stair_copper_oxidized_cut_outer")

register_axe_override("wood")
register_axe_override("stone")
register_axe_override("iron")
register_axe_override("gold")
register_axe_override("diamond")