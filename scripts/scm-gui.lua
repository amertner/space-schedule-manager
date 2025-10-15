local ScmGui = {}


---@param player LuaPlayer
---@return PlayerData
function ScmGui.build(player)
  local refs = gui.add(player.gui.screen, {
    {
      type = "frame",
      name = "fs_frame",
      direction = "vertical",
      visible = true,
      ref = {"frame"},
      style_mods = {maximal_height = 800},
      handler = {
        [defines.events.on_gui_closed] = ScmGui.close,
      },
      children = {
        {
          type = "flow",
          style = "fs_flib_titlebar_flow",
          drag_target = "frame",
          children = {
            {
              type = "label",
              style = "frame_title",
              caption = {"mod-name.FactorySearch"},
              ignored_by_interaction = true,
            },
            {type = "empty-widget", style = "fs_flib_titlebar_drag_handle", ignored_by_interaction = true},
            {
              type = "sprite-button",
              style = "frame_action_button",
              sprite = "fs_flib_pin_white",
              mouse_button_filter = {"left"},
              tooltip = {"search-gui.keep-open"},
              ref = {"pin_button"},
              handler = {
                [defines.events.on_gui_click] = ScmGui.toggle_pin,
              }
            },
            {
              type = "sprite-button",
              style = "close_button",
              sprite = "utility/close",
              mouse_button_filter = {"left"},
              tooltip = {"gui.close-instruction"},
              ref = {"close_button"},
              handler = {
                [defines.events.on_gui_click] = ScmGui.close,
              },
            },
          },
        },
      },
   },
  })
  refs.frame.force_auto_center()
  local player_data = {refs = refs}
  storage.players[player.index] = player_data
  return player_data
end

---@param player LuaPlayer
---@param player_data PlayerData
function ScmGui.open(player, player_data)
  if not player_data or not player_data.refs.frame.valid then
    player_data = ScmGui.build(player)
  end
  local refs = player_data.refs
  if not player_data.pinned then
    player.opened = refs.frame
  end
  refs.frame.visible = true
  refs.frame.bring_to_front()
  player.set_shortcut_toggled("search-factory", true)
end

---@param player LuaPlayer
---@param player_data PlayerData
function ScmGui.destroy(player, player_data)
  local main_frame = player_data.refs.frame
  if main_frame then
    main_frame.destroy()
  end
  storage.players[player.index] = nil
  ScmGui.after_close(player)
end

---@param player LuaPlayer
---@param player_data PlayerData
function ScmGui.close(player, player_data)
  if player_data.ignore_close then
    -- Set when the pin button is pressed just before changing player.opened
    player_data.ignore_close = false
  else
    local refs = player_data.refs
    refs.frame.visible = false
    if player.opened == refs.frame then
      player.opened = nil
    end
    --SearchGui.destroy(player, player_data)
    ScmGui.after_close(player)
  end
end

---@param player LuaPlayer
---@param player_data PlayerData
function ScmGui.toggle_pin(player, player_data)
  player_data.pinned = not player_data.pinned
  player_data.refs.pin_button.toggled = player_data.pinned
  if player_data.pinned then
    player_data.ignore_close = true
    player.opened = nil
    player_data.refs.close_button.tooltip = {"gui.close"}
  else
    player.opened = player_data.refs.frame
    player_data.refs.frame.force_auto_center()
    player_data.refs.close_button.tooltip = {"gui.close-instruction"}
  end
end

---@param player LuaPlayer
function ScmGui.after_close(player)
  player.set_shortcut_toggled("space-schedule-manager", false)
end

---@param player LuaPlayer
---@param player_data PlayerData
function ScmGui.toggle(player, player_data)
  if player_data and player_data.refs.frame.valid and player_data.refs.frame.visible then
    ScmGui.close(player, player_data)
  else
    ScmGui.open(player, player_data)
  end
end

gui.add_handlers(ScmGui,
  function(event, handler)
    local player = game.get_player(event.player_index)  ---@cast player -?
    local player_data = storage.players[event.player_index]
    local element = event.element
    local mouse_button = event.button
    handler(player, player_data, element, mouse_button)
  end
)

return ScmGui