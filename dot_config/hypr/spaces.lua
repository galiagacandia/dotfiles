-- =====================================================================
-- spaces.lua — "espacios" tipo macOS con workspaces dedicados
--
-- SUPER+F          crea/cierra un espacio para la ventana activa
-- SUPER+CTRL+left  anterior en la secuencia del monitor
-- SUPER+CTRL+right siguiente en la secuencia del monitor
--
-- Reparto por monitor (5 por monitor):
--   DP-1 -> normales 1..5   + espacios 11..15
--   DP-2 -> normales 6..10  + espacios 16..20
-- Las reglas de monitor viven en workspace.lua.
--
-- Un espacio es un workspace real con la ventana en fullscreen: asi la
-- barra de Caelestia se oculta (fullscreen > 1) y se comporta como los
-- Spaces de macOS. Como la barra desaparece, al entrar o cambiar de
-- espacio se muestra un toast con el numero.
--
-- Se usan workspaces reales (no special) porque la barra de Caelestia
-- indexa los special por id y en Hyprland 0.57 tienen id nulo.
-- =====================================================================

local M = {}

local RANGES = {
    { monitor = "DP-1", home = 1, first = 11, last = 15 },
    { monitor = "DP-2", home = 6, first = 16, last = 20 },
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

-- Secuencia del monitor: workspaces normales + espacios ocupados
local function monitor_slots(range)
    local list = {}
    for id = range.home, range.home + 4 do
        list[#list + 1] = id
    end

    local used = occupied(range)
    for id = range.first, range.last do
        if used[id] then
            list[#list + 1] = id
        end
    end
    return list
end

local function toast(id)
    hl.exec_cmd('qs -c caelestia ipc call toaster info "Espacio ' .. id .. '" "" ""')
end

function M.toggle()
    local w = hl.get_active_window()
    if not w then
        return
    end

    local range = active_range()

    local current = space_of(w)
    if current then
        -- salir: quitar fullscreen, volver al origen y enfocarlo
        local target = origins[w.address] or range.home

        origins[w.address] = nil
        if w.fullscreen > 1 then
            hl.dispatch(hl.dsp.window.fullscreen())
        end
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

    -- fullscreen real: la barra se oculta y queda como un Space de macOS
    if w.fullscreen == 0 then
        hl.dispatch(hl.dsp.window.fullscreen())
    end

    toast(target)
end

function M.navigate(dir)
    local range = active_range()
    local list = monitor_slots(range)

    local current = hl.get_active_workspace()
    local current_id = current and current.id

    local pos
    for i, id in ipairs(list) do
        if id == current_id then
            pos = i
            break
        end
    end

    if not pos then
        hl.dispatch(hl.dsp.focus({ workspace = list[1] }))
        return
    end

    local next_pos = pos + dir
    if next_pos < 1 then
        next_pos = #list
    end
    if next_pos > #list then
        next_pos = 1
    end

    local target = list[next_pos]
    hl.dispatch(hl.dsp.focus({ workspace = target }))

    if in_any_range(target) then
        toast(target)
    end
end

return M
