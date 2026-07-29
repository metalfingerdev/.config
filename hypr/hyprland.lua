-- ===================
--   HYPRLAND ENTRY
-- ===================

-- Each require() is its own Lua "scope": an error in one file won't kill the others.
-- Paths are relative to this file (~/.config/hypr/hyprland.lua), no .lua extension needed.
require("modules.monitors")
require("modules.autostart")
require("modules.variables")
require("modules.design")
require("modules.input")
require("modules.keybinds")
require("modules.windowrules")

hl.config({
    misc = {
        disable_splash_rendering = true,
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
})
