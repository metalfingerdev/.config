-- Hyprland Lua keybinds, checked against the current wiki and Lua stubs.
-- The bindings below use the current typed API: hl.bind(keys, dispatcher, opts).
--
-- Current dispatcher coverage used here:
-- - hl.dsp.exec_cmd for shell commands
-- - hl.dsp.focus for moving focus and switching workspaces
-- - hl.dsp.window.close / float / fullscreen / drag / resize / move / swap
-- - hl.dsp.layout for layout-specific actions
--
-- Mouse binds use the same API; the { mouse = true } flag tells Hyprland to
-- treat the bind as a mouse-driven action.


-- ── Smart Focus Toggle (floating <-> tiled) ───────────────────
-- Dependencies are injected so this function has no hard reference
-- to the global `hl` table — useful for testing in isolation or
-- swapping behavior (e.g. mocking hl.get_windows in a test runner).
--
-- If there is no active window or workspace, the helper exits early instead of
-- dereferencing nil.


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

local hy3 = nil
if hl.plugin and hl.plugin.hy3 then
    hy3 = hl.plugin.hy3
end

-- Nicknames

local mainMod     = "SUPER"
local terminal    = "kitty"
local explorer    = "nemo"
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
---------------------
---- KEYBINDINGS ----
---------------------



-- ── Applications ─────────────────────────────────────────────
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(appLauncher))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(explorer))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(spotify))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd(youtube))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(steam))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(stremio))

-- ── System ───────────────────────────────────────────────────
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("wlogout -b 4"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(refresh))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("wofi-emoji"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(calendar))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(network))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(volume))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(bluetooth))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(system))


-- ── Window Management ────────────────────────────────────────
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", make_toggle_focus_layer())

-- Toggle split orientation (only when hy3 is available)
if hy3 and hy3.change_group then
    hl.bind(mainMod .. " + CTRL + SPACE", hy3.change_group("opposite"))
end

-- ── Focus Navigation ─────────────────────────────────────────
if hy3 and hy3.move_focus then
    hl.bind(mainMod .. " + left", hy3.move_focus("left"))
    hl.bind(mainMod .. " + right", hy3.move_focus("right"))
    hl.bind(mainMod .. " + up", hy3.move_focus("up"))
    hl.bind(mainMod .. " + down", hy3.move_focus("down"))
else
    hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
    hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
    hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
    hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))
end

-- ── Move Floating Window (pixel offsets) ──────────────────────
-- These are direct pixel moves for the active floating window.
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.move({ x = -100, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.move({ x = 100, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.move({ x = 0, y = -100, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.move({ x = 0, y = 100, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + SHIFT + left", hl.dsp.window.move({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + SHIFT + right", hl.dsp.window.move({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + SHIFT + up", hl.dsp.window.move({ x = 0, y = -10, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + SHIFT + down", hl.dsp.window.move({ x = 0, y = 10, relative = true }), { repeating = true })

-- Swap / move active window. Tiled windows use swapwindow instead of
-- movewindow: swapping trades full positions so each window keeps its
-- own size, whereas movewindow reinserts into the tree and can resize it.
-- preserve_split (design.lua) additionally keeps split ratios from
-- collapsing on move. Source: https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
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
            if hy3 and hy3.move_window then
                hy3.move_window(direction)()
                if hy3.equalize then hy3.equalize() end
            else
                local dir_map = { left = "l", right = "r", up = "u", down = "d" }
                hl.dispatch(hl.dsp.window.swap({ direction = dir_map[direction] }))
            end
        end
    end
end

hl.bind(mainMod .. " + SHIFT + left", shift_move_or_swap("left"))
hl.bind(mainMod .. " + SHIFT + right", shift_move_or_swap("right"))
hl.bind(mainMod .. " + SHIFT + up", shift_move_or_swap("up"))
hl.bind(mainMod .. " + SHIFT + down", shift_move_or_swap("down"))

-- Use pixel-based resize for tiled windows and pixel move for floating ones.
-- The step matches SUPER+ALT movement (100px) and a fine step for SHIFT (10px).
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
            if hy3 and hy3.expand then
                hy3.expand(e)()
            else
                local delta = fine and fine_split or split_delta
                local sign = (dir == "right" or dir == "down") and "+" or "-"
                hl.dispatch(hl.dsp.layout("splitratio " .. sign .. tostring(delta)))
            end
        end
    end
end

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
