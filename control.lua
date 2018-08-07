require "util"

script.on_init(function()
  if not global.cursorStacks then global.cursorStacks = {} end
  global.cursorStacks["max_durability"] = settings.startup["LM-compressed-landfill-amount"].value
end)

script.on_configuration_changed(function(data)
  -- Check if this mod has changed
  for modName, modData in pairs(data.mod_changes) do
    if modName == "LandMover" then

      -- Mod has beed added/changed make sure recipes are unlocked if it was researched
      for _, force in pairs(game.forces) do
        if force.technologies['landfill'] and force.technologies['landfill'].researched then
          force.reset_technology_effects()
        end
      end

      if not global.cursorStacks then
        global.cursorStacks = {}
        global.cursorStacks["max_durability"] = settings.startup["LM-compressed-landfill-amount"].value
      end

      -- No need to look further, we found our mod already
      break
    end
  end
end)

script.on_event(defines.events.on_player_built_tile, function(event)
  -- Check if the player used land mover
  if event.item.name == "landmover" then
    -- Give the player same amount of landfill als he used landmover
    game.players[event.player_index].insert{name="landfill", count=#event.tiles}

  elseif event.item.name == "landmover-mk2" then
    local max_durability = global.cursorStacks["max_durability"]
    local tiles_amount = #event.tiles
    local playerIndex = event.player_index

    -- Compensate for the landmover durability
    if event.stack and event.stack.valid then
      local durability = global.cursorStacks[event.player_index].durability
      local prevCount = event.stack.valid_for_read and (event.stack.count + tiles_amount) or global.cursorStacks[playerIndex].count
      local count = prevCount

      count = count - math.floor(tiles_amount/max_durability)
      durability = durability - (tiles_amount%max_durability)

      if durability == 0 then
        durability = max_durability
        count = count - 1
      elseif durability < 0 then
        count = count + math.floor(durability/max_durability)
        durability = durability - max_durability * math.floor(durability/max_durability)
      end

      if count > 0 then
        if event.stack.valid_for_read then
          event.stack.count = count
          event.stack.durability = durability
        else
          event.stack.set_stack{
            name       = event.item.name,
            count      = count,
            durability = durability,
          }
        end
      end

      if prevCount - count > 0 then
        -- Give the player the same amount of landfill as he consumed landmover
        game.players[playerIndex].insert{
          name = "landfill-compressed",
          count = prevCount - count,
        }
      end

    else
      log("invalid cursor stack!")
    end

  end
end)

script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
  local playerIndex = event.player_index
  local cursorStack = game.players[playerIndex].cursor_stack

  if cursorStack and cursorStack.valid and cursorStack.valid_for_read and cursorStack.name == "landmover-mk2" then
    if not global.cursorStacks[playerIndex] then global.cursorStacks[playerIndex] = {} end

    global.cursorStacks[playerIndex].durability = game.players[playerIndex].cursor_stack.durability
    global.cursorStacks[playerIndex].count = game.players[playerIndex].cursor_stack.count
  else
    global.cursorStacks[playerIndex] = nil
  end
end)
