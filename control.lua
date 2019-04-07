landmover = require "src.landmover"

script.on_init(landmover.on_init)
script.on_configuration_changed(landmover.on_configuration_changed)

script.on_event(defines.events.on_player_built_tile          , landmover.on_build_tile          )
script.on_event(defines.events.on_built_entity               , landmover.on_ghost_tile          )
script.on_event(defines.events.on_player_cursor_stack_changed, landmover.on_cursor_stack_changed)
