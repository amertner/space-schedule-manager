---@type event_handler_lib
event_handler = require "event_handler"
util = require "util"

gui = require "scripts.flib-gui"
CustomInput = require "scripts.custom-input"
ScmGui = require "scripts.scm-gui"

---@class (exact) ScmGuiRefs
---@field frame LuaGuiElement frame
---@field pin_button LuaGuiElement sprite-button
---@field close_button LuaGuiElement sprite-button

---@class (exact) PlayerData
---@field refs ScmGuiRefs
---@field pinned? boolean
---@field ignore_close? boolean

---@alias PlayerIndex uint

Control = {}

local function on_init()
  ---@type table<PlayerIndex, PlayerData>
  storage.players = {}
end

local function on_configuration_changed()
  -- Destroy all GUIs
  for player_index, player_data in pairs(storage.players) do
    local player = game.get_player(player_index)
    if player then
      ScmGui.destroy(player, player_data)
    else
      storage.players[player_index] = nil
    end
  end
end

Control.on_init = on_init
Control.on_configuration_changed = on_configuration_changed

event_handler.add_libraries{
  gui --[[@as event_handler]],
  Control,
  CustomInput,
  ScmGui
}