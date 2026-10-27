-- =====================================================================
-- Origen: ~/.config/hypr/envs.conf (9 lineas)
-- Traduccion 1:1 a la API Lua de Hyprland 0.56.2
--
-- IMPORTANTE: este archivo NO se carga desde main.lua.
-- envs.conf nunca estuvo incluido en los `source` de hyprland.conf, asi
-- que estas variables no formaban parte de la config activa. Se traducen
-- para conservarlas listas, pero no se aplican hasta que decidamos
-- activarlas con:  require("envs")
-- =====================================================================

-- NVIDIA (Turing+ with GSP firmware)
hl.env("NVD_BACKEND", "direct")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
