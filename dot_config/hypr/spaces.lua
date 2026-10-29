-- =====================================================================
-- spaces.lua — "espacios" tipo macOS con workspaces dedicados
--
-- SUPER+F          crea/cierra un espacio para la ventana activa
-- SUPER+ALT+left   espacio anterior
-- SUPER+ALT+right  espacio siguiente
--
-- Los espacios son workspaces reales 11..15. Se usan ids reales (no
-- special workspaces) porque la barra de Caelestia indexa por id y los
-- special tienen id nulo en Hyprland 0.57: no se podrian mostrar.
--
-- La barra pagina en grupos de 5, asi que al entrar en el 11 muestra
-- 11..15 con el activo resaltado.
--
-- Sin estado persistente: los espacios ocupados se deducen de las
-- ventanas. Solo se recuerda el workspace de origen (en memoria) para
-- devolver la ventana al salir.
-- =====================================================================

local M = {}

local FIRST = 11
local LAST = 15

-- address de ventana -> id del workspace donde estaba antes
local origins = {}

local function is_space(id)
    return id and id >= FIRST and id <= LAST
end

local function space_of(window)
    local ws = window and window.workspace
    if not ws then
        return nil
    end
    return is_space(ws.id) and ws.id or nil
end

local function occupied()
    local used = {}
    for _, w in ipairs(hl.get_windows()) do
        local id = space_of(w)
        if id then
            used[id] = true
        end
    end
    return used
end

local function sorted_spaces(used)
    local list = {}
    for id = FIRST, LAST do
        if used[id] then
            list[#list + 1] = id
        end
    end
    return list
end

-- Workspace real debajo del special/monitor actual (nunca el special).
local function fallback_workspace()
    local monitor = hl.get_active_monitor()
    local ws = monitor and monitor.active_workspace
    if ws and ws.id and not is_space(ws.id) then
        return ws.id
    end
    return 1
end

function M.toggle()
    local w = hl.get_active_window()
    if not w then
        return
    end

    local current = space_of(w)
    if current then
        -- salir: volver al workspace de origen y enfocarlo
        local target = origins[w.address] or fallback_workspace()

        origins[w.address] = nil
        hl.dispatch(hl.dsp.window.move({ workspace = target }))
        hl.dispatch(hl.dsp.focus({ workspace = target }))
        return
    end

    -- entrar: primer espacio libre
    local used = occupied()
    local target
    for id = FIRST, LAST do
        if not used[id] then
            target = id
            break
        end
    end
    if not target then
        return
    end

    origins[w.address] = w.workspace and w.workspace.id or fallback_workspace()
    hl.dispatch(hl.dsp.window.move({ workspace = target }))
    hl.dispatch(hl.dsp.focus({ workspace = target }))
end

function M.cycle(dir)
    local list = sorted_spaces(occupied())
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
