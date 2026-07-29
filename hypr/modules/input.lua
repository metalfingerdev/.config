--                                    !!INPUT!!                                      --
-- ----------------------------------------------------------------------------------- --
--                                    !!INPUT!!                                      --
-- READ https://wiki.hypr.land/Configuring/Basics/Variables/#input IF CONFUSED!
-- Example keyboard/mouse input settings.
hl.config({
    input = {
        numlock_by_default = true,
        -- Switch layout with pressing: alt + shift
        kb_layout = "us",
        kb_options = "grp:shifts_toggle",
        -- Set as needed
        kb_rules = "",
        kb_variant = "",
        kb_model = "",
        follow_mouse = 1,
        -- Range is -1.0 to 1.0 | 0 means no modification to sensitivity.
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

-- This fixes a few bugs.
hl.config({
    cursor = {
        no_hardware_cursors = 2,
    },
})

hl.config({
    misc = {
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
})
