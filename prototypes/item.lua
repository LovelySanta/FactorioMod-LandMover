
-- shovel items
local shovel_mk1 =
{
  type = "item",
  name = "landmover-shovel",
  icon = "__LandMover__/graphics/shovel.png",
  icon_size = 32,
  --flags = {},
  subgroup = "intermediate-product",
  order = "a[mining]-c[shovel]-a",
  stack_size = 20
}

local shovel_mk2 =
{
  type = "item",
  name = shovel_mk1.name .. "-mk2",
  localised_name = {"upgrades.mk2", "__ITEM__" .. shovel_mk1.name .. "__"},
  localised_description = {"item-description." .. shovel_mk1.name},
  icon = "__LandMover__/graphics/shovel_mk2.png",
  icon_size = 32,
  --flags = {},
  subgroup = shovel_mk1.subgroup,
  order = "a[mining]-c[shovel]-b",
  stack_size = shovel_mk1.stack_size
}



-- landmover items
local landmover_mk1 =
{
  type = "item",
  name = "landmover",
  icon = "__LandMover__/graphics/landmover.png",
  icon_size = 64,
  --flags = {},
  subgroup = "terrain",
  order = "c[landfill]-a[dirt]-a",
  stack_size = 100,
  place_as_tile =
  {
    result = "water",
    condition_size = 1,
    condition = { "water-tile" }
  }
}

local landmover_mk2 =
{
  type = "tool",
  name = "landmover-mk2",
  localised_name = {"upgrades.mk2", "__ITEM__" .. landmover_mk1.name .. "__"},
  localised_description = {"item-description." .. landmover_mk1.name},
  icon = "__LandMover__/graphics/landmover-mk2.png",
  icon_size = 64,
  --flags = {},
  subgroup = "terrain",
  order = "c[landfill]-a[dirt]-b",
  stack_size = 100,
  place_as_tile =
  {
    result = "water",
    condition_size = 1,
    condition = { "water-tile" }
  },
  durability = settings.startup["LM-compressed-landfill-amount"].value,
}



-- compressed landfill
local compressed_landfill =
{
  type = "item",
  name = "landfill-compressed",
  localised_name = {"upgrades.compressed", "__ITEM__landfill__"},
  icons =
  {
    {
      icon = "__base__/graphics/icons/landfill.png",
      icon_size = 32,
      scale = .45,
      shift = {-8, 8},
    },
    {
      icon = "__base__/graphics/icons/landfill.png",
      icon_size = 32,
      scale = .45,
      shift = {8, 8},
    },
    {
      icon = "__base__/graphics/icons/landfill.png",
      icon_size = 32,
      scale = .45,
      shift = {0, -8},
    },
  },
  --flags = {},
  subgroup = data.raw["item"]["landfill"].subgroup,
  order = data.raw["item"]["landfill"].order .. "-compressed",
  stack_size = data.raw["item"]["landfill"].stack_size,
}



data:extend({
  shovel_mk1,
  shovel_mk2,
  landmover_mk1,
  landmover_mk2,
  compressed_landfill,
})
