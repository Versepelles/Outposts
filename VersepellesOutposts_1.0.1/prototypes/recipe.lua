data:extend(
{
  ---------------------------------------------------------
  -- Processed Goods
  
  {
    type = "recipe",
    name = "promethian-plate",
	enabled = "true",
	category = "promethian-plate-outpost",
	ingredients = 
    {
		{"promethian-ore", 2},
	},
	result = "promethian-plate",
	result_count = 1,
  },
  {
    type = "recipe",
    name = "novitian-plate",
	enabled = "true",
	category = "novitian-plate-outpost",
	ingredients = 
    {
		{"novitian-ore", 2},
	},
	result = "novitian-plate",
	result_count = 1,
  },
  {
    type = "recipe",
    name = "electrolyzed-promethian-dust",
	enabled = "true",
	category = "electrolyzed-promethian-dust-outpost",
	ingredients = 
    {
		{"promethian-plate", 1},
		{"extracted-biogas", 1},
	},
	result = "electrolyzed-promethian-dust",
	result_count = 1,
  },
  {
    type = "recipe",
    name = "electrolyzed-novitian-dust",
	enabled = "true",
	category = "electrolyzed-novitian-dust-outpost",
	ingredients = 
    {
		{"novitian-plate", 1},
		{"extracted-biogas", 1},
	},
	result = "electrolyzed-novitian-dust",
	result_count = 1,
  },
  {
    type = "recipe",
    name = "modified-rocket-fuel",
	enabled = "true",
	category = "modified-rocket-fuel-outpost",
	ingredients = 
    {
		{"coal", 1},
		{"extracted-biogas", 1},
	},
	result = "modified-rocket-fuel",
	result_count = 1,
  },
  {
    type = "recipe",
    name = "novitian-alloy",
	enabled = "true",
	category = "novitian-alloy-outpost",
	ingredients = 
    {
		{"novitian-plate", 1},
		{"steel-plate", 1},
	},
	result = "novitian-alloy",
	result_count = 1,
  },
  {
    type = "recipe",
    name = "reactive-alien-alloy",
	enabled = "true",
	category = "reactive-alien-alloy-outpost",
	ingredients = 
    {
		{"novitian-alloy", 1},
		{"artifact-fragment", 1},
	},
	result = "reactive-alien-alloy",
	result_count = 1,
  },
  
})