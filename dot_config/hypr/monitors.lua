-- =====================================================================
-- Origen: ~/.config/hypr/monitors.conf (3 lineas)
-- Traduccion 1:1 a la API Lua de Hyprland 0.56.2
-- =====================================================================

-- env=GDK_SCALE,1
-- hl.env("GDK_SCALE", "1")

-- Los dos monitores son el mismo modelo (Xiaomi), por eso se identifican
-- por conector (DP-1/DP-2) y no por descripcion.
hl.monitor({ output = "DP-1", mode = "3440x1440@120.00", position = "2560x0", scale = 1 })
hl.monitor({ output = "DP-2", mode = "2560x1440@120.00", position = "0x0", scale = 1 })
