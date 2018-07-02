
-- shovel items
data:extend({
  {
    type = "item",
    name = "landmover-shovel",
    icon = "__LandMover__/graphics/shovel.png",
    icon_size = 32,
    flags = {"goes-to-main-inventory"},
    subgroup = "tool",
    order = "a[mining]-c[shovel]-a",
    stack_size = 20
  },

  {
    type = "item",
    name = "landmover-shovel-mk2",
    localised_name = {"upgrades.mk2", {[1] = "item-name.landmover-shovel"}},
    icon = "__LandMover__/graphics/shovel_mk2.png",
    icon_size = 32,
    flags = {"goes-to-main-inventory"},
    subgroup = "tool",
    order = "a[mining]-c[shovel]-b",
    stack_size = 20
  },
})



-- landmover items
data:extend({
  {
    type = "item",
    name = "landmover",
    icon = "__LandMover__/graphics/landmover.png",
    icon_size = 64,
    flags = {"goes-to-main-inventory"},
    subgroup = "terrain",
    order = "c[landfill]-a[dirt]-a",
    stack_size = 100,
    place_as_tile =
    {
      result = "water",
      condition_size = 1,
      condition = { "water-tile" }
    }
  },

  {
    type = "item",
    name = "landmover-mk2",
    localised_name = {"upgrades.mk2", {[1] = "item-name.landmover"}},
    icon = "__LandMover__/graphics/landmover-mk2.png",
    icon_size = 64,
    flags = {"goes-to-main-inventory"},
    subgroup = "terrain",
    order = "c[landfill]-a[dirt]-b",
    stack_size = 100,
    place_as_tile =
    {
      result = "water",
      condition_size = 1,
      condition = { "water-tile" }
    }
  },
})
