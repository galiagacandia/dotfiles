-- =====================================================================
-- Origen: ~/.config/hypr/looknfeel.conf (63 lineas)
-- Traduccion 1:1 a la API Lua de Hyprland 0.56.2
-- =====================================================================

-- Change the default Omarchy look'n'feel

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
    general = {
        -- No gaps between windows or borders
        gaps_in     = 5,
        gaps_out    = 5,
        border_size = 3,

        -- Borde de la ventana activa: Un gradiente llamativo con tus colores de pywal
        -- col = { active_border = { colors = { "$color2", "$color4" }, angle = 45 } },

        -- Borde de las ventanas inactivas: Un color sumamente opaco o sutil
        -- col = { inactive_border = "rgba(313244aa)" }, -- Un gris muy oscuro para que desaparezca

        -- Change to niri-like side-scrolling layout
        -- layout = "scrolling",
        layout = "master",
    },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
    decoration = {
        -- Use round window corners
        -- rounding = 8,

        -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed)
        -- dim_inactive = true,
        -- dim_strength = 0.15,
    },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations

-- Disable all animations
-- hl.config({ animations = { enabled = false } })

-- Movimiento entre escritorios
hl.config({ animations = { enabled = true } })

-- bezier = appleEasing, 0.25, 1, 0.5, 1
hl.curve("appleEasing", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })

-- animation = workspaces, 1, 5, appleEasing, slide
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "appleEasing", style = "slide" })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- (el bloque estaba vacio: solo tenia esta opcion comentada)
-- hl.config({ layout = {
--     -- Avoid overly wide single-window layouts on wide screens
--     -- single_window_aspect_ratio = "1 1",
-- } })

hl.config({
    group = {
        insert_after_current = true,

        -- Barra de pestañas estética sobre la ventana
        groupbar = {
            enabled   = true,
            font_size = 12,
            height    = 15,

            -- TEXTO: Color del texto en la pestaña activa vs las inactivas
            text_color = "0xffcdd6f4", -- Texto claro para la pestaña enfocada

            -- Colores activos e inactivos (puedes usar tus variables de pywal aquí)
            col = {
                active   = "0xffcba6f7", -- Color morado/acento para el nvim activo
                inactive = "0xff313244", -- Color oscuro para los nvim en el fondo
            },
        },
    },
})
