# Caelestia — escritorio (era 3)

Caelestia es una shell para Hyprland construida sobre Quickshell. Sustituye a
waybar, dunst, walker/elephant, wlogout e hyprpaper en una sola pieza: barra,
launcher, dashboard, notificaciones, OSD, menú de sesión, bloqueo y fondo.

Config: `~/.config/caelestia/shell.json` (solo las claves que difieren de los
valores por defecto). El resto de lo que no se usa vive en `legacy/`.

---

## Instalación (sin AUR)

Se compiló desde código auditado con los PKGBUILDs **oficiales de AUR, sin
modificar**, fijando versión o commit. Clones en `~/AURTest/caelestia/aur/`.

| Paquete | Origen fijado |
|---|---|
| `libcava` | `LukashonakV/cava` 1.0.0 (`options=(!lto)`) |
| `ttf-rubik-vf` | `googlefonts/rubik` commit `e337a5f` |
| `qt6-m3shapes-git` | `soramanew/m3shapes`, requerido por la barra (`import M3Shapes`) |
| `python-materialyoucolor` | dependencia del CLI |
| `quickshell-git` | runtime; el tag 0.3.2 no basta para Caelestia 2.5.0 |
| `caelestia-cli` | CLI de control |
| `caelestia-shell` | 2.5.0 |

Auditoría del build: sin binarios commiteados, sin telemetría, sin `sudo` ni
`setuid` en lo instalado. Los únicos `execute_process` son `git describe`, un
symlink `qs→quickshell` y codegen de protocolos Wayland. `quickshell-git` instala
un hook de pacman que ejecuta `quickshell --private-check-compat` tras actualizar
Qt6 (inofensivo).

**No ejecutar** `caelestia install` ni `caelestia update`: instalan los dotfiles
upstream y sobrescriben `~/.config/hypr`.

---

## Configuración aplicada

| Área | Valor |
|---|---|
| Barra | vertical izquierda, números de workspace + iconos de ventana, 5 por monitor |
| Clima | ubicación fija `La Paz` (nunca `ip-api.com`) |
| Bloqueo | PAM a los 10 min, sin huella ni cara (`fprintd`/`howdy` no instalados) |
| Pantallas | apagado a los 15 min; **sin** suspensión automática |
| Fondo | propio de Caelestia, `~/Pictures` como carpeta de wallpapers |
| Apps | terminal `ghostty -e`, explorador `dolphin`, reproducción `mpv`, audio `pavucontrol` |
| Idle/lock | `lockBeforeSleep: true` |

La shell se arranca desde `autostart.lua` con `caelestia shell -d`.

---

## Atajos

| Atajo | Acción |
|---|---|
| `SUPER` (toque) / `SUPER+Space` | launcher |
| `SUPER+Esc` | menú de sesión |
| `SUPER+D` | dashboard |
| `SUPER+N` | sidebar de notificaciones |
| `SUPER+U` | utilidades / quick toggles |
| `SUPER+CTRL+K` | mostrar/ocultar paneles |
| `SUPER+CTRL+L` | bloquear |
| `SUPER+CTRL+R` | reiniciar la shell |
| `SUPER+V` | historial de portapapeles |
| `SUPER+.` | emojis |
| `CTRL+ALT+C` | limpiar notificaciones |
| `Print` | captura de región |

`SUPER+L`, `SUPER+K` y `SUPER+ALT+L` siguen reservados a foco y grupos.

---

## Trampas conocidas

1. **`caelestia shell -r` se cuelga**: mata la shell y no la relanza. Usar:
   `caelestia shell -k; caelestia shell -d; sleep 3; hyprctl reload`.
2. **Cada arranque deja 2 binds huérfanos** (`Caps_Lock`, `Num_Lock`); el
   `hyprctl reload` los limpia.
3. **Terminales**: Caelestia concatena argumentos
   (`[terminal, wrap_term_launch.sh, ...]`), así que `ghostty` necesita `-e` en
   `general.apps.terminal`. Si falta, ghostty interpreta el script como config y
   muestra «Configuration Errors».
4. **`wrap_term_launch.sh`** inyecta la paleta actual (OSC 10/11/12/4) en la
   terminal nueva y luego hace `exec "$@"`. Los terminales ya abiertos los
   recolorea `caelestia` escribiendo en cada `/dev/pts/N`.
5. **Memoria**: ~700 MiB PSS con fondo y visualizador activos, frente a 34 MiB de
   waybar + dunst. Palancas: visualizador, fondo propio, barra en un solo monitor.

---

## Espacios tipo macOS (`spaces.lua`)

`SUPER+F` convierte la ventana activa en un espacio: la mueve a un workspace
dedicado, la pone en **fullscreen** y te lleva a él. Otra pulsación la devuelve
a su workspace original.

| Atajo | Acción |
|---|---|
| `SUPER+F` | crear o cerrar el espacio de la ventana activa |
| `SUPER+CTRL+←/→` | recorrer la secuencia del monitor (workspaces + espacios) |

Secuencia por monitor:

```
DP-1:  1 → 2 → 3 → 4 → 5 → 11 → 12 → 13 → 14 → 15 → 1
DP-2:  6 → 7 → 8 → 9 → 10 → 16 → 17 → 18 → 19 → 20 → 6
```

Detalles:

- Se usan **workspaces reales**, no *special workspaces*: en Hyprland 0.57 los
  special tienen `id: null` y la barra de Caelestia los indexa por id.
- Cinco espacios por monitor con reglas en `workspace.lua` (11–15 / 16–20).
- La ventana va en **fullscreen real** (`fullscreen = 2`), así Caelestia oculta
  la barra igual que macOS oculta la barra de menús. Ese es el efecto de
  «pantalla nueva».
- Como la barra desaparece, al entrar o cambiar de espacio se muestra un
  **toast** con el número (`toaster info "Espacio N"`).
- Los espacios vacíos se saltan al navegar.
- El workspace de origen se recuerda en memoria por dirección de ventana; si se
  recarga Hyprland, al salir se vuelve al workspace base del monitor (1 o 6).
- `Ctrl+←/→` no se usa a propósito: rompería la navegación por palabras en
  terminales y editores.

## Rollback

Volver a la pila de la era 2:

```bash
pkill -x qs
sudo pacman -S --needed waybar dunst hyprpaper wlogout satty walker
cp -r "$(chezmoi source-path)/legacy/config/waybar"  ~/.config/waybar
cp -r "$(chezmoi source-path)/legacy/config/wlogout" ~/.config/wlogout
cp    "$(chezmoi source-path)/legacy/config/hypr/hyprpaper.conf" ~/.config/hypr/
waybar & dunst & hyprpaper -c ~/.config/hypr/hyprpaper.conf &
```

Y en `~/.config/hypr/autostart.lua`: comentar `caelestia shell -d` y descomentar
las líneas de respaldo.

Volver a la era 2 completa: `git switch --detach v2-2026-10-27 && chezmoi apply`.

---

## Recursos

| Métrica | 120 Hz | 60 Hz |
|---|---|---|
| GPU (RTX 4070 SUPER) | 42 % a ~400 MHz | 25 % a ~211 MHz |
| Potencia | 18,6 W | 13,7 W |
| CPU Hyprland | 23 % | 12 % |

La carga era del compositor dibujando 6000×1440, no de procesos concretos.
