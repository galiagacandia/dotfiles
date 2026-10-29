-- =====================================================================
-- Origen: ~/.config/hypr/autostart.conf (15 lineas)
-- Traduccion 1:1 a la API Lua de Hyprland 0.56.2
-- exec-once -> hl.on("hyprland.start", ...) + hl.exec_cmd()
--
-- Era 3 (Caelestia): la shell asume barra, notificaciones, launcher,
-- dashboard, OSD y bloqueo. Se dejan comentados los arranques de la era
-- waybar para poder volver atras descomentando y reiniciando sesion.
-- =====================================================================

hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")              -- Autenticación (Caelestia no trae agente polkit)

    -- Escritorio Caelestia
    hl.exec_cmd("caelestia shell -d")                                      -- Barra, notificaciones, OSD, lock, dashboard

    -- ------------------------------------------------------------------
    -- Respaldo era 2 (waybar + dunst + walker + hyprpaper)
    -- Descomentar estas lineas y comentar la de caelestia para revertir.
    -- ------------------------------------------------------------------
    -- hl.exec_cmd("waybar")                                               -- Barra de estado
    -- hl.exec_cmd("hyprpaper -c /home/galiaga/.config/hypr/hyprpaper.conf") -- Fondo de pantalla
    -- hl.exec_cmd("dunst")                                                -- Notificaciones
    -- hl.exec_cmd("elephant")
    -- hl.exec_cmd("walker --gapplication-service")
    -- hl.exec_cmd("wal -R")
    -- hl.exec_cmd("wal -i $(hyprctl hyprpaper wallpaper | awk '{print $NF}')")
    -- hl.exec_cmd("hyprlauncher -d")                                       -- Lanzador de aplicaciones
    -- hl.exec_cmd("waybar -c ~/.config/waybar/config-primary &")
    -- hl.exec_cmd("waybar -c ~/.config/waybar/config-secondary &")
end)
