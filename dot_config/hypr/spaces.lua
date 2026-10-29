-- =====================================================================
-- spaces.lua — "espacios" tipo macOS sobre special workspaces
--
-- SUPER+F          crea/cierra un espacio para la ventana activa
-- SUPER+ALT+left   espacio anterior
-- SUPER+ALT+right  espacio siguiente
--
-- Cada espacio es un special workspace llamado special:space1..space9.
-- No se guarda estado en disco: los espacios ocupados se deducen de las
-- ventanas abiertas. Solo se recuerda el workspace de origen (en memoria)
-- para devolver la ventana al salir.
-- =====================================================================

local M = {}

local PREFIX = "space"
local MAX = 9

-- address de ventana -> id del workspace donde estaba antes de ser espacio
local origins = {}

local function index_of(window)
    local ws = window and window.workspace
    if not ws or not ws.name then
        return nil
    end
    return tonumber(ws.name:match("^special:" .. PREFIX .. "(%d+)$") or "")
end

local function occupied()
    local used = {}
    for _, w in ipairs(hl.get_windows()) do
        local n = index_of(w)
        if n then
            used[n] = true
        end
    end
    return used
end

local function sorted_spaces(used)
    local list = {}
    for i = 1, MAX do
        if used[i] then
            list[#list + 1] = i
        end
    end
    return list
end

-- Crea o destruye el espacio de la ventana activa.
function M.toggle()
    local w = hl.get_active_window()
    if not w then
        return
    end

    local current = index_of(w)

    if current then
        -- Salir del espacio: ocultarlo, devolver la ventana y enfocarla
        hl.dispatch(hl.dsp.workspace.toggle_special(PREFIX .. current))

        local origin = origins[w.address] or hl.get_active_workspace()
        local target = origin and origin.id or 1

        if w.fullscreen > 0 then
            hl.dispatch(hl.dsp.window.fullscreen())
        end
        hl.dispatch(hl.dsp.window.move({ workspace = target }))
        hl.dispatch(hl.dsp.focus({ workspace = target }))

        origins[w.address] = nil
        return
    end

    -- Crear espacio: buscar el primer number libre
    local used = occupied()
    local target
    for i = 1, MAX do
        if not used[i] then
            target = i
            break
        end
    end
    if not target then
        return
    end

    origins[w.address] = w.workspace and w.workspace.id or nil

    hl.dispatch(hl.dsp.window.move({ workspace = "special:" .. PREFIX .. target }))
    hl.dispatch(hl.dsp.workspace.toggle_special(PREFIX .. target))

    if w.fullscreen == 0 then
        hl.dispatch(hl.dsp.window.fullscreen())
    end
end

-- Cicla entre los espacios ocupados. dir = -1 anterior, 1 siguiente.
function M.cycle(dir)
    local list = sorted_spaces(occupied())
    if #list == 0 then
        return
    end

    local current = hl.get_active_special_workspace()
    local current_index
    if current and current.name then
        current_index = tonumber(current.name:match("^special:" .. PREFIX .. "(%d+)$") or "")
    end

    local pos = 0
    for i, n in ipairs(list) do
        if n == current_index then
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

    if current_index then
        hl.dispatch(hl.dsp.workspace.toggle_special(PREFIX .. current_index))
    end
    hl.dispatch(hl.dsp.workspace.toggle_special(PREFIX .. list[next_pos]))
end

return M
