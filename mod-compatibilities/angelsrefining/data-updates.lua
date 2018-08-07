
if mods["angelsrefining"] then

  -- Disable the landfill recipe effect
  if settings.startup["LM-disable-landfill-recipe"].value then
    for index, effect in pairs(data.raw.technology["water-washing-1"].effects) do
      if effect.type == "unlock-recipe" and effect.recipe == "solid-mud-landfill" then
        table.remove(data.raw.technology["water-washing-1"].effects, index)
        break
      end
    end
  end

end
