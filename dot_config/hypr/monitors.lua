-- =====================================================================
-- Origen: ~/.config/hypr/monitors.conf (3 lineas)
-- Traduccion 1:1 a la API Lua de Hyprland (era 2)
-- Era 3: modo nativo mas cercano a 60 Hz en ambos monitores.
-- =====================================================================

-- env=GDK_SCALE,1
-- hl.env("GDK_SCALE", "1")

-- Los dos monitores son el mismo modelo (Xiaomi), por eso se identifican
-- por conector (DP-1/DP-2) y no por descripcion.
-- DP-1 solo ofrece 59.95/60.00 exacto a 3440x1440; DP-2 ofrece 59.95 a 2560x1440.
hl.monitor({ output = "DP-1", mode = "3440x1440@60.00", position = "2560x0", scale = 1 })
hl.monitor({ output = "DP-2", mode = "2560x1440@59.95", position = "0x0", scale = 1 })
