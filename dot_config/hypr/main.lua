-- =====================================================================
-- Hyprland · configuracion principal (Lua)
-- Equivalente 1:1 de ~/.config/hypr/hyprland.conf (19 lineas)
-- Hyprland 0.56.2 · motor de configuracion Lua
--
-- Reglas de esta migracion:
--   · Los .conf originales siguen intactos en este mismo directorio.
--   · Las directivas comentadas del .conf se traducen a Lua y quedan
--     comentadas, listas para descomentar.
--   · Los comentarios de prosa se conservan tal cual.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Cabecera heredada de hyprland.conf
-- (era el aviso de que el archivo era un stub autogenerado; este ya no lo es)
-- ---------------------------------------------------------------------
-- This config is a STUB! This should never be generated.
-- Use the default lua config from https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.lua
-- general {
--   layout = master
-- }

-- ---------------------------------------------------------------------
-- Secciones
-- Antes: source = ~/.config/hypr/<seccion>.conf
-- Ahora: require("<seccion>")  ->  ~/.config/hypr/<seccion>.lua
-- require() resuelve relativo a este archivo y ademas trackea los
-- archivos para el auto-reload (dofile no lo hace).
-- ---------------------------------------------------------------------
require("monitors")
require("input")
require("bindings")
require("looknfeel")
require("autostart")
require("workspace")
require("windowrules")
require("spaces")

-- envs.lua existe pero NO se carga: envs.conf nunca estuvo incluido en el
-- source de hyprland.conf, asi que no formaba parte de la config activa.
-- Cuando decidamos activarlo:  require("envs")

-- bind = $mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit
-- hl.bind("SUPER + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))

-- Mi configuracion
