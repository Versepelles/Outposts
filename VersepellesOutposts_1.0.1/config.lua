---------------------------------------------------------
-- Change these values to your liking.
marathon_mode = false		-- Marathon mode requires more resources and player-created inputs.
quick_start = true			-- Quick start gives the player a variety of useful items and technologies.
outpost_density = 0.15		-- The density of outpost structures in the world [0.0 - 1.0].
test_mode = false			-- Development tool

---------------------------------------------------------
-- The relative frequency of different types of outposts
-- Increase a weight to have more of that type of outpost appear
outpost_dict = {
	["promethian-mining-outpost"] = {weight = 4, type = "mining", resource = "promethian-ore"},
	["novitian-mining-outpost"] = {weight = 4, type = "mining", resource = "novitian-ore"},
	["promethian-plate-outpost"] = {weight = 2, type = "assembling", recipe = "promethian-plate"},
	["novitian-plate-outpost"] = {weight = 2, type = "assembling", recipe = "novitian-plate"},
	["electrolyzed-promethian-dust-outpost"] = {weight = 2, type = "assembling", recipe = "electrolyzed-promethian-dust"},
	["electrolyzed-novitian-dust-outpost"] = {weight = 2, type = "assembling", recipe = "electrolyzed-novitian-dust"},
	["extracted-biogas-outpost"] = {weight = 4, type = "mining", resource = "extracted-biogas"},
	["modified-rocket-fuel-outpost"] = {weight = 2, type = "assembling", recipe = "modified-rocket-fuel"},
	["artifact-fragment-outpost"] = {weight = 2, type = "mining", resource = "artifact-fragment"},
	["novitian-alloy-outpost"] = {weight = 2, type = "assembling", recipe = "novitian-alloy"},
	["reactive-alien-alloy-outpost"] = {weight = 2, type = "assembling", recipe = "reactive-alien-alloy"},
}

---------------------------------------------------------
-- Rocket requirements by tier
if not marathon_mode then
	rocket_requirements =
		{
			["Tier 1"] = {promethian = 100, novitian = 0, alien = 0, fuel = 100},
			["Tier 2"] = {promethian = 1000, novitian = 250, alien = 0, fuel = 1000},
			["Tier 3"] = {promethian = 3000, novitian = 1500, alien = 100, fuel = 4000},
			["Tier 4"] = {promethian = 7500, novitian = 5000, alien = 1500, fuel = 10000},
			["Repeatable"] = {promethian = 10000, novitian = 10000, alien = 10000, fuel = 10000},
		}
else
	rocket_requirements =
		{
			["Tier 1"] = {promethian = 1000, novitian = 0, alien = 0, fuel = 1000, other_material = "electronic-circuit", other_amount = 1000},
			["Tier 2"] = {promethian = 5000, novitian = 2000, alien = 0, fuel = 5000, other_material = "advanced-circuit", other_amount = 1000},
			["Tier 3"] = {promethian = 20000, novitian = 10000, alien = 1000, fuel = 10000, other_material = "processing-unit", other_amount = 1000},
			["Tier 4"] = {promethian = 50000, novitian = 25000, alien = 2500, fuel = 50000, other_material = "satellite", other_amount = 10},
			["Repeatable"] = {promethian = 100000, novitian = 100000, alien = 50000, fuel = 100000, other_material = "satellite", other_amount = 10},
		}
end