

-- shovel recipes
local shovel_mk1 =
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
}

local shovel_mk2 =
{
  type = "recipe",
  name = shovel_mk1.name .. "-mk2",
  enabled = false,
  category = "centrifuging",
  energy_required = 2 * shovel_mk1.energy_required,
  ingredients =
  {
    {type="item", name=shovel_mk1.name, amount=2},
    {type="item", name="uranium-235", amount=1},
    {type="item", name="explosives", amount=1},
  },
  result= shovel_mk1.result .. "-mk2",
  result_count = 1
}



-- landmover recipes
local landmover_mk1 =
{
  type = "recipe",
  name = "landmover",
  enabled = false,
  energy_required = 2 * shovel_mk1.energy_required,
  category = "advanced-crafting",
  ingredients =
  {
    {type="item", name="landmover-shovel", amount=1},
    {type="item", name="steel-plate", amount=5},
    {type="item", name="concrete", amount=20},
  },
  result= "landmover",
  result_count = data.raw["item"]["landmover"].stack_size,
}

local landmover_mk2 =
{
  type = "recipe",
  name = "landmover-mk2",
  enabled = false,
  category = "advanced-crafting",
  energy_required = 2 * landmover_mk1.energy_required,
  ingredients =
  {
    {type="item", name="landmover", amount=landmover_mk1.result_count},
    {type="item", name="landmover-shovel-mk2", amount=1},
    {type="item", name="uranium-238", amount=3},
  },
  result= "landmover-mk2",
  result_count = math.floor(data.raw["item"]["landmover"].stack_size / settings.startup["LM-compressed-landfill-amount"].value),
}



-- landfill recipes
local landfill_uncompressing =
{
  type = "recipe",
  name = "landfill-compressed",
  enabled = false,
  --category = "crafting",
  energy_required = 2,
  ingredients =
  {
    {type="item", name="landfill-compressed", amount=1},
  },
  result = "landfill",
  result_count = settings.startup["LM-compressed-landfill-amount"].value,
}



data:extend({
  shovel_mk1,
  shovel_mk2,
  landmover_mk1,
  landmover_mk2,
  landfill_uncompressing,
})



-- Disable landfill recipe (unlocked by tech if not disabled)
data.raw.recipe["landfill"].enabled = false
if data.raw.recipe["landfill"].normal then
  data.raw.recipe["landfill"].normal.enabled = false
end
if data.raw.recipe["landfill"].expensive then
  data.raw.recipe["landfill"].expensive.enabled = false
end



-- make sure the shovel_mk2 can be made in the centrifuge
if data.raw["assembling-machine"]["centrifuge"].ingredient_count < #shovel_mk2.ingredients then
  data.raw["assembling-machine"]["centrifuge"].ingredient_count = #shovel_mk2.ingredients
end
