local scm_shortcut = {
  type = "shortcut",
  name = "scm-shortcut",
  action = "lua",
  associated_control_input = "scm-gui-toggle",
  toggleable = true,
  order = "d",
  icon = "__space-schedule-manager__/graphics/scm-shortcut.png",
  icon_size = 64,
  small_icon = "__space-schedule-manager__/graphics/scm-shortcut.png",
  small_icon_size = 64,
}
local scm_shortcut_key = {
	type = "custom-input",
	name = "search-factory",
	key_sequence = "SHIFT + ALT + S",
  consuming = "none",
  order = "a"
}

data:extend{scm_shortcut, scm_shortcut_key}