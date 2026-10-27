# dotfiles — galiaga

Configuración personal de mi entorno Linux, gestionada con
[chezmoi](https://www.chezmoi.io/) sobre Wayland + Hyprland.

> **Importante:** este repositorio **no** es `~/.config`. Es el *source state* de
> chezmoi, que vive en `~/.local/share/chezmoi` y se despliega en `$HOME` con
> `chezmoi apply`. No editar aquí a mano salvo para commits.

---

## Contenido

| Área | Qué incluye |
|---|---|
| Hyprland | `hyprland.conf` + `monitors`, `input`, `bindings`, `looknfeel`, `autostart`, `workspace`, `windowrules`, `envs`, `hyprpaper` |
| Waybar | `config` + `style.css` (workspaces 1-5 en DP-1, 6-10 en DP-2) |
| Neovim | LazyVim con extras (dap, neo-tree, java, markdown, terraform, project) |
| wlogout | layout, iconos y css |
| mpd / ncmpcpp | config + playlists de radios |
| satty | `config.toml` |
| Shell / git | `.bashrc`, `.bash_profile`, `.gitconfig` |

Los archivos del repo llevan prefijos de chezmoi: `dot_` → `.` (`dot_bashrc` →
`~/.bashrc`), `executable_` → permiso `+x`, `private_` → `0600`.

---

## Instalación en un equipo nuevo

Requisitos: `chezmoi` y una llave SSH con acceso a este repo.

```bash
# Arch / CachyOS
sudo pacman -S chezmoi

# bootstrap: clona en ~/.local/share/chezmoi y aplica en $HOME
chezmoi init --apply git@github.com:galiagacandia/dotfiles.git
```

Traer cambios en una máquina ya configurada:

```bash
chezmoi update      # git pull + apply
```

---

## Uso diario

```bash
# 1. editar el config real, como siempre
#    (~/.config/hypr/bindings.conf, ~/.config/waybar/config, ...)

chezmoi status      # qué está desfasado
chezmoi diff        # qué haría apply
chezmoi re-add      # guardar mis ediciones en el repo
chezmoi add <ruta>  # empezar a versionar algo nuevo

chezmoi cd && git commit -am "..." && git push
```

Regla de oro: `apply` escribe en `$HOME`; `re-add` escribe en el repo. Son inversos.

---

## Eras (tags)

Cada era es un tag inmutable `vN-AAAA-MM-DD`:

| Era | Tag | Descripción |
|---|---|---|
| 0 | `v0-2026-06-22` | configuración base importada al repo |
| 1 | `v1-2026-10-27` | estado real antes del pulido |
| 2 | `v2-AAAA-MM-DD` | entorno pulido (rama `pulido-entorno`) |

Usar una era antigua:

```bash
cd "$(chezmoi source-path)"
git switch --detach v1-2026-10-27
chezmoi diff && chezmoi apply     # aplicar esa era

git switch main && chezmoi apply  # volver a la actualidad
```

Detalle de cada era en [`CHANGELOG.md`](CHANGELOG.md). Guía completa de comandos en
[`docs/chezmoi-comandos.md`](docs/chezmoi-comandos.md).

---

## Acceso SSH (llave con passphrase)

La llave `~/.ssh/id_ed25519` tiene passphrase y **no se guarda en ningún archivo del
repo**. Para poder hacer `push`/`pull` sin escribirla en cada operación se usa el
agente, con una caducidad explícita:

```bash
systemctl --user start ssh-agent.socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
ssh-add -t 2h ~/.ssh/id_ed25519     # pide la passphrase una vez

ssh-add -l                          # verificar
ssh -T git@github.com               # "Hi galiagacandia!"
```

Mientras la llave esté cargada, cualquier proceso del usuario puede usarla indicando
el socket por ruta fija (no hereda variables de otra terminal):

```bash
SSH_AUTH_SOCK=/run/user/1000/ssh-agent.socket git push
```

Revocar:

```bash
ssh-add -D                          # vaciar el agente
systemctl --user stop ssh-agent.socket
```

Al cerrar sesión se revoca solo: el socket vive en `/run/user/1000` (tmpfs).

**Nunca** poner la passphrase en `.bashrc`, `.zshrc`, `environment.d` ni en un archivo
del repo. Si se filtró, rotarla: `ssh-keygen -p -f ~/.ssh/id_ed25519`.

---

## Archivos especiales de este repo

`.chezmoiignore` evita que la documentación se copie a `$HOME` (sin él, `README.md`
se convertiría en `~/README.md` al aplicar):

```
README.md
CHANGELOG.md
docs/
```
