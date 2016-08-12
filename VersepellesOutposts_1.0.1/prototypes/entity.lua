local ent  -- placeholder for building each entity

-- Large Scorchmark
ent = util.table.deepcopy(data.raw["corpse"]["small-scorchmark"])
ent.name = "large-scorchmark"
ent.animation =
    {
      sheet=
      {
        width = 220,
        height = 180,
        frame_count = 1,
        direction_count = 1,
        filename = "__VersepellesOutposts__/graphics/entity/large-scorchmark/large-scorchmark.png",
        variation_count = 3
      }
    }
ent.ground_patch =
    {
      sheet =
      {
        width = 220,
        height = 180,
        frame_count = 1,
        direction_count = 1,
        x = 220 * 2,
        filename = "__VersepellesOutposts__/graphics/entity/large-scorchmark/large-scorchmark.png",
        variation_count = 3
      }
    }
ent.ground_patch_higher =
    {
      sheet =
      {
        width = 220,
        height = 180,
        frame_count = 1,
        direction_count = 1,
        x = 220,
        filename = "__VersepellesOutposts__/graphics/entity/large-scorchmark/large-scorchmark.png",
        variation_count = 3
      }
    }
data:extend({ent})

-- Outposts, built from the dictionary located in config.lua
for name, outpost_data in pairs(outpost_dict) do
	if outpost_data.type == "mining" then
		ent = util.table.deepcopy(data.raw["container"]["steel-chest"])
		ent.name = name
		ent.minable.result = nil
		ent.corpse = "big-remnants"
		ent.collision_box = {{-1.4, -1.4}, {1.4, 1.4}}
		ent.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
		ent.icon = "__VersepellesOutposts__/graphics/icons/mining-outpost.png"
		ent.picture = 
			{
			  filename = "__VersepellesOutposts__/graphics/entity/mining-outpost/mining-outpost.png",
			  width = 156,
			  height = 127,
			  shift = {0.95, 0.2}
			}
		ent.inventory_size = 40
		ent.order = "z[outposts]-a"
		data:extend({ent})
	elseif outpost_data.type == "assembling" then
		ent = util.table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
		ent.name = name
		ent.minable.result = nil
		ent.collision_box = {{-1.4, -1.4}, {1.4, 1.4}}
		ent.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
		ent.module_specification = {module_slots = 0}
		ent.allowed_effects = nil
		ent.icon = "__VersepellesOutposts__/graphics/icons/assembling-outpost.png"
		ent.animation = 
			{
			  filename = "__VersepellesOutposts__/graphics/entity/assembling-outpost/assembling-outpost.png",
			  priority = "high",
			  width = 156,
			  height = 127,
			  frame_count = 1,
			  line_length = 1,
			  shift = {0.95, 0.2}
			}
		ent.crafting_speed = 1.00
		ent.energy_source =
			{
			  type = "electric",
			  usage_priority = "secondary-input",
			  emissions = 0
			}
		ent.energy_usage = "1kW"
		ent.ingredient_count = 2
		ent.crafting_categories = {name}
		ent.order = "z[outposts]-a"
		data:extend({ent})
	end
end


-- Depository Outpost
ent = util.table.deepcopy(data.raw["container"]["steel-chest"])
ent.name = "depository-outpost"
ent.minable.result = nil
ent.corpse = "big-remnants"
ent.collision_box = {{-1.4, -1.4}, {1.4, 1.4}}
ent.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
ent.icon = "__VersepellesOutposts__/graphics/icons/depository-outpost.png"
ent.picture = 
	{
	  filename = "__VersepellesOutposts__/graphics/entity/depository-outpost/depository-outpost.png",
	  width = 156,
	  height = 127,
	  shift = {0.95, 0.2}
	}
ent.inventory_size = 40
ent.order = "z[outposts]-a"
data:extend({ent})

-- Outpost Rocket Silo
ent = util.table.deepcopy(data.raw["rocket-silo"]["rocket-silo"])
ent.name = "outpost-rocket-silo"
ent.energy_usage = "1KW"
ent.idle_energy_usage = "1KW"
ent.lamp_energy_usage = "1KW"
ent.active_energy_usage = "1KW"
ent.order = "z[outposts]-a"
data:extend({ent})

-- Exploration Vehicle
ent = util.table.deepcopy(data.raw["car"]["car"])
ent.name = "exploration-vehicle"
ent.minable.result = "exploration-vehicle"
ent.max_health = 10000
data:extend({ent})