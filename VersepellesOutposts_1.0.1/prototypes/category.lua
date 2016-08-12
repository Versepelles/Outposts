data:extend(
{
  -- Recipe Categories
  {
    type = "recipe-category",
    name = "promethian-plate-outpost"
  },
  {
    type = "recipe-category",
    name = "novitian-plate-outpost"
  },
  {
    type = "recipe-category",
    name = "electrolyzed-promethian-dust-outpost"
  },
  {
    type = "recipe-category",
    name = "electrolyzed-novitian-dust-outpost"
  },
  {
    type = "recipe-category",
    name = "modified-rocket-fuel-outpost"
  },
  {
    type = "recipe-category",
    name = "novitian-alloy-outpost"
  },
  {
    type = "recipe-category",
    name = "reactive-alien-alloy-outpost"
  },
  
  -- Item Categories
  {
    type = "item-group",
    name = "outpost",
    order = "e[outpost]",
	inventory_order = "z",
	icon = "__VersepellesOutposts__/graphics/icons/outpost-group.png",
  },
  {
    type = "item-subgroup",
    name = "promethian",
    group = "outpost",
    order = "a",
  },
  {
    type = "item-subgroup",
    name = "novitian",
    group = "outpost",
    order = "b",
  },
  {
    type = "item-subgroup",
    name = "extracted-biogas",
    group = "outpost",
    order = "c",
  },
  {
    type = "item-subgroup",
    name = "artifact-fragment",
    group = "outpost",
    order = "d",
  },
  {
    type = "item-subgroup",
    name = "exploration-vehicle",
    group = "outpost",
    order = "e",
  },
})