----------------
---- DESIGN ----
----------------

-- Turn animations on
hl.config({
    animations = {
        enabled = true,
    },
})

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


-- The gaps between windows, as well as border colors.
-- proportional to the taskbar values.
hl.config({
    general = {
        -- Inner and Outer gaps between windows.
        gaps_in = 4,
        gaps_out = { top = 8, right = 8, bottom = 8, left = 8 },
        -- I prefer a thin border
        border_size = 1,
        -- Border colors. (dotted keys need bracket syntax in a lua table)
        col = {
            active_border   = "rgb(d8cab8)",
            inactive_border = "rgb(AC82E9)",
        },
        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,
        layout = "hy3",
        -- READ https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ BEFORE TURNING ON!
        allow_tearing = false,
    },
})


-- Window Decorations! Shadow, Blur, etc.
hl.config({
    decoration = {
        -- 8px same as taskbar, change if wanted.
        rounding = 8,
        -- I want transparancy to not change, since we have the colored border.
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        -- Window Shadow (shadow:enabled -> nested shadow = { enabled = ... })
        shadow = {
            enabled = true,
            range = 16,
            render_power = 4,
            color = "rgba(0, 0, 0, 0.25)",
        },
        -- Transparent Window Blur
        blur = {
            enabled = true,
            size = 8,
            passes = 2,
        },
    },
})

-- Blur the quickshell panels (requires WlrLayershell.namespace set in the QML side)
hl.layer_rule({
    match = { namespace = "quickshell:.*" },
    blur = true,
    ignore_alpha = 0.4,
})
-- Dwindle layout (binary-split tree, set above in general.layout).
-- preserve_split keeps each split's direction/ratio fixed to the node,
-- so moving a window doesn't collapse it to a recalculated size.
-- Source: https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
-- hl.config({
--     dwindle = {
--         preserve_split = true,
--     },
-- })
