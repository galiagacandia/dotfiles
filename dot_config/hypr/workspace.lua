-- =====================================================================
-- Origen: ~/.config/hypr/workspace.conf (13 lineas)
-- Traduccion 1:1 a la API Lua de Hyprland 0.56.2
-- =====================================================================

-- Monitor principal (ultrawide)
hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })

-- Monitor secundario
hl.workspace_rule({ workspace = "6",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "7",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "8",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "9",  monitor = "DP-2" })
hl.workspace_rule({ workspace = "10", monitor = "DP-2" })

-- Espacios tipo macOS (spaces.lua): 5 por monitor
hl.workspace_rule({ workspace = "11", monitor = "DP-1" })
hl.workspace_rule({ workspace = "12", monitor = "DP-1" })
hl.workspace_rule({ workspace = "13", monitor = "DP-1" })
hl.workspace_rule({ workspace = "14", monitor = "DP-1" })
hl.workspace_rule({ workspace = "15", monitor = "DP-1" })

hl.workspace_rule({ workspace = "16", monitor = "DP-2" })
hl.workspace_rule({ workspace = "17", monitor = "DP-2" })
hl.workspace_rule({ workspace = "18", monitor = "DP-2" })
hl.workspace_rule({ workspace = "19", monitor = "DP-2" })
hl.workspace_rule({ workspace = "20", monitor = "DP-2" })
