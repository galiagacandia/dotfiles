# Hyprland en Lua — estructura, operación y rollback

Desde la era 2 (`v2-2026-10-27`) la configuración de Hyprland es **Lua modular**.
Los `.conf` originales siguen en el repo, intactos, dentro de
`dot_config/hypr/legacy/`, como respaldo.

Contexto: `hyprlang` está deprecado desde Hyprland 0.55 a favor de Lua. La 0.56
todavía acepta `.conf`, pero avisa en el login de que dejará de hacerlo.

---

## Cómo elige Hyprland el motor

| Archivo presente | Motor |
|---|---|
| `~/.config/hypr/hyprland.lua` | **Lua** (tiene prioridad) |
| solo `~/.config/hypr/hyprland.conf` | legacy (`hyprlang`) |

`~/.config/hypr/hyprland.lua` es solo un disparador de una línea:

```lua
require("main")
```

**Cambiar de motor exige reiniciar la sesión.** `hyprctl reload` vuelve a leer la
configuración, pero no cambia de gestor.

---

## Estructura

```
~/.config/hypr/
├── hyprland.lua      disparador: require("main")
├── main.lua          cuerpo: require de las secciones
├── monitors.lua      hl.monitor(...)
├── workspace.lua     hl.workspace_rule(...)
├── input.lua         hl.config{ input = ... } + 2 window rules inline
├── windowrules.lua   hl.window_rule(...)
├── looknfeel.lua     hl.config{ general/decoration/animations/group }, hl.curve, hl.animation
├── autostart.lua     hl.on("hyprland.start", ...) + hl.exec_cmd(...)
├── bindings.lua      62 binds activos (+50 comentados traducidos)
├── envs.lua          traducido pero NO cargado (ver más abajo)
├── hyprpaper.conf    sigue siendo del programa hyprpaper, no de Hyprland
├── hyprlauncher.conf config de hyprlauncher, no de Hyprland
└── legacy/           .conf originales, inertes, como respaldo
```

### `require()` en vez de `source`

`source` no existe en el motor Lua. La modularidad se hace con `require()`:

- Resuelve **relativo al directorio del config principal**
  (`package.path` incluye `<configDir>/?.lua` y `<configDir>/?/init.lua`).
- Hyprland **trackea** los archivos requeridos: editarlos dispara el auto-reload.
- `dofile()` carga el archivo pero **no** lo trackea: no usarlo.

Los `require` del `main.lua` son:

```lua
require("monitors")
require("input")
require("bindings")
require("looknfeel")
require("autostart")
require("workspace")
require("windowrules")
```

### `envs.lua` no se carga (a propósito)

`envs.conf` nunca estuvo incluido en los `source` de `hyprland.conf`, así que sus
variables (`NVD_BACKEND`, `LIBVA_DRIVER_NAME`, `__GLX_VENDOR_LIBRARY_NAME`, `XDG_*`)
**no formaban parte de la configuración activa**. Se tradujeron a `envs.lua` para
tenerlas listas, sin cambiar el comportamiento. Para activarlas:

```lua
-- en main.lua
require("envs")
```

y reiniciar la sesión (las variables de entorno se leen al arrancar).

---

## Ciclo de trabajo

```bash
# 1. editar la sección que corresponda, p. ej.
#    ~/.config/hypr/bindings.lua

# 2. validar ANTES de recargar (no arranca nada, solo parsea)
Hyprland --verify-config -c ~/.config/hypr/hyprland.lua

# 3. recargar (mismo motor)
hyprctl reload

# 4. comprobar que no hubo errores
hyprctl configerrors
```

Si un error de Lua deja la sesión con 0 binds, Hyprland entra en modo emergencia
(solo `SUPER+Q`). Por eso se valida primero con `--verify-config`.

---

## Comprobaciones útiles

```bash
hyprctl configerrors                      # vacío = sin errores
hyprctl -j binds | jq length              # 62 en la era 2
hyprctl -j monitors | jq -r '.[] | "\(.name) \(.width)x\(.height)@\(.refreshRate)"'
hyprctl animations                        # curvas y animaciones activas
hyprctl systeminfo                        # versión, backend, etc.
```

---

## Rollback al `.conf` (3 pasos)

Los `.conf` están en `~/.config/hypr/legacy/` y `hyprland.conf` usa rutas absolutas
`source = ~/.config/hypr/<seccion>.conf`, así que hay que devolverlos a su sitio:

```bash
mv ~/.config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua.off
mv ~/.config/hypr/legacy/*.conf ~/.config/hypr/
chezmoi forget ~/.config/hypr/hyprland.lua   # para que apply no lo recree
```

Cerrar sesión y volver a entrar: arranca con `hyprland.conf`.
No se borra nada; `hyprland.lua.off` queda ahí.

Si solo quieres **desactivar** Lua un rato sin tocar el repo, basta el primer `mv`
mientras no corras `chezmoi apply`.

---

## Trampas conocidas (verificadas)

1. **`hyprctl dispatch` en modo Lua espera una expresión Lua**, no un dispatcher
   legacy. `hyprctl dispatch exit` falla; lo correcto es:

   ```bash
   hyprctl dispatch 'hl.dsp.exit()'
   ```

   Los binds que llaman a `hyprctl reload` por shell (`SUPER+SHIFT+R`) no se ven
   afectados.

2. **`hyprctl -j binds` expone todos los binds como `dispatcher: "__lua"`** con un
   id numérico interno, no como `movefocus`, `exec`, etc. Sigue sirviendo para
   auditar teclas, modificadores y descripciones; ya no para auditar dispatchers.

3. **Una instancia anidada no sirve para probar teclas**: el Hyprland anfitrión se
   queda con las combinaciones que él mismo tiene bindeadas y no las reenvía al
   cliente. Para validar dispatchers se puede usar
   `hyprctl -i "<instancia>" dispatch '<expr>'`; para validar teclado, la sesión real.

4. **`hyprpaper.conf` y `hyprlauncher.conf` no son de Hyprland**: no se mueven ni se
   convierten. `autostart.lua` invoca `hyprpaper -c ~/.config/hypr/hyprpaper.conf`.

---

## Paridad con la era 1 (medida al migrar)

| Comprobación | Resultado |
|---|---|
| `--verify-config` | `config ok` |
| `configerrors` | vacío |
| Binds | 62/62, mismas teclas, modificadores y descripciones |
| Opciones muestreadas | 19/19 idénticas |
| Animaciones | idénticas |
| Monitores | DP-1 3440x1440@120 en 2560,0 · DP-2 2560x1440 en 0,0 |
| Workspaces | 1→DP-1 … 5→DP-1, 6→DP-2 … 10→DP-2 |
| Autostart | polkit-kde, waybar, hyprpaper, dunst, elephant, walker |
