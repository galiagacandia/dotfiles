-- =====================================================================
-- Origen: ~/.config/hypr/input.conf (56 lineas)
-- Traduccion 1:1 a la API Lua de Hyprland 0.56.2
-- =====================================================================

-- Control your input devices
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
    input = {
        -- Use multiple keyboard layouts and switch between them with Left Alt + Right Alt
        -- kb_layout = "us,dk,eu"

        -- Use a specific keyboard variant if needed (e.g. intl for international keyboards)
        -- kb_variant = "intl"

        kb_layout  = "us",
        kb_variant = "altgr-intl",
        kb_options = "",
        -- kb_options = "compose:caps", -- ,grp:alts_toggle

        -- Change speed of keyboard repeat
        repeat_rate  = 40,
        repeat_delay = 250,

        -- Start with numlock on by default
        numlock_by_default = true,

        -- Increase sensitivity for mouse/trackpad (default: 0)
        -- sensitivity = 0.35

        -- Turn off mouse acceleration (default: adaptive)
        -- accel_profile = "flat"

        touchpad = {
            -- Use natural (inverse) scrolling
            -- natural_scroll = true

            -- Use two-finger clicks for right-click instead of lower-right corner
            clickfinger_behavior = true,

            -- Control the speed of your scrolling
            scroll_factor = 0.4,

            -- Enable the touchpad while typing
            -- disable_while_typing = false

            -- Left-click-and-drag with three fingers
            -- drag_3fg = 1
        },
    },
})

-- Scroll nicely in the terminal
-- windowrule = match:class (Alacritty|kitty|foot), scroll_touchpad 1.5
hl.window_rule({
    name  = "scroll-touchpad-terminales",
    match = { class = "(Alacritty|kitty|foot)" },
    scroll_touchpad = 1.5,
})

-- windowrule = match:class com.mitchellh.ghostty, scroll_touchpad 0.2
hl.window_rule({
    name  = "scroll-touchpad-ghostty",
    match = { class = "com.mitchellh.ghostty" },
    scroll_touchpad = 0.2,
})

-- Enable touchpad gestures for changing workspaces
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- gesture = 3, horizontal, workspace
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Enable touchpad gestures for moving focus (helpful on scrolling layout)
-- gesture = 3, left,  dispatcher, movefocus, l
-- hl.gesture({ fingers = 3, direction = "left",  action = function() hl.dispatch(hl.dsp.focus({ direction = "left" })) end })
-- gesture = 3, right, dispatcher, movefocus, r
-- hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "right" })) end })
