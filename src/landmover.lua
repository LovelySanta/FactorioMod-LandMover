require "util"

local function nextToWaterTiles(surfaceIndex, tiles)
  -- create a list of all neighbour tiles
  local candidateTiles = {}
  local ignoredTiles   = {}
  for _,tile in pairs(tiles or {}) do
    local pos = tile.position
    table.insert(ignoredTiles, pos)
    local posX = pos.x
    local posY = pos.y

    if not candidateTiles[posY + 1] then candidateTiles[posY + 1] = {} end
    if not candidateTiles[posY    ] then candidateTiles[posY    ] = {} end
    if not candidateTiles[posY - 1] then candidateTiles[posY - 1] = {} end

    candidateTiles[posY + 1][posX    ] = true
    candidateTiles[posY    ][posX + 1] = true
    candidateTiles[posY    ][posX - 1] = true
    candidateTiles[posY - 1][posX    ] = true
  end
  for _,pos in pairs(ignoredTiles) do
    candidateTiles[pos.y][pos.x] = false
  end

  -- check neighbour tiles if any of them are water
  local isValidTile = {
    ["water"    ] = true,
    ["deepwater"] = true,
  }
  for posY,candidateTilesX in pairs(candidateTiles) do
    for posX,_ in pairs(candidateTilesX) do
      if candidateTiles[posY][posX] and isValidTile[game.surfaces[surfaceIndex].get_tile(posX, posY).name] then
        return true
      end
    end
  end
  return false
end

return {
  on_init = function()
    if not global.cursorStacks then global.cursorStacks = {} end
    global.cursorStacks["max_durability"] = settings.startup["LM-compressed-landfill-amount"].value
  end,

  on_configuration_changed = function(data)
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
  end,

  on_build_tile = function(event)
    if not event.item then return end
    if event.item.name ~= "landmover" and event.item.name ~= "landmover-mk2" then return end

    if (not settings.global["LM-enable-anti-cheat"].value) or nextToWaterTiles(event.surface_index, event.tiles) then
      -- allow player to place landmover when anti cheat is disabled, or when
      -- it is enabled and it is next to water.

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
    else
      -- anti cheat is enabled, instead of placing the water, we have to replace
      -- the tiles that where there to begin with
      game.players[event.player_index].print{"messages.LM-anti-cheat"}

      replacedTiles = {}
      for _,tile in pairs(event.tiles) do
        table.insert(replacedTiles, {
          name     = tile.old_tile.name,
          position = tile.position,
        })
      end
      game.surfaces[event.surface_index].set_tiles(replacedTiles)

      if event.item.name == "landmover" then
        -- Give the player same amount of landfill als he used landmover
        game.players[event.player_index].insert{name="landmover", count=#event.tiles}
      elseif event.item.name == "landmover-mk2" then
        local playerIndex = event.player_index
        local cursorStack = game.players[playerIndex].cursor_stack

        if cursorStack and cursorStack.valid and cursorStack.valid_for_read and cursorStack.name == "landmover-mk2" and global.cursorStacks[playerIndex] then
          cursorStack.durability = global.cursorStacks[playerIndex].durability
          cursorStack.count = global.cursorStacks[playerIndex].count
        else
          log("invalid cursor stack!")
        end
      end
    end
  end,

  on_ghost_tile = function(event)
    if event.created_entity.name == "tile-ghost" then
      -- now we need to extract the item (name) that was used to build this ghost
      local itemName

      if event.item then
        itemName = event.item.name
      elseif event.stack and event.stack.valid_for_read then
        itemName = event.stack.name
      else
        --game.players[event.player_index].print("Cannot extract item used to build this ghost.")
        log("invalid ghost entity!")
        return -- nothing more we can do about this
      end

      if itemName == "landmover" or itemName == "landmover-mk2" then
        game.players[event.player_index].print{"messages.LM-no-tile-ghost"}
        event.created_entity.destroy()
      end
    end
  end,

  on_cursor_stack_changed = function(event)
    -- keep track of the landmover that the player holds on his cursor
    local playerIndex = event.player_index
    local cursorStack = game.players[playerIndex].cursor_stack

    if cursorStack and cursorStack.valid and cursorStack.valid_for_read and cursorStack.name == "landmover-mk2" then
      if not global.cursorStacks[playerIndex] then global.cursorStacks[playerIndex] = {} end

      global.cursorStacks[playerIndex].durability = game.players[playerIndex].cursor_stack.durability
      global.cursorStacks[playerIndex].count = game.players[playerIndex].cursor_stack.count
    else
      global.cursorStacks[playerIndex] = nil
    end
  end,
}
