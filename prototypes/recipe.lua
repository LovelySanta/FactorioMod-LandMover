
-- Disable landfill recipe
data.raw.recipe["landfill"].enabled = false
if data.raw.recipe["landfill"].normal then
  data.raw.recipe["landfill"].normal.enabled = false
end
if data.raw.recipe["landfill"].expensive then
  data.raw.recipe["landfill"].expensive.enabled = false
end



-- shovel recipes
data:extend({
  {
    type = "recipe",
    name = "landmover-shovel",
    enabled = false,
    ingredients =
    {
    {type="item", name="iron-stick", amount=5},
    {type="item", name="steel-plate", amount=3},
    },
    energy_required = 5,
    result= "landmover-shovel",
    result_count = 1
  },

  {
    type = "recipe",
    name = "landmover-shovel-mk2",
    enabled = false,
    ingredients =
    {
    {type="item", name="iron-stick", amount=5},
    {type="item", name="steel-plate", amount=3},
    },
    energy_required = 5,
    result= "landmover-shovel-mk2",
    result_count = 1
  },
})



-- landmover recipes
data:extend({
  {
    type = "recipe",
    name = "landmover",
    energy_required = 10,
    enabled = false,
    category = "advanced-crafting",
    ingredients =
    {
      {type="item", name="landmover-shovel", amount=1},
      {type="item", name="steel-plate", amount=5},
      {type="item", name="concrete", amount=20},
    },
    energy_required = 10,
    result= "landmover",
    result_count = data.raw["item"]["landmover"].stack_size,
  },

  {
    type = "recipe",
    name = "landmover-mk2",
    energy_required = 20,
    enabled = false,
    category = "advanced-crafting",
    ingredients =
    {
      {type="item", name="landmover", amount=100},
      {type="item", name="landmover-shovel-mk2", amount=1},
    },
    energy_required = 10,
    result= "landmover-mk2",
    result_count = 4,
  },
})
