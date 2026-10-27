-- =====================================================================
-- Origen: ~/.config/hypr/autostart.conf (15 lineas)
-- Traduccion 1:1 a la API Lua de Hyprland 0.56.2
-- exec-once -> hl.on("hyprland.start", ...) + hl.exec_cmd()
-- =====================================================================

hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")              -- Autenticación
    hl.exec_cmd("waybar")                                                  -- Barra de estado
    hl.exec_cmd("hyprpaper -c /home/galiaga/.config/hypr/hyprpaper.conf")  -- Fondo de pantalla
    -- hl.exec_cmd("wal -R")
    -- hl.exec_cmd("wal -i $(hyprctl hyprpaper wallpaper | awk '{print $NF}')")
    hl.exec_cmd("dunst")                                                   -- Notificaciones
    -- hl.exec_cmd("hyprlauncher -d")                                      -- Lanzador de aplicaciones
    hl.exec_cmd("elephant")
    hl.exec_cmd("walker --gapplication-service")

    -- Configuracion para que waybar sea diferente por monitor
    -- hl.exec_cmd("waybar -c ~/.config/waybar/config-primary &")
    -- hl.exec_cmd("waybar -c ~/.config/waybar/config-secondary &")

    -- Agregar procesos autostart
end)
