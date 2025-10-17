CustomInput = {}

---@param event EventData.on_lua_shortcut|EventData.CustomInputEvent
local function on_shortcut_pressed(event)
  if event.prototype_name and event.prototype_name ~= "scm-shortcut" then return end
  local player = game.get_player(event.player_index)  ---@cast player -?

  local player_data = storage.players[event.player_index]
  ScmGui.toggle(player, player_data)
end

CustomInput.events = {
  [defines.events.on_lua_shortcut] = on_shortcut_pressed,
--  [prototypes.custom_input["search-factory"]] = on_shortcut_pressed,
--  [prototypes.custom_input["open-search-prototype"]] = open_search_prototype_pressed,
}
return CustomInput