data:extend{
  {
    -- disable-landfill-recipe
    type = "bool-setting",
    name = "LM-disable-landfill-recipe",
    setting_type = "startup",
    default_value = true,
    order = "LM-a[landfill]-d",
  },

  {
    -- number of landfill in compressed landfill
    type = "int-setting",
    name = "LM-compressed-landfill-amount",
    setting_type = "startup",
    default_value = 20,
    minimum_value = 1,
    maximum_value = 100,
    order = "LM-a[landfill]-e",
  },
}
