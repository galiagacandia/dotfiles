# legacy/ — configuración que ya no se usa

Archivo histórico dentro del repositorio. **No se despliega**: `legacy/` está en
`.chezmoiignore`, así que `chezmoi apply` no copia nada de aquí a `$HOME`.

Contiene lo que quedó fuera de uso al adoptar Caelestia como escritorio (era 3).

| Carpeta | Qué era | Sustituido por |
|---|---|---|
| `config/waybar/` | barra de estado (`config` + `style.css`) | barra de Caelestia |
| `config/wlogout/` | menú de sesión (layout, iconos, css) | menú de sesión de Caelestia (`SUPER+Esc`) |
| `config/satty/` | editor de capturas (grim + satty) | `caelestia screenshot` (swappy) |
| `config/hypr/hyprpaper.conf` | fondos con hyprpaper | fondo de Caelestia |
| `config/hypr/legacy/` | los 9 `.conf` de la era hyprlang | config Lua (`hyprland.lua` + secciones) |

---

## Restaurar waybar + dunst + hyprpaper

```bash
cp -r "$(chezmoi source-path)/legacy/config/waybar"  ~/.config/waybar
cp -r "$(chezmoi source-path)/legacy/config/wlogout" ~/.config/wlogout
cp    "$(chezmoi source-path)/legacy/config/hypr/hyprpaper.conf" ~/.config/hypr/
waybar &
dunst &
hyprpaper -c ~/.config/hypr/hyprpaper.conf &
```

Y para que vuelvan en el próximo login, editar `~/.config/hypr/autostart.lua`:
comentar `caelestia shell -d` y descomentar las líneas de respaldo que ya están
ahí (`waybar`, `hyprpaper`, `dunst`, `elephant`, `walker`).

## Restaurar satty

```bash
cp -r "$(chezmoi source-path)/legacy/config/satty" ~/.config/satty
```

## Volver al motor hyprlang (`.conf`)

Los `.conf` usan rutas absolutas `source = ~/.config/hypr/<seccion>.conf`, así que
hay que devolverlos a su sitio junto con `hyprland.conf`:

```bash
cp "$(chezmoi source-path)"/legacy/config/hypr/legacy/*.conf ~/.config/hypr/
mv ~/.config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua.off
chezmoi forget ~/.config/hypr/hyprland.lua   # evitar que apply lo recree
```

Cerrar sesión y volver a entrar.

## Volver a la era 2 completa (git)

```bash
cd "$(chezmoi source-path)"
git switch --detach v2-2026-10-27
chezmoi diff && chezmoi apply
```

Los tags son inmutables: para seguir trabajando desde ahí, crear una rama
(`git switch -c prueba-v2 v2-2026-10-27`).
