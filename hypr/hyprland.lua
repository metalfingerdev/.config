-- ===================
--   HYPRLAND ENTRY
-- ===================

-- Each require() is its own Lua "scope": an error in one file won't kill the others.
-- Paths are relative to this file (~/.config/hypr/hyprland.lua), no .lua extension needed.
-- require("modules.monitors")
-- require("modules.autostart")
-- require("modules.variables")
-- require("modules.design")
-- require("modules.input")
-- require("modules.keybinds")
-- require("modules.windowrules")




-- Variables
hl.config({
    general = {
        border_size = 1,
        gaps_in = 4,
        gaps_out = { top = 8, right = 8, bottom = 8, left = 8 },
        float_gaps = { top = 8, right = 8, bottom = 8, left = 8 },
        col = {
            active_border   = "rgb(d8cab8)",
            inactive_border = "rgb(AC82E9)",
        },
        layout = "dwindle",
        resize_on_border = true,
        allow_tearing = false,
        resize_corner = 0,
        modal_parent_blocking = true,
        snap = {
            enabled = false,
            border_overlap = false,
            respect_gaps = false,
        }
    },

    decoration = {
        rounding = 8,
        rounding_power = 4,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
        dim_modal = true,
        dim_inactive = false,
        dim_strength = 0.8,
        dim_special = 0.2,
        border_part_of_window = true,

        blur = {
            enabled = true,
            size = 8,
            passes = 2,
            ignore_opacity = true,
            new_optimizations = true,
            xray = false,
            brightness = 1.0,
            vibrancy = 1.0,
            special = true,
            popups = true,
            popups_ignorealpha = 0.4,
        },

        shadow = {
            enabled = true,
            range = 16,
            render_power = 4,
            color = "rgba(0, 0, 0, 0.25)",
        },

        motion_blur = {
            enabled = false,
            samples = 0,

        },


    },


    animations = {
        enabled = true,
        workspace_wraparound = false,
    },


    input = {
        kb_layout                   = "us,in",
        kb_options                  = "grp:shifts_toggle,caps:swapescape",
        numlock_by_default          = true,
        repeat_rate                 = 20,
        repeat_delay                = 300,
        sensitivity                 = 0,
        accel_profile               = "flat",
        left_handed                 = false,
        scroll_points               = "adaptative",
        scroll_method               = "2fg",
        follow_mouse                = 1,
        focus_on_close              = 2,
        mouse_refocus               = true,
        float_switch_override_focus = 2,
        special_fallthrough         = true,

        touchpad                    = {
            disable_while_typing = true,
            natural_scroll = false,
            scroll_factor = 1.0,
            middle_button_emulation = false,
            tap_button_map = "lmr",
            clickfinger_behavior = false,
            tap_to_click = true,
            drag_lock = 2,
            tap_and_drag = true,
            flip_x = false,
            flip_y = false,
            drag_3fg = 0
        },
    },

    gestures = {
        workspace_swipe_distance = 100,
        workspace_swipe_touch = false,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 20,
        workspace_swipe_cancel_ratio = 0.5,
        workspace_swipe_create_new = true,
        workspace_swipe_direction_lock = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_forever = false,
        workspace_swipe_use_r = false,
        close_max_timeout = 1000,

        scrolling = {
            move_snap_to_grid = true,
            move_snap_cursor = true,
        }
    },

    cursor = {
        no_hardware_cursors = true,
    },

    misc = {
        disable_hyprland_logo = false,
        disable_splash_rendering = true,
        force_default_wallpaper = -1,
        vrr = 2,
        mouse_move_enables_dpms = true,
        enable_swallow = false,
        swallow_regex = "^(kitty)$",
        focus_on_activate = false,
        initial_workspace_tracking = 0,
        middle_click_paste = false,
        enable_anr_dialog = true,          -- Application not Responding (ANR)
        anr_missed_pings = 15,             -- ANR Threshold default 1 is too low
        allow_session_lock_restore = true, -- Prevent lockscreen crash when resuming from suspend
        -- This only works with HL v0.53+
        on_focus_under_fullscreen = 1,
        -- 0 - Default, no change
        -- 1 - New focused window takes over fullscreen (Windows-like Alt-Tab)
        -- 2 - New focused window stays behind the fullscreen one
    },

    ecosystem = {
        no_donation_nag = true,
    },

    quirks = {
        prefer_hdr = 1,
    },

    dwindle = {
        preserve_split = true -- Ensures window splits remain stable
    }
})

-- Monitors
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = 1,
})
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })


-- Binds
local mainMod     = "SUPER"
local terminal    = "kitty"
local explorer    = "nemo"
local browser     = "firefox"
local appLauncher = "qs ipc call launcher toggle"
local spotify     = "kitty -- spotify_player"
local youtube     = "firefox https://youtube.com"
local steam       = "steam steam://open/bigpicture"
local stremio     = "stremio-service & firefox https://web.stremio.com/"
local calendar    = "kitty --class calcurse -- calcurse"
local network     = "kitty --class nmtui -- nmtui"
local volume      = "kitty --class pulsemixer -- pulsemixer"
local bluetooth   = "kitty --class bluetuith -- bluetuith"
local system      = "kitty --class btop -- btop --force-utf"
local refresh     =
"hyprctl reload && killall quickshell hyprpaper; setsid -f bash -c 'hyprpaper & sleep 0.3; quickshell &' > /dev/null 2>&1; notify-send \"Reloaded\" \"Hyprland restarted\""

local function make_toggle_focus_layer(deps)
    deps                       = deps or {}
    local get_active_window    = deps.get_active_window or hl.get_active_window
    local get_active_workspace = deps.get_active_workspace or hl.get_active_workspace
    local get_windows          = deps.get_windows or hl.get_windows
    local dispatch             = deps.dispatch or hl.dispatch
    local focus_dsp            = deps.focus_dsp or hl.dsp.focus

    return function()
        local active = get_active_window()
        if active == nil then return end

        local want_floating = not active.floating
        local ws = get_active_workspace()
        if ws == nil then return end

        for _, w in pairs(get_windows()) do
            if w.floating == want_floating and w.workspace and w.workspace.id == ws.id then
                dispatch(focus_dsp({ window = w }))
                return
            end
        end
    end
end

local function shift_move_or_swap(direction)
    return function()
        local aw = hl.get_active_window()
        if aw == nil then return end
        if aw.floating then
            -- For floating windows, perform a directional move
            local dx, dy = 0, 0
            if direction == "left" then dx = -100 end
            if direction == "right" then dx = 100 end
            if direction == "up" then dy = -100 end
            if direction == "down" then dy = 100 end
            hl.dispatch(hl.dsp.window.move({ x = dx, y = dy, relative = true }))
        else
            local dir_map = { left = "l", right = "r", up = "u", down = "d" }
            hl.dispatch(hl.dsp.window.swap({ direction = dir_map[direction] }))
        end
    end
end

local resize_step = 100
local fine_step = 10
local split_delta = 0.05
local fine_split = 0.01

local function ctrl_resize(dir, fine)
    return function()
        local aw = hl.get_active_window()
        if aw and aw.floating then
            -- Resize floating windows by pixels
            local dx, dy = 0, 0
            local step = fine and fine_step or resize_step
            if dir == "left" then dx = -step end
            if dir == "right" then dx = step end
            if dir == "up" then dy = -step end
            if dir == "down" then dy = step end
            hl.dispatch(hl.dsp.window.resize({ x = dx, y = dy, relative = true }))
        else
            local e = (dir == "right" or dir == "down") and "expand" or "shrink"

            local delta = fine and fine_split or split_delta
            local sign = (dir == "right" or dir == "down") and "+" or "-"
            hl.dispatch(hl.dsp.layout("splitratio " .. sign .. tostring(delta)))
        end
    end
end
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(appLauncher))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(explorer))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(spotify))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd(youtube))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(steam))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(stremio))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("wlogout -b 4"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(refresh))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + ALT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", make_toggle_focus_layer())
hl.bind(mainMod .. " + CTRL + SPACE", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(calendar))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(network))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(volume))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(bluetooth))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(system))
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.move({ x = -100, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.move({ x = 100, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.move({ x = 0, y = -100, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.move({ x = 0, y = 100, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + SHIFT + left", hl.dsp.window.move({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + SHIFT + right", hl.dsp.window.move({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + SHIFT + up", hl.dsp.window.move({ x = 0, y = -10, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + SHIFT + down", hl.dsp.window.move({ x = 0, y = 10, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + left", shift_move_or_swap("left"))
hl.bind(mainMod .. " + SHIFT + right", shift_move_or_swap("right"))
hl.bind(mainMod .. " + SHIFT + up", shift_move_or_swap("up"))
hl.bind(mainMod .. " + SHIFT + down", shift_move_or_swap("down"))

-- CTRL + arrows resize; use repeating to allow holding for continuous changes
hl.bind(mainMod .. " + CTRL + left", ctrl_resize("left", false), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", ctrl_resize("right", false), { repeating = true })
hl.bind(mainMod .. " + CTRL + up", ctrl_resize("up", false), { repeating = true })
hl.bind(mainMod .. " + CTRL + down", ctrl_resize("down", false), { repeating = true })

-- Fine-grained CTRL+SHIFT variants
hl.bind(mainMod .. " + CTRL + SHIFT + left", ctrl_resize("left", true), { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + right", ctrl_resize("right", true), { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + up", ctrl_resize("up", true), { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + down", ctrl_resize("down", true), { repeating = true })

-- ── Workspaces ───────────────────────────────────────────────
-- Number keys focus workspaces; SHIFT sends the active window there.
-- On non-QWERTY layouts, use the wiki’s symbol-name guidance for the key names.
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.workspace_rule({ workspace = "1", persistent = true })
hl.workspace_rule({ workspace = "2", persistent = true })

-- ── Minimize / Restore (Shadow Realm) ────────────────────────
-- • If you are on a normal workspace: Sends the active window to special:minimized
-- • If you are inside the drawer: Pulls whichever window is currently focused back to current workspace (+0)

local function toggle_shadow_drawer()
    local ws = hl.get_workspace("special:minimized")
    if ws and ws.windows > 0 then
        hl.dispatch(hl.dsp.workspace.toggle_special("minimized"))
    else
        -- Gives you proof the swipe registered, but was blocked by your guard
        os.execute("notify-send 'Shadow Realm' 'Drawer is empty' &")
    end
end

-- Function to send the current window to the shadow realm
local function push_to_shadow()
    local win = hl.get_active_window()
    if not win or not win.workspace then return end

    -- Only push if it isn't already in the shadow realm
    if win.workspace.name ~= "special:minimized" then
        hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
    end
end

-- Function to pull a window out of the shadow realm
local function pull_from_shadow()
    local win = hl.get_active_window()

    -- Scenario A: We are inside the drawer, pull the focused window out
    if win and win.workspace and win.workspace.name == "special:minimized" then
        hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
        return
    end

    -- Scenario B: We are on a normal workspace, grab a hidden window and bring it here
    for _, w in pairs(hl.get_windows()) do
        if w.workspace and w.workspace.name == "special:minimized" then
            hl.dispatch(hl.dsp.focus({ window = w }))
            hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
            return -- Only pull one window at a time
        end
    end
end

-- 1. SMART MINIMIZE / RESTORE (SUPER + S)
hl.bind(mainMod .. " + S", function()
    local win = hl.get_active_window()
    if not win or not win.workspace then return end

    if win.workspace.name == "special:minimized" then
        hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
    else
        -- Added follow = false to prevent dragging you into the shadow realm
        hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
    end
end)

-- 2. REVEAL / HIDE DRAWER (SUPER + SHIFT + S)
hl.bind(mainMod .. " + SHIFT + S", toggle_shadow_drawer)

-- ── Touchpad gestures ────────────────────────────────────────
-- Source: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/

-- 3-finger swipe up = Toggle Fullscreen (Focus mode)
hl.gesture({
    fingers = 3,
    direction = "up",
    action = "fullscreen",
    disable_inhibit = true
})

-- 3-finger swipe down = Toggle Floating
hl.gesture({
    fingers = 3,
    direction = "down",
    action = function() hl.dispatch(hl.dsp.window.float({ action = "toggle" })) end,
    disable_inhibit = true
})

-- 3-finger horizontal swipe = switch workspace
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- 4-finger swipe left = Smart toggle (bypasses window inhibitors)
hl.gesture({
    fingers = 4,
    direction = "left",
    action = toggle_shadow_drawer,
    disable_inhibit = true
})

-- 4-finger swipe right = close/open the minimized shadow realm
hl.gesture({
    fingers = 4,
    direction = "right",
    action = toggle_shadow_drawer,
    disable_inhibit = true
})

-- 4-finger swipe down = Push current window into the shadow realm
hl.gesture({
    fingers = 4,
    direction = "down",
    action = push_to_shadow,
    disable_inhibit = true
})

-- 4-finger swipe up = Pull a window out of the shadow realm
hl.gesture({
    fingers = 4,
    direction = "up",
    action = pull_from_shadow,
    disable_inhibit = true
})

-- ── Mouse ─────────────────────────────────────────────────────
-- Standard Hyprland mouse binds: drag moves a window, resize resizes it.
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))

-- ── Screenshot ────────────────────────────────────────────────
hl.bind("Print", hl.dsp.exec_cmd("hyprshot --mode region --clipboard-only"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot --mode window --clipboard-only"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("hyprshot --mode output --clipboard-only"))

-- ── Media / Hardware Keys ─────────────────────────────────────
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })


local floating_widgets = { "calcurse", "nmtui", "pulsemixer", "bluetuith", "btop" }
for _, cls in ipairs(floating_widgets) do
    hl.window_rule({
        name = "float-" .. cls,
        match = { class = "^(" .. cls .. ")$" },
        float = true,
        size = { 1080, 720 },
        move = { "(monitor_w-window_w)/2", "(monitor_h-window_h)/2" },
    })
end

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


-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("quickshell")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'diinki-retro-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface font-name 'SF Pro 12'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface document-font-name 'SF Pro Text 12'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface monospace-font-name 'Maple Mono 12'")
end)

-- Variables
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "macOS-hypr")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "macOS-hypr")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_QUICK_CONTROLS_STYLE", "org.kde.desktop")
