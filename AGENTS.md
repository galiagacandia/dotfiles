# AGENTS.md — dotfiles de galiaga

Este repositorio **no es** `~/.config`: es el *source state* de chezmoi
(`~/.local/share/chezmoi`). Se despliega en `$HOME` con `chezmoi apply` y se
actualiza desde `$HOME` con `chezmoi re-add`.

Documentación de referencia: `README.md`, `CHANGELOG.md`, `docs/`.

---

## Regla de oro: se edita `$HOME`, no el repo

Los cambios se hacen **siempre** sobre el archivo real:

```bash
nvim ~/.config/hypr/bindings.lua     # correcto: surte efecto al instante
nvim dot_config/hypr/bindings.lua    # INCORRECTO: no llega a Hyprland hasta apply
```

Ciclo obligatorio después de editar:

```bash
chezmoi re-add            # $HOME -> repo
chezmoi verify            # debe decir "verify OK"
chezmoi diff              # debe estar vacío
```

Nunca se editan a mano los archivos con prefijos de chezmoi (`dot_`,
`executable_`, `private_`, `*.tmpl`) esperando que cambien el sistema.

---

## Validación de Hyprland (Lua)

La config es Lua modular desde la era 2. Antes de dar algo por bueno:

```bash
Hyprland --verify-config -c ~/.config/hypr/hyprland.lua   # debe decir "config ok"
hyprctl configerrors                                      # debe salir vacío
hyprctl -j binds | jq length                              # 62 en la era 2
```

- Cambiar de motor (`.conf` ↔ `.lua`) exige **reiniciar la sesión**; `hyprctl reload`
  no lo hace.
- `hyprctl dispatch` en modo Lua espera una expresión Lua:
  `hyprctl dispatch 'hl.dsp.exit()'`, no `hyprctl dispatch exit`.
- `hyprctl -j binds` reporta todos los binds como `dispatcher: "__lua"`.
- Una instancia anidada **no** sirve para probar teclas (el Hyprland anfitrión
  intercepta los `SUPER+…`); sí sirve para probar dispatchers con
  `hyprctl -i "<instancia>" dispatch '<expr>'`.
- Rollback: ver `docs/hyprland-lua.md` (3 pasos, sin borrar nada).

---

## Prohibiciones

- **No borrar ni renombrar** archivos sin permiso explícito del usuario.
- `~/.config/hypr/legacy/` es el respaldo de los `.conf`: no se toca.
- `hyprpaper.conf` y `hyprlauncher.conf` **no** son configuración de Hyprland.
- No commitear secretos, llaves ni passphrases.
- No hacer `chezmoi apply` sin revisar antes `chezmoi diff`.
- No crear ramas nuevas sin pedirlo: el trabajo va a `pulido-entorno`.

---

## Git, commits y eras

- Rama de trabajo: `pulido-entorno`.
- Commits **en español**, uno por cambio lógico, con el porqué en el cuerpo.
- Mensajes: `hypr: ...`, `docs: ...`, `chore: ...`, `fix: ...`.
- Tags de era: `vN-AAAA-MM-DD` (fecha de creación), anotados e inmutables.
- Toda era actualiza `CHANGELOG.md` **antes** de crear su tag.
- Tags publicados no se mueven: si algo cambia, se crea otra era.
- **`main` está congelada en `v1-2026-10-27`** y solo recibe trabajo cuando el
  pulido del entorno esté terminado. Las eras intermedias se taggean sobre
  `pulido-entorno` (así está `v2-2026-10-27`); no se fusionan a `main` una por una.

---

## Documentación obligatoria

- `README.md`: qué contiene el repo, instalación, uso diario, tabla de eras.
- `CHANGELOG.md`: sección por era con Añadido / Cambiado / Eliminado / Notas, y
  una sección final "Pendiente (futura era)" para lo no aplicado.
- `docs/`: guías por tema (`chezmoi-comandos.md`, `hyprland-lua.md`, …).
- Los tres están en `.chezmoiignore` para que no se desplieguen a `$HOME`.

---

## Memoria persistente (engram)

Servidor MCP configurado en `opencode.json` con proyecto `dotfiles`
(`~/.engram/engram.db`).

- **Al empezar**: `mem_current_project` y `mem_context` (o `mem_search`) antes de
  tocar nada.
- **Al cerrar** o al terminar algo significativo: `mem_save` con el porqué, no
  solo el qué. Tipos usados: `decision`, `bugfix`, `pattern`, `architecture`.
- Guardar: decisiones con su motivo, hallazgos verificados, trampas y comandos
  exactos. No guardar: contenido de archivos que ya está en git ni secretos.
- Los pendientes viven en `CHANGELOG.md`; la memoria no es el backlog.

---

## Estructura útil

```
dot_config/hypr/            hyprland.lua (disparador) + main.lua + secciones .lua
dot_config/hypr/legacy/     .conf originales (respaldo, inertes)
dot_config/waybar/          config + style.css
dot_config/nvim/            LazyVim
docs/                       guías (ignoradas por chezmoi)
opencode.json               config de OpenCode para este repo (ignorada)
.chezmoiignore              patrones que no se despliegan
```
