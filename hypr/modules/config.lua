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
