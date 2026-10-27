-- =====================================================================
-- Origen: ~/.config/hypr/windowrules.conf (15 lineas)
-- Traduccion 1:1 a la API Lua de Hyprland 0.56.2
-- =====================================================================

-- Spotify
hl.window_rule({
    name  = "spotify-workspace",
    match = { class = "^(Spotify)$" },
    workspace = "10",
})

-- windowrule {
--     name = spotify-workspace
--     workspace = 9 silent
--     match:class = ^(Spotify)$
-- }
-- hl.window_rule({
--     name  = "spotify-workspace",
--     match = { class = "^(Spotify)$" },
--     workspace = "9 silent",
-- })
