-- ===================
--   HYPRLAND ENTRY
-- ===================

-- Paths are relative to this file (~/.config/hypr/hyprland.lua).
-- Each require() is its own Lua "scope": an error in one file won't kill the others.
require("modules.config")
require("modules.monitors")
require("modules.environment")
require("modules.autostart")
require("modules.keybinds")
-- require("modules.windowrules")





-- Apply size and float rules
hl.window_rule({ name = "widgets", match = { class = "floating" }, float = true, size = { 1080, 720 } })
-- Force it to center perfectly
hl.window_rule({ name = "widgets", match = { class = "floating" }, center = true })

-- Fix dragging issues with XWayland
hl.window_rule({
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

-- Blur the quickshell panels (requires WlrLayershell.namespace set in the QML side)
hl.layer_rule({
    match = { namespace = "quickshell:.*" },
    blur = true,
    ignore_alpha = 0.4,
})

-- Force Sekiro to launch in fullscreen automatically
-- Watch for late window titles and force fullscreen when Sekiro loads
hl.on("window.title", function(w)
    if w ~= nil and (w.title == "Sekiro" or w.class == "sekiro.exe") then
        hl.dispatch(hl.dsp.window.fullscreen({ mode = "fullscreen", action = "set" }))
    end
end)


-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Snappy, macOS-like spring: High stiffness for speed, balanced dampening for a clean stop
hl.curve("spring", { type = "spring", mass = 1, stiffness = 350, dampening = 26 })

-- Applied animations
hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 2.5, bezier = "easeOutQuint" })

-- Windows: Using the fast spring for opening/movement, and a quick bezier for closing
hl.animation({ leaf = "windows", enabled = true, speed = 2.5, spring = "spring" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.5, spring = "spring", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "easeOutQuint", style = "popin 87%" })

-- Layers
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.0, bezier = "almostLinear" })

-- Workspaces: Using the spring here adds a very fluid, Apple-like swipe feel
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2.5, spring = "spring", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.5, spring = "spring", style = "slide" })

hl.animation({ leaf = "zoomFactor", enabled = true, speed = 2.5, bezier = "quick" })
