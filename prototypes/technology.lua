require 'util'

-- Edit the existing landfill research
if data.raw.technology["landfill"] then
  local landfillTechnology = data.raw.technology["landfill"]

  -- Edit the icon
  landfillTechnology.icon = "__LandMover__/graphics/landmover-tech.png"
  landfillTechnology.icon_size = 128

  -- Disable the landfill recipe effect
  if settings.startup["LM-disable-landfill-recipe"].value then
    for index, effect in pairs(landfillTechnology.effects) do
      if effect.type == "unlock-recipe" and effect.recipe == "landfill" then
        table.remove(landfillTechnology.effects, index)
        break
      end
    end
  end

  -- Add the new recipe effects to create landfill
  table.insert(landfillTechnology.effects,
    {
      type = "unlock-recipe",
      recipe = "landmover"
    })
  table.insert(landfillTechnology.effects,
    {
      type = "unlock-recipe",
      recipe = "landmover-shovel"
    })

  -- Add the required prerequisites
  if not landfillTechnology.prerequisites then
    landfillTechnology.prerequisites = {}
  end
  table.insert(landfillTechnology.prerequisites, "concrete")

  -- Edit the data.raw to updated landfill version
  data.raw.technology["landfill"] = landfillTechnology
end



-- Add the mk2 shovel research
data:extend({
  {
    type = "technology",
    name = "landfill-2",
    icon = "__LandMover__/graphics/landmover-mk2-tech.png",
    icon_size = 128,

    prerequisites = {
      "landfill",
      "nuclear-power",
    },

    effects =
    {
      {type = "unlock-recipe", recipe = "landmover-shovel-mk2"},
      {type = "unlock-recipe", recipe = "landmover-mk2"},
    },

    unit =
    {
      count = 2 * data.raw.technology["landfill"].unit.count,
      ingredients = util.table.deepcopy(data.raw.technology["nuclear-power"].unit.ingredients),
      time = 5 * data.raw.technology["landfill"].unit.time,
    },
  },
})
table.insert(data.raw["technology"]["landfill-2"].unit.ingredients, {"production-science-pack", 1})
