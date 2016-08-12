require("config")

---------------------------------------------------------
-- Constants
local UPS = 60								-- updates per second, in case this varies
local gui_period = 1.0						-- how often to update the player's progress gui
local exploration_vehicle_period = 0.1		-- destroy trees and rocks every tenth of a second
local mining_outpost_period = 0.25			-- process outposts every second
local assembling_outpost_period = 10.0		-- process outposts every 10 seconds
local depository_outpost_period = 1.0		-- process depositories every second


---------------------------------------------------------
-- Display the welcome message to players
local function displayWelcome(player)
	if player.connected then
		local welcome_message = {{"welcome-a"}, {"welcome-b"}, {"welcome-c"}, {"welcome-d"}, {"welcome-e"}, {"welcome-f"}, {"welcome-g"}}
		transmission(welcome_message, player)
	end
end

---------------------------------------------------------
-- Handle new players
function newPlayer(event)
	local player = game.players[event.player_index]
	
	if remote.interfaces["Outposts"] == nil then
		local strings = {{"freeplay-warning-1"}, {"freeplay-warning-2"}, {"freeplay-warning-3"}, {"freeplay-warning-4"}}
		local transmission_frame = player.gui.center.add({name = "transmission-frame", type = "frame", direction = "vertical"})
		transmission_frame.add({name = "warning-title", type = "label", caption = {"warning-title"}, style = "bold_label_style"})
		transmission_flow = transmission_frame.add({name = "transmission-flow", type = "flow", direction = "vertical", style = "thin_flow_style"})
		for i, str in pairs(strings) do
			transmission_flow.add({name = "transmission-label-" .. i, type = "label", caption = str})
		end
		transmission_frame.add({name = "freeplay-warning-button", type = "button", caption = {"continue-transmission"}})
	else
		displayWelcome(player)
	end
	
	if test_mode then
		player.print({"test-mode-enabled"})
	end
	
	-- First player creates central hub
	if not global.central_hub_created then
		global.central_hub_created = true
		global.central_hub_top_left = {x = player.position.x - 9, y = player.position.y - 20}
		createCentralHub(global.central_hub_top_left, player.surface)
	end
	
	global.player_prefs[player.index] = {gui_open = true}
	updateGUI(player, true)

	-- Quick start (see config.lua) gives players supplies and tech to start game quickly
	if quick_start then
		-- technologies
		player.force.technologies["military"].researched = true
		player.force.technologies["turrets"].researched = true
		player.force.technologies["automation"].researched = true
		player.force.technologies["automation-2"].researched = true
		player.force.technologies["logistics"].researched = true
		player.force.technologies["logistics-2"].researched = true
		player.force.technologies["electronics"].researched = true
		player.force.technologies["advanced-electronics"].researched = true
		player.force.technologies["steel-processing"].researched = true
		player.force.technologies["engine"].researched = true
		player.force.technologies["railway"].researched = true
		player.force.technologies["automated-rail-transportation"].researched = true
		player.force.technologies["rail-signals"].researched = true
		player.force.technologies["automobilism"].researched = true
		player.force.technologies["optics"].researched = true
		player.force.technologies["solar-energy"].researched = true
		player.force.technologies["electric-energy-distribution-1"].researched = true
		player.force.technologies["electric-energy-accumulators-1"].researched = true
		player.force.technologies["advanced-material-processing"].researched = true
		player.force.technologies["advanced-material-processing-2"].researched = true
		player.force.technologies["oil-processing"].researched = true
		player.force.technologies["sulfur-processing"].researched = true
		player.force.technologies["plastics"].researched = true
		player.force.technologies["toolbelt"].researched = true
		player.force.technologies["battery"].researched = true
		player.force.technologies["landfill"].researched = true
		player.force.technologies["stack-inserter"].researched = true
		player.force.technologies["inserter-capacity-bonus-1"].researched = true
		player.force.technologies["inserter-capacity-bonus-2"].researched = true
		player.force.technologies["inserter-capacity-bonus-3"].researched = true
		
		-- items
		player.insert{name = "steel-axe", count = 5}
		player.insert{name = "iron-plate", count = 50}
		player.insert{name = "copper-plate", count = 50}
		player.insert{name = "steel-axe", count = 5}
		player.insert{name = "exploration-vehicle", count = 1}
		player.insert{name = "electric-mining-drill", count = 20}
		player.insert{name = "electric-furnace", count = 20}
		player.insert{name = "fast-inserter", count = 50}
		player.insert{name = "fast-transport-belt", count = 100}
		player.insert{name = "steel-chest", count = 10}
		player.insert{name = "assembling-machine-2", count = 10}
		player.insert{name = "medium-electric-pole", count = 100}
		player.insert{name = "big-electric-pole", count = 50}
		player.insert{name = "solar-panel", count = 30}
		player.insert{name = "accumulator", count = 30}
		player.insert{name = "rail", count = 500}
		player.insert{name = "train-stop", count = 20}
		player.insert{name = "diesel-locomotive", count = 5}
		player.insert{name = "cargo-wagon", count = 10}
		player.insert{name = "coal", count = 50}
		
	-- If not quick start and not freeplay, add the freeplay supplies
	elseif not (remote.interfaces["Outposts"] == nil) then
		player.insert{name="iron-plate", count=8}
		player.insert{name="burner-mining-drill", count = 1}
		player.insert{name="stone-furnace", count = 1}
	end
end
script.on_event(defines.events.on_player_created, newPlayer)

---------------------------------------------------------
-- Create the central hub, where the player deposits materials
-- Given a top-left location
function createCentralHub(top_left, surface)
	local x = top_left.x
	local y = top_left.y
	local bottom_right = {x = x + 17, y = y + 19}
	
	-- Clear the area of entities
	local ents = surface.find_entities({{top_left.x - 1, top_left.y - 1}, {bottom_right.x + 1, bottom_right.y + 1}})
	for __, ent in pairs(ents) do
		if not (ent.name == "player") then
			ent.destroy()
		end
	end
	
	-- Concrete floor with hazard edges
	local concrete_tiles = {}
	-- North/south edges
	for i = 0, 16 do
		table.insert(concrete_tiles, {name = "hazard-concrete-left", position = {x + i, y}})
		table.insert(concrete_tiles, {name = "hazard-concrete-left", position = {x + i, y + 18}})
	end
	-- East/west edges
	for i = 0, 18 do
		table.insert(concrete_tiles, {name = "hazard-concrete-left", position = {x, y + i}})
		table.insert(concrete_tiles, {name = "hazard-concrete-left", position = {x + 16, y + i}})
	end
	-- Central concrete
	for i = 1, 15 do
		for j = 1, 17 do
			table.insert(concrete_tiles, {name = "concrete", position = {x + i, y + j}})
		end
	end
	
	surface.set_tiles(concrete_tiles)
	
	-- List of entities for setting entity attributes
	local structures =
		{
			{name = "outpost-rocket-silo", offset = {8, 9.5}},
			{name = "solar-panel", offset = {3, 3}},
			{name = "solar-panel", offset = {8, 3}},
			{name = "solar-panel", offset = {13, 3}},
			{name = "accumulator", offset = {5.5, 2.5}},
			{name = "accumulator", offset = {10.5, 2.5}},
			{name = "medium-electric-pole", offset = {6, 4}},
			{name = "medium-electric-pole", offset = {10, 4}},
			{name = "medium-electric-pole", offset = {3, 9}},
			{name = "medium-electric-pole", offset = {13, 9}},
			{name = "medium-electric-pole", offset = {5, 15}},
			{name = "medium-electric-pole", offset = {11, 15}},
			{name = "small-lamp", offset = {5, 4}},
			{name = "small-lamp", offset = {11, 4}},
			{name = "small-lamp", offset = {3, 10}},
			{name = "small-lamp", offset = {13, 10}},
			{name = "small-lamp", offset = {4, 15}},
			{name = "small-lamp", offset = {12, 15}},
			{name = "depository-outpost", offset = {2, 6}},
			{name = "depository-outpost", offset = {2, 13}},
			{name = "depository-outpost", offset = {14, 6}},
			{name = "depository-outpost", offset = {14, 13}},
			{name = "depository-outpost", offset = {8, 16}},
		}
	
	-- Create the indestructible base
	local ent
	global.depositories = {}
	for __, entity_data in pairs(structures) do
		ent = surface.create_entity{name = entity_data.name, force = game.forces.neutral, position = {x + entity_data.offset[1], y + entity_data.offset[2]}}
		ent.minable = false
		ent.destructible = false
		
		-- Keep track of the rocket silo and depositories for later use
		if ent.name == "outpost-rocket-silo" then
			global.silo = ent
			ent.operable = false
		elseif ent.name == "depository-outpost" then
			table.insert(global.depository_outposts, ent)
		end
	end
	
	-- Create walls
	local walls = {}
	-- North/south walls
	for i = 1, 15 do
		table.insert(walls, {name = "stone-wall", offset = {i, 1}})
		table.insert(walls, {name = "stone-wall", offset = {i, 17}})
	end
	-- East/west walls
	for i = 1, 17 do
		table.insert(walls, {name = "stone-wall", offset = {1, i}})
		table.insert(walls, {name = "stone-wall", offset = {15, i}})
	end
	
	for __, entity_data in pairs(walls) do
		if surface.can_place_entity{name = entity_data.name, position = {x + entity_data.offset[1], y + entity_data.offset[2]}} then
			ent = surface.create_entity{name = entity_data.name, force = game.forces.neutral, position = {x + entity_data.offset[1], y + entity_data.offset[2]}}
			ent.minable = false
			ent.destructible = false
		end
	end
end

---------------------------------------------------------
-- Process all ongoing events
function onTick()
	-- Decrement the delay for the rocket initially coming out of the silo
	-- If the delay hits zero, allow launching
	if global.launch_preparation_delay > 0 then
		global.launch_preparation_delay = global.launch_preparation_delay - 1
		
		if global.launch_preparation_delay == 0 then
			global.launch_available = true
			updateAllGUIs(true, true)
			pall({"rocket-available"})
		end
	end
	
	-- Decrement the cooldown between rockets
	-- When the cooldown depletes, start the next tier of rocket
	if global.rocket_cooldown > 0 then
		global.rocket_cooldown = global.rocket_cooldown - 1
		
		if global.rocket_cooldown == 0 then
			updateRocketTier()
			updateAllGUIs(true, true)
		end
	end
	
	processExplorationVehicles()
	processMiningOutposts()
	--processAssemblingOutposts()
	processDepositoryOutposts()
	processGUI()
end

---------------------------------------------------------
-- Initialize various objects
function onInit()
	global.mining_outposts = global.mining_outposts or {}
	global.assembling_outposts = global.assembling_outposts or {}
	global.depository_outposts = global.depository_outposts or {}
	global.rocket_progress = global.rocket_progress or
		{
			tier = "Tier 1",
			promethian = 0,
			novitian = 0,
			alien = 0,
			fuel = 0,
			other_amount = 0,
		}
	global.launch_available = global.launch_available or false
	global.launch_preparation_delay = global.launch_preparation_delay or 0
	global.rocket_cooldown = global.rocket_cooldown or 0
	global.rocket_count = global.rocket_count or 0
	global.player_prefs = global.player_prefs or {}
	script.on_event(defines.events.on_tick, onTick)
end
script.on_init(onInit)

---------------------------------------------------------
-- On reload, make sure that processing continues
function onLoad()
	script.on_event(defines.events.on_tick, onTick)
end
script.on_load(onLoad)

---------------------------------------------------------
-- Create new outposts when the map is explored
-- First, check if a new outpost should be spawned
-- Then, randomly select its type from weighted outpost list
function chunkGenerated(event)
	local chunk = event.area
	local surface = event.surface
	if math.random() < outpost_density then
		createOutpost(getRandomOutpostName(), chunk, surface)
	end
end
script.on_event(defines.events.on_chunk_generated, chunkGenerated)

---------------------------------------------------------
-- Returns random name of outpost
function getRandomOutpostName()
	-- The weighted list contains as many entries for each outpost as its weight
	if not weighted_outpost_list then
		weighted_outpost_list = {}
		for name, outpost_data in pairs(outpost_dict) do
			for i = 1, outpost_data.weight do
				table.insert(weighted_outpost_list, name)
			end
		end
	end
	
	return weighted_outpost_list[math.random(1, #weighted_outpost_list)]
end

---------------------------------------------------------
-- Attempt to create a new outpost at a random position in a given chunk
-- This may not succeed, and no outpost will be spawned
function createOutpost(outpost_name, chunk, surface)
	-- try to find a random position to place the outpost
	local random_position = {x = math.random(chunk.left_top.x, chunk.right_bottom.x), y = math.random(chunk.left_top.y, chunk.right_bottom.y)}
	-- if the random position is invalid, search a larger area
	if not surface.can_place_entity{name = outpost_name, position = random_position} then
		random_position = surface.find_non_colliding_position(outpost_name, random_position, 10, 1)
	end
	if not random_position then return end
	-- if the outpost is too close to the central hub, do not create
	if global.central_hub_created and distanceBetween(random_position, global.central_hub_top_left) < 50 then return end
	
	-- create the outpost if random position is valid
	if surface.can_place_entity{name = outpost_name, position = random_position} then
		local outpost = surface.create_entity{name = outpost_name, force = game.forces.player, position = random_position}
		surface.create_entity{name = "large-scorchmark", force = game.forces.neutral, position = {random_position.x + 0.5, random_position.y + 1.0}}
		--outpost.minable = false
		outpost.destructible = false
		
		local outpost_data = outpost_dict[outpost.name]
		if outpost_data.type == "mining" then
			table.insert(global.mining_outposts, outpost)
		elseif outpost_data.type == "assembling" then
			-- set the recipe for assembling outposts and give it energy
			outpost.recipe = game.forces.neutral.recipes[outpost_data.recipe]
			--outpost.energy = 10000
			table.insert(global.assembling_outposts, outpost)
		end
	end
end

---------------------------------------------------------
-- Exploration vehicles destroy impeding trees and rocks
function processExplorationVehicles()
	if (game.tick % (UPS * exploration_vehicle_period) == 0) then
		for __, player in pairs(game.players) do
			local vehicle = player.vehicle
			if player.connected and vehicle and vehicle.name == "exploration-vehicle" then
				local radius = 5
				local search_area = {{player.position.x - radius, player.position.y - radius}, {player.position.x + radius, player.position.y + radius}}
				local ents = player.surface.find_entities(search_area)
				for __, ent in pairs(ents) do
					if ent.type == "tree" or ent.name == "stone-rock" then
						ent.die()
					end
				end
			end
		end
	end
end

---------------------------------------------------------
-- Simulate mining in mining outposts
function processMiningOutposts()
	if (game.tick % (UPS * mining_outpost_period) == 0) then
		for index, outpost in pairs(global.mining_outposts) do
			if outpost and outpost.valid then
				local outpost_data = outpost_dict[outpost.name]
				local inventory = outpost.get_inventory(defines.inventory.item_main)
				inventory.insert({name = outpost_data.resource, count = 1})
			else
				table.remove(global.mining_outposts, index)
			end
		end
	end
end

---------------------------------------------------------
-- Process assembling outposts
function processAssemblingOutposts()
	if (game.tick % (UPS * assembling_outpost_period) == 0) then
		for index, outpost in pairs(global.assembling_outposts) do
			if outpost and outpost.valid then
				-- do something with assembling outposts
			else
				table.remove(global.assembling_outposts, index)
			end
		end
	end
end

---------------------------------------------------------
-- Process depository outposts
-- Add the count of appropriate items in the depositories to rocket prgress, then clear the inventories
function processDepositoryOutposts()
	if (game.tick % (UPS * depository_outpost_period) == 0) then
		for index, outpost in pairs(global.depository_outposts) do
			if outpost and outpost.valid then
				local inventory = outpost.get_inventory(defines.inventory.item_main)
				if not inventory.is_empty() then
					local contents = inventory.get_contents()
					if contents["electrolyzed-promethian-dust"] then
						global.rocket_progress.promethian = global.rocket_progress.promethian + contents["electrolyzed-promethian-dust"]
					end
					if contents["electrolyzed-novitian-dust"] then
						global.rocket_progress.novitian = global.rocket_progress.novitian + contents["electrolyzed-novitian-dust"]
					end
					if contents["reactive-alien-alloy"] then
						global.rocket_progress.alien = global.rocket_progress.alien + contents["reactive-alien-alloy"]
					end
					if contents["modified-rocket-fuel"] then
						global.rocket_progress.fuel = global.rocket_progress.fuel + contents["modified-rocket-fuel"]
					end
					
					if marathon_mode then
						local other_material = rocket_requirements[global.rocket_progress.tier].other_material
						if contents[other_material] then
							global.rocket_progress.other_amount = global.rocket_progress.other_amount + contents[other_material]
						end
					end
					
					inventory.clear()
				end
				
				if rocketRequirementsMet() and global.launch_preparation_delay == 0 and (not global.preparing_to_launch) and global.rocket_cooldown == 0 then
					global.silo.rocket_parts = 100
					global.launch_preparation_delay = 17 * UPS -- 17 second delay to allow rocket to exit silo (animation)
					global.preparing_to_launch = true
					pall({"launch-ready"})
				end
			else
				table.remove(global.depository_outposts, index)
			end
		end
	end
end

---------------------------------------------------------
-- Check if enough materials have been gathered to launch the rocket.
function rocketRequirementsMet()
	local met = false
	local rocket_requirement = rocket_requirements[global.rocket_progress.tier]
	
	met = (global.rocket_progress.promethian >= rocket_requirement.promethian) and
		(global.rocket_progress.novitian >= rocket_requirement.novitian) and 
		(global.rocket_progress.alien >= rocket_requirement.alien) and 
		(global.rocket_progress.fuel >= rocket_requirement.fuel)
	if marathon_mode then
		met = met and (global.rocket_progress.other_amount >= rocket_requirement.other_amount)
	end
	
	return test_mode or met
end

---------------------------------------------------------
-- Periodically update the GUI
function processGUI()
	if (game.tick % (UPS * gui_period) == 0) then
		updateAllGUIs(false)
	end
end

---------------------------------------------------------
-- Update all GUIs
function updateAllGUIs(reset_gui)
	updateAllGUIs(reset_gui, false)
end

---------------------------------------------------------
-- Update all GUIs
function updateAllGUIs(reset_gui, force_open)
	for __, player in pairs(game.players) do
		if player.connected then
			if force_open then
				global.player_prefs[player.index].gui_open = true
			end
			updateGUI(player, reset_gui)
		end
	end
end

---------------------------------------------------------
-- Update a single player's GUI
function updateGUI(player, reset_gui)
	
	-- Grab the GUI frame
	local gui_frame
	if not player.gui.top["outpost-frame"] then
		gui_frame = player.gui.top.add({name = "outpost-frame", type = "frame", direction = "vertical"})
	else
		gui_frame = player.gui.top["outpost-frame"]
	end
	
	-- Clean the frame if requested
	if reset_gui then
		cleanFrame(gui_frame)
	end
	
	-- If the GUI is closed, only build the top button
	if not global.player_prefs[player.index].gui_open then
		if reset_gui then
			gui_frame.style = "thin_frame_style"
			gui_frame.add({name = "outpost-button", type = "sprite-button", sprite = "sprite-outpost", style = "large_outpost_sprite_style"})
		end
	-- If the GUI is open, build all components
	else
		gui_frame.style = "frame_style"
		local rocket_requirement = rocket_requirements[global.rocket_progress.tier]
		
		if reset_gui then
			
			local title_flow = gui_frame.add({name = "title_flow", type = "flow", direction = "horizontal"})
			title_flow.add({name = "minimize-button", type = "button", caption = {"minimize-button"}, style = "minimize_button_style"})
			if not (global.rocket_progress.tier == "Repeatable") then
				title_flow.add({name = "progress-title", type = "label", caption = {"progress-title", global.rocket_progress.tier}})
			else
				title_flow.add({name = "repeatable-progress-title", type = "label", caption = {"repeatable-progress-title", global.rocket_count}})
			end
				
			
			-- add promethian section, if applicable
			if rocket_requirement.promethian > 0 then
				local promethian_flow = gui_frame.add({name = "promethian-flow", type = "flow", direction = "horizontal"})
				promethian_flow.add({type = "sprite-button", name = "promethian-button", sprite = "sprite-promethian", style = "outpost_sprite_style"})
				local promethian_bar_flow = promethian_flow.add({name = "promethian-bar-flow", type = "flow", direction = "vertical", style = "thin_flow_style"})
				promethian_bar_flow.add({name = "promethian-bar", type = "progressbar", size = 40, style = "promethian_progressbar_style", value = 0})
				promethian_bar_flow.add({name = "promethian-label", type = "label", caption = {"promethian-label"}, style = "small_label_style"})
				promethian_bar_flow.add({name = "promethian-info", type = "label", caption = {"progress-info", 0, 0}, style = "small_label_style"})
			end
			
			-- add novitian section, if applicable
			if rocket_requirement.novitian > 0 then
				local novitian_flow = gui_frame.add({name = "novitian-flow", type = "flow", direction = "horizontal"})
				novitian_flow.add({type = "sprite-button", name = "novitian-button", sprite = "sprite-novitian", style = "outpost_sprite_style"})
				local novitian_bar_flow = novitian_flow.add({name = "novitian-bar-flow", type = "flow", direction = "vertical", style = "thin_flow_style"})
				novitian_bar_flow.add({name = "novitian-bar", type = "progressbar", size = 40, style = "novitian_progressbar_style", value = 0})
				novitian_bar_flow.add({name = "novitian-label", type = "label", caption = {"novitian-label"}, style = "small_label_style"})
				novitian_bar_flow.add({name = "novitian-info", type = "label", caption = {"progress-info", 0, 0}, style = "small_label_style"})
			end
			
			-- add alien section, if applicable
			if rocket_requirement.alien > 0 then
				local alien_flow = gui_frame.add({name = "alien-flow", type = "flow", direction = "horizontal"})
				alien_flow.add({type = "sprite-button", name = "alien-button", sprite = "sprite-alien", style = "outpost_sprite_style"})
				local alien_bar_flow = alien_flow.add({name = "alien-bar-flow", type = "flow", direction = "vertical", style = "thin_flow_style"})
				alien_bar_flow.add({name = "alien-bar", type = "progressbar", size = 40, style = "alien_progressbar_style", value = 0})
				alien_bar_flow.add({name = "alien-label", type = "label", caption = {"alien-label"}, style = "small_label_style"})
				alien_bar_flow.add({name = "alien-info", type = "label", caption = {"progress-info", 0, 0}, style = "small_label_style"})
			end
			
			-- add fuel section, if applicable
			if rocket_requirement.fuel > 0 then
				local fuel_flow = gui_frame.add({name = "fuel-flow", type = "flow", direction = "horizontal"})
				fuel_flow.add({type = "sprite-button", name = "fuel-button", sprite = "sprite-fuel", style = "outpost_sprite_style"})
				local fuel_bar_flow = fuel_flow.add({name = "fuel-bar-flow", type = "flow", direction = "vertical", style = "thin_flow_style"})
				fuel_bar_flow.add({name = "fuel-bar", type = "progressbar", size = 40, style = "fuel_progressbar_style", value = 0})
				fuel_bar_flow.add({name = "fuel-label", type = "label", caption = {"fuel-label"}, style = "small_label_style"})
				fuel_bar_flow.add({name = "fuel-info", type = "label", caption = {"progress-info", 0, 0}, style = "small_label_style"})
			end
			
			-- add other material section, if applicable (marathon mode)
			if marathon_mode and rocket_requirement.other_amount > 0 then
				local other_flow = gui_frame.add({name = "other-flow", type = "flow", direction = "horizontal"})
				other_flow.add({type = "sprite-button", name = "other-button", sprite = "sprite-other", style = "outpost_sprite_style"})
				local other_bar_flow = other_flow.add({name = "other-bar-flow", type = "flow", direction = "vertical", style = "thin_flow_style"})
				other_bar_flow.add({name = "other-bar", type = "progressbar", size = 40, style = "other_progressbar_style", value = 0})
				other_bar_flow.add({name = "other-label", type = "label", caption = {"other-label"}, style = "small_label_style"})
				other_bar_flow.add({name = "other-info", type = "label", caption = {"progress-info", 0, 0}, style = "small_label_style"})
				
				local other_material = rocket_requirement.other_material
				if other_material == "electronic-circuit" then
					other_flow["other-button"].sprite = "sprite-circuit"
					other_bar_flow["other-label"].caption = {"circuit-label"}
				elseif other_material == "advanced-circuit" then
					other_flow["other-button"].sprite = "sprite-advanced"
					other_bar_flow["other-label"].caption = {"advanced-label"}
				elseif other_material == "processing-unit" then
					other_flow["other-button"].sprite = "sprite-processing"
					other_bar_flow["other-label"].caption = {"processing-label"}
				elseif other_material == "satellite" then
					other_flow["other-button"].sprite = "sprite-satellite"
					other_bar_flow["other-label"].caption = {"satellite-label"}
				end
			end
			
			-- add the launch button if available
			if global.launch_available then
				local launch_flow = gui_frame.add({name = "launch-flow", type = "flow", direction = "horizontal"})
				launch_flow.add({name = "launch-button", type = "button", caption = {"launch-button"}, style = "launch_button_style"})
			end
		end
		
		-- Update progress bar and label values
		if rocket_requirement.promethian > 0 then
			gui_frame["promethian-flow"]["promethian-bar-flow"]["promethian-bar"].value = global.rocket_progress.promethian / rocket_requirement.promethian
			gui_frame["promethian-flow"]["promethian-bar-flow"]["promethian-info"].caption = {"progress-info", global.rocket_progress.promethian, rocket_requirement.promethian}
		end
		
		if rocket_requirement.novitian > 0 then
			gui_frame["novitian-flow"]["novitian-bar-flow"]["novitian-bar"].value = global.rocket_progress.novitian / rocket_requirement.novitian
			gui_frame["novitian-flow"]["novitian-bar-flow"]["novitian-info"].caption = {"progress-info", global.rocket_progress.novitian, rocket_requirement.novitian}
		end
		
		if rocket_requirement.alien > 0 then
			gui_frame["alien-flow"]["alien-bar-flow"]["alien-bar"].value = global.rocket_progress.alien / rocket_requirement.alien
			gui_frame["alien-flow"]["alien-bar-flow"]["alien-info"].caption = {"progress-info", global.rocket_progress.alien, rocket_requirement.alien}
		end
		
		if rocket_requirement.fuel > 0 then
			gui_frame["fuel-flow"]["fuel-bar-flow"]["fuel-bar"].value = global.rocket_progress.fuel / rocket_requirement.fuel
			gui_frame["fuel-flow"]["fuel-bar-flow"]["fuel-info"].caption = {"progress-info", global.rocket_progress.fuel, rocket_requirement.fuel}
		end
		
		if marathon_mode and rocket_requirement.other_amount > 0 then
			gui_frame["other-flow"]["other-bar-flow"]["other-bar"].value = global.rocket_progress.other_amount / rocket_requirement.other_amount
			gui_frame["other-flow"]["other-bar-flow"]["other-info"].caption = {"progress-info", global.rocket_progress.other_amount, rocket_requirement.other_amount}
		end
	end
end

---------------------------------------------------------
-- Handle gui events
local function onGUIClick(event)
	local player = game.players[event.player_index]
	local event_name = event.element.name
	
	if event_name == "freeplay-warning-button" then
		displayWelcome(player)
	elseif event_name == "outpost-button" then
		global.player_prefs[player.index].gui_open = true
		updateGUI(player, true)
	elseif event_name == "minimize-button" then
		global.player_prefs[player.index].gui_open = false
		updateGUI(player, true)
	elseif event_name == "launch-button" then
		if global.launch_available then
			global.rocket_cooldown = 27 * UPS -- 27 second cooldown between launches (due to silo animation)
			global.launch_available = false
			pall({"rocket-launched"})
			updateAllGUIs(true)
			--global.silo.get_inventory(defines.inventory.rocket_silo_rocket).insert({name = "satellite", count = 1})
			global.silo.launch_rocket()
			global.preparing_to_launch = false
		else
			player.print("The rocket is not yet ready to launch.")
		end
	elseif event_name == "close-transmission-button" then
		local transmission_frame = player.gui.center["transmission-frame"]
		if transmission_frame then
			transmission_frame.destroy()
			
			if (not (game.finished)) and (global.rocket_progress.tier == "Tier 4" or global.rocket_progress.tier == "Repeatable") then
				game.set_game_state{game_finished = true, player_won = true, can_continue = true}
			end
		end
	elseif event_name == "promethian-button" then
		player.print({"promethian-button-description"})
	elseif event_name == "novitian-button" then
		player.print({"novitian-button-description"})
	elseif event_name == "alien-button" then
		player.print({"alien-button-description"})
	elseif event_name == "fuel-button" then
		player.print({"fuel-button-description"})
	end
end
script.on_event(defines.events.on_gui_click, onGUIClick)

---------------------------------------------------------
-- On rocket launch, display a message to players
-- The rocket is identified by being launched from the neutral force
-- Other mods may rarely conflict with this
local function onRocketLaunch(event)
	if event.rocket.force == game.forces.neutral then
		local strings = {}
		if global.rocket_progress.tier == "Tier 1" then
			strings = {{"congratulations-tier-1a"}, {"congratulations-tier-1b"}, {"congratulations-tier-1c"}, {"next-order"}}
		elseif global.rocket_progress.tier == "Tier 2" then
			strings = {{"congratulations-tier-2a"}, {"congratulations-tier-2b"}, {"congratulations-tier-2c"}, {"next-order"}}
		elseif global.rocket_progress.tier == "Tier 3" then
			strings = {{"congratulations-tier-3a"}, {"congratulations-tier-3b"}, {"congratulations-tier-3c"}, {"next-order"}}
		elseif global.rocket_progress.tier == "Tier 4" then
			strings = {{"congratulations-tier-4a"}, {"congratulations-tier-4b"}, {"congratulations-tier-4c"}, {"congratulations-tier-4d"}, {"congratulations-tier-4e"}}
		elseif global.rocket_progress.tier == "Repeatable" then
			strings = {{"congratulations-tier-ra"}, {"congratulations-tier-rb"}, {"congratulations-tier-rc"}}
			global.rocket_count = global.rocket_count + 1
		else
			return
		end
		broadcastTransmission(strings)
	end
end
script.on_event(defines.events.on_rocket_launched, onRocketLaunch)

---------------------------------------------------------
-- Increments rocket progress tier by one
-- Gives game end message if final tier reached
function updateRocketTier()
	local current_tier = global.rocket_progress.tier
	local next_tier
	if current_tier == "Tier 1" then
		next_tier = "Tier 2"
	elseif current_tier == "Tier 2" then
		next_tier = "Tier 3"
	elseif current_tier == "Tier 3" then
		next_tier = "Tier 4"
	elseif current_tier == "Tier 4" or current_tier == "Repeatable" then
		next_tier = "Repeatable"
	end
	
	local current_requirements = rocket_requirements[current_tier]
	global.rocket_progress.promethian = math.max(0, global.rocket_progress.promethian - current_requirements.promethian)
	global.rocket_progress.novitian = math.max(0, global.rocket_progress.novitian - current_requirements.novitian)
	global.rocket_progress.alien = math.max(0, global.rocket_progress.alien - current_requirements.alien)
	global.rocket_progress.fuel = math.max(0, global.rocket_progress.fuel - current_requirements.fuel)
	if marathon_mode then
		global.rocket_progress.other_amount = 0
	end
	global.rocket_progress.tier = next_tier
end

---------------------------------------------------------
-- Utility function to broadcast a pop-up to all players
function broadcastTransmission(strings)
	if game and game.players then
		for __, player in pairs(game.players) do
			transmission(strings, player)
		end
	end
end

---------------------------------------------------------
-- Utility function to send a pop-up to a player
function transmission(strings, player)
	local transmission_frame = player.gui.center["transmission-frame"]
	if transmission_frame then
		cleanFrame(transmission_frame)
	else
		transmission_frame = player.gui.center.add({name = "transmission-frame", type = "frame", direction = "vertical"})
	end
	
	transmission_frame.add({name = "transmission-title", type = "label", caption = {"transmission-title"}, style = "bold_label_style"})
	transmission_flow = transmission_frame.add({name = "transmission-flow", type = "flow", direction = "vertical", style = "thin_flow_style"})
	for i, str in pairs(strings) do
		transmission_flow.add({name = "transmission-label-" .. i, type = "label", caption = str})
	end
	transmission_frame.add({name = "close-transmission-button", type = "button", caption = {"close-transmission"}})
end

---------------------------------------------------------
-- Utility function to destroy all elements within a frame
function cleanFrame(frame)
	if not frame then return end
	for __, child_name in pairs(frame.children_names) do
		frame[child_name].destroy()
	end
end

---------------------------------------------------------
-- Utility function to print to all players
function pall(str)
	if game and game.players then
		for __, player in pairs(game.players) do
			player.print(str)
		end
	end
end

---------------------------------------------------------
-- Utility function for regular L_2 norm distance
function distanceBetween(pos1, pos2)
	return math.sqrt(math.pow((pos1.x - pos2.x), 2) + math.pow((pos1.y - pos2.y), 2))
end