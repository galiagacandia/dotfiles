-- =====================================================================
-- spaces.lua — "espacios" tipo macOS con workspaces dedicados
--
-- SUPER+F          crea/cierra un espacio para la ventana activa
-- SUPER+ALT+left   espacio anterior (dentro del monitor actual)
-- SUPER+ALT+right  espacio siguiente (dentro del monitor actual)
--
-- Reparto por monitor (5 por monitor):
--   DP-1 -> 11..15
--   DP-2 -> 16..20
-- Las reglas de monitor viven en workspace.lua.
--
-- Se usan workspaces reales (no special) porque la barra de Caelestia
-- indexa los special por id y en Hyprland 0.57 tienen id nulo.
-- La barra pagina en grupos de 5, asi que muestra el grupo del monitor
-- activo con el espacio actual resaltado.
--
-- Sin estado persistente: los espacios ocupados se deducen de las
-- ventanas. Solo se recuerda el workspace de origen (en memoria).
-- =====================================================================

local M = {}

local RANGES = {
    { monitor = "DP-1", first = 11, last = 15, home = 1 },
    { monitor = "DP-2", first = 16, last = 20, home = 6 },
}

-- address de ventana -> id del workspace donde estaba antes
local origins = {}

local function range_for(monitor_name)
    for _, r in ipairs(RANGES) do
        if r.monitor == monitor_name then
            return r
        end
    end
    return RANGES[1]
end

local function active_range()
    local monitor = hl.get_active_monitor()
    return range_for(monitor and monitor.name or RANGES[1].monitor)
end

local function in_any_range(id)
    if not id then
        return false
    end
    for _, r in ipairs(RANGES) do
        if id >= r.first and id <= r.last then
            return true
        end
    end
    return false
end

local function space_of(window)
    local ws = window and window.workspace
    if not ws then
        return nil
    end
    return in_any_range(ws.id) and ws.id or nil
end

local function occupied(range)
    local used = {}
    for _, w in ipairs(hl.get_windows()) do
        local id = space_of(w)
        if id and id >= range.first and id <= range.last then
            used[id] = true
        end
    end
    return used
end

local function sorted_spaces(range, used)
    local list = {}
    for id = range.first, range.last do
        if used[id] then
            list[#list + 1] = id
        end
    end
    return list
end

function M.toggle()
    local w = hl.get_active_window()
    if not w then
        return
    end

    local range = active_range()

    local current = space_of(w)
    if current then
        -- salir: volver al workspace de origen y enfocarlo
        local target = origins[w.address] or range.home

        origins[w.address] = nil
        hl.dispatch(hl.dsp.window.move({ workspace = target }))
        hl.dispatch(hl.dsp.focus({ workspace = target }))
        return
    end

    -- entrar: primer espacio libre del monitor actual
    local used = occupied(range)
    local target
    for id = range.first, range.last do
        if not used[id] then
            target = id
            break
        end
    end
    if not target then
        return
    end

    origins[w.address] = w.workspace and w.workspace.id or range.home
    hl.dispatch(hl.dsp.window.move({ workspace = target }))
    hl.dispatch(hl.dsp.focus({ workspace = target }))
end

function M.cycle(dir)
    local range = active_range()
    local list = sorted_spaces(range, occupied(range))
    if #list == 0 then
        return
    end

    local current = hl.get_active_workspace()
    local current_id = current and current.id

    local pos = 0
    for i, id in ipairs(list) do
        if id == current_id then
            pos = i
        end
    end

    local next_pos = pos + dir
    if next_pos < 1 then
        next_pos = #list
    end
    if next_pos > #list then
        next_pos = 1
    end

    hl.dispatch(hl.dsp.focus({ workspace = list[next_pos] }))
end

return M
