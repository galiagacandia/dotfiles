# Chezmoi — guía de comandos y eras (dotfiles de galiaga)

Documento de referencia. Cubre: instalación, los tres lugares de chezmoi, ciclo diario,
tags (eras), ramas, sincronización con GitHub y recuperación de desastres.

Repositorio: `git@github.com:galiagacandia/dotfiles.git`
Source (repo local): `~/.local/share/chezmoi`
Destino: `/home/galiaga`
Config: no existe `~/.config/chezmoi/chezmoi.toml` (todo por defecto)

---

## 1. Los tres lugares

```
~/.local/share/chezmoi     <- EL REPO (source). Clon de GitHub. Aquí manda git.
        |  apply  ->  (escribe en $HOME)
        |  <-  re-add  (lee de $HOME)
/home/galiaga              <- LA REALIDAD. Los archivos que leen las apps.
~/.config/chezmoi/         <- estado interno de chezmoi (boltdb), no versionado.
```

Regla de oro: **`apply` escribe en tu `$HOME`; `re-add` escribe en el repo.**
Son inversos. `status`, `diff`, `managed`, `doctor` no escriben nada.

En el repo los archivos llevan prefijos:

| Prefijo | Resultado |
|---|---|
| `dot_` | se convierte en `.` (`dot_bashrc` -> `~/.bashrc`) |
| `executable_` | añade permiso +x |
| `private_` | permisos 600 |
| `exact_` | la carpeta se replica exacta (BORRA lo que sobre) |
| `*.tmpl` | plantilla (no usamos) |

---

## 2. Instalación

Arch / CachyOS:

```bash
sudo pacman -S chezmoi
chezmoi --version
```

Otras opciones:

```bash
# script oficial
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
# go
go install github.com/twpayne/chezmoi/v2@latest
# mac
brew install chezmoi
```

### Equipo nuevo (o después de formatear)

Requiere una llave SSH con acceso al repo:

```bash
ssh-keygen -t ed25519 -C "tu@correo"     # si no tienes
cat ~/.ssh/id_ed25519.pub                # subirla a GitHub > Settings > SSH keys
ssh -T git@github.com                    # debe saludarte

chezmoi init --apply git@github.com:galiagacandia/dotfiles.git
```

`init` clona el repo en `~/.local/share/chezmoi` y `--apply` lo despliega en `$HOME`.

Si el source ya existe y solo quieres traer cambios:

```bash
chezmoi update      # git pull + apply
```

Alternativa manual (sin `init`):

```bash
git clone git@github.com:galiagacandia/dotfiles.git ~/.local/share/chezmoi
chezmoi apply
```

---

## 3. Ciclo diario

```bash
# 1. editas ~/.config/lo-que-sea normalmente (con tu editor de siempre)

# 2. comparar
chezmoi status          # 2 columnas: ver sección 7
chezmoi diff            # diff textual (qué haría apply)

# 3. guardar en el repo
chezmoi re-add                            # todos los archivos ya gestionados que cambiaron
chezmoi re-add ~/.config/hypr/input.conf  # o solo uno
chezmoi add ~/.config/mi-app/config       # archivo NUEVO que quieres versionar

# 4. commit + push
chezmoi cd                      # abre un shell dentro del repo
git add -A && git commit -m "..."
git push
```

Atajo: `chezmoi push` = add + commit + push de todo el source.
Con la llave protegida por passphrase, `git push` pedirá la passphrase.

Otros útiles:

```bash
chezmoi managed      # qué archivos gestiona (absolutos con --path-style absolute)
chezmoi unmanaged    # qué hay en $HOME que NO gestiona
chezmoi doctor       # chequeo de salud
chezmoi source-path  # ruta del repo
chezmoi target-path dot_config/hypr/input.conf   # ruta destino de un archivo del source
chezmoi forget ~/.config/algo                    # dejar de gestionar (no borra el archivo)
```

Peligrosos:

```bash
chezmoi apply      # escribe en $HOME (lo normal, pero revisa diff antes)
chezmoi destroy    # borra del repo Y del $HOME
chezmoi purge      # borra toda la config y datos de chezmoi
```

---

## 4. Tags = las "eras"

Convención: `vN-AAAA-MM-DD`. Un tag es un nombre **inmutable** pegado a un commit.
Nunca se mueve; si te equivocas, se crea otro tag nuevo.

| Tag | Commit | Significado |
|---|---|---|
| `v0-2026-06-22` | `e20148f` | Era 0: lo que ya estaba en el repo (junio) |
| `v1-2026-10-27` | (snapshot octubre) | Era 1: estado real antes del pulido |
| `v2-AAAA-MM-DD` | (futuro) | Era 2: entorno pulido, creado al fusionar la rama |

### Crear

```bash
cd "$(chezmoi source-path)"

# tag anotado sobre el commit actual
git tag -a v2-2026-12-01 -m "Era 2: entorno pulido"

# tag anotado sobre un commit concreto
git tag -a v0-2026-06-22 -m "Era 0" e20148f

# tag ligero (sin mensaje ni fecha propia) -- no recomendado
git tag v2-2026-12-01
```

### Listar y ver

```bash
git tag -l                    # lista
git tag -n1                   # lista + primera línea del mensaje
git tag -n99 -l 'v1-*'         # mensaje completo de los v1
git show v1-2026-10-27        # commit + mensaje del tag
git log --oneline --decorate --all   # historia con tags y ramas
```

Comparar dos eras:

```bash
git diff --stat v0-2026-06-22 v1-2026-10-27
git diff v0-2026-06-22 v1-2026-10-27 -- dot_config/hypr/
```

Ver un archivo de una era sin cambiar nada:

```bash
git show v1-2026-10-27:dot_config/hypr/input.conf
```

### Cargar / restaurar una era en el $HOME

Esto es lo importante: un tag inmutable no se "activa", se hace checkout de su commit
y luego se aplica. Ojo: el checkout deja HEAD desacoplado (detached).

```bash
cd "$(chezmoi source-path)"
git status                    # debe estar limpio; si no, commit o stash primero
git switch --detach v1-2026-10-27

chezmoi diff                  # revisa qué cambiaría en tu $HOME
chezmoi apply                 # aplica ESA era al sistema

# ... probar, mirar, romper lo que quieras ...

# volver a la actualidad
git switch main
chezmoi apply
```

Reglas mientras estás en un tag:

- **No** hagas `re-add` ni `add` estando desacoplado: crearías commits huérfanos.
- `chezmoi update` no funciona en detached HEAD.
- Si quieres trabajar *desde* una era antigua, crea una rama:
  `git switch -c prueba-v1 v1-2026-10-27`

### Subir y bajar tags

Los tags **no** se suben con un `git push` normal:

```bash
git push origin --tags          # sube todos los tags locales
git push origin v1-2026-10-27   # sube uno solo

git fetch --tags                # trae tags del remoto
git ls-remote --tags origin     # ver qué tags hay en GitHub
```

Borrar (usar con cuidado; si ya está publicado, mejor crear otro):

```bash
git tag -d vX-AAAA-MM-DD                    # local
git push origin :refs/tags/vX-AAAA-MM-DD    # remoto
```

---

## 5. Ramas

```bash
cd "$(chezmoi source-path)"

git switch -c pulido-entorno        # crear y cambiar
git switch main                     # volver
git branch -vv                      # ver ramas y upstream
git push -u origin pulido-entorno   # publicar la rama

# al terminar, fusionar en main dejando el punto de unión visible
git switch main
git merge --no-ff pulido-entorno -m "Era 2: entorno pulido"
git tag -a v2-AAAA-MM-DD -m "Era 2: entorno pulido"
git push origin main --follow-tags
```

Cambiar de rama **no** toca tu `$HOME`: git solo mueve archivos dentro del source.
El `$HOME` cambia únicamente cuando corres `chezmoi apply`.

---

## 6. Llave SSH con passphrase

La llave `~/.ssh/id_ed25519` tiene passphrase y no hay ssh-agent activo, así que
`git push`/`pull` fallan con `Permission denied (publickey)` cuando no hay terminal
interactiva. Hay dos formas de resolverlo sin escribir la passphrase en ningún
archivo permanente.

### 6.1 Opción recomendada: agente (la passphrase se escribe una vez)

La passphrase se teclea en tu terminal, se la queda el agente en memoria, y cualquier
proceso de tu usuario que use ese socket puede firmar. Al cerrar sesión o reiniciar
desaparece sola.

```bash
systemctl --user start ssh-agent.socket          # socket en $XDG_RUNTIME_DIR/ssh-agent.socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
ssh-add ~/.ssh/id_ed25519                        # aquí escribes la passphrase
ssh-add -l                                       # debe listar la llave
ssh -T git@github.com                            # verificar
```

Cualquier shell o herramienta (incluido un agente no interactivo como OpenCode) puede
usarla indicando el socket:

```bash
SSH_AUTH_SOCK=/run/user/1000/ssh-agent.socket git push -u origin main
```

Revocar cuando ya no la necesites (o al terminar):

```bash
ssh-add -D                                  # quita las llaves del agente
systemctl --user stop ssh-agent.socket      # apaga el agente
```

Detalle importante: **un `export` hecho en tu terminal no lo hereda otro programa que
ya estaba corriendo** (por ejemplo, el shell de OpenCode, que es hijo de
`opencode serve`, no de tu zsh). Por eso la vía es el *socket* del agente, que es una
ruta fija y compartida, no una variable de entorno.

Para que el socket quede definido en tus shells interactivos (opcional, sin secretos),
añade a tu `~/.zshrc`:

```bash
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
```

Los procesos no interactivos (como un agente) deben pasarlo explícito, porque no leen
tu `.zshrc`.

### 6.2 Opción variable temporal de sesión (si se necesita no interactivo)

Sirve para que un proceso que no puede pedir la passphrase (un agente, un script) la
use durante la sesión actual. Se guarda en el **entorno del gestor de usuario de
systemd**, no en tu shell: sobrevive al cierre del terminal, muere al cerrar la sesión
y se puede borrar a mano.

Tu terminal (la passphrase no queda en el historial gracias a `read -s`):

```bash
systemctl --user start ssh-agent.socket
read -rs p && systemctl --user set-environment "CHEZMOI_SSH_PASS=$p"; unset p
systemctl --user show-environment | grep -c '^CHEZMOI_SSH_PASS='   # 1 = cargada
```

El otro proceso la consume sin verla en `argv` ni en archivos: un helper `askpass`
que la lee del propio gestor y la usa una sola vez para desbloquear el agente.

```bash
cat > /tmp/opencode/askpass.sh <<'EOF'
#!/bin/sh
systemctl --user show-environment | sed -n 's/^CHEZMOI_SSH_PASS=//p'
EOF
chmod 700 /tmp/opencode/askpass.sh

SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket" \
SSH_ASKPASS=/tmp/opencode/askpass.sh \
SSH_ASKPASS_REQUIRE=force \
ssh-add ~/.ssh/id_ed25519 </dev/null

rm -f /tmp/opencode/askpass.sh
systemctl --user unset-environment CHEZMOI_SSH_PASS    # borrar de inmediato
```

Después de esto ya hay agente: git funciona sin la variable.

### 6.3 Reglas de seguridad

- **Nunca** poner la passphrase en `.bashrc`, `.profile`, `environment.d` ni en un
  archivo del repo: eso es permanente y se versiona.
- **No** pegarla en chats, tickets, issues, logs ni capturas: quedan registrados.
  Si ya se hizo, rotarla: `ssh-keygen -p -f ~/.ssh/id_ed25519`.
- Evitar `export PASS=...` o pasarla como argumento: queda en el historial y en el
  `environ` de todos los procesos hijos.
- Una variable en el gestor de systemd es legible por cualquier proceso de tu usuario
  (`systemctl --user show-environment`), igual que un archivo con permisos 600.
  No es más segura que el agente; solo es más fácil de borrar.
- Hay una ventana de milisegundos en que el valor aparece en el `argv` de `systemctl`.
  La vía del agente (6.1) no tiene ese problema: `ssh-add` lee de la terminal.
- Si algo falla con `Permission denied (publickey)`: falta el agente, el socket no está
  exportado, o falta un `SSH_ASKPASS` (`ksshaskpass`).

---

## 7. Diagnóstico

### Las dos columnas de `chezmoi status`

- **Columna 1**: diferencia entre el último estado escrito por chezmoi y lo que hay
  ahora -> "¿lo editaste a mano desde el último apply?".
- **Columna 2**: diferencia entre lo que hay ahora y lo que dice el repo -> "¿qué
  haría `apply`?".

`MM .config/hypr/bindings.conf` = lo editaste a mano Y además el repo no lo tiene así:
un `apply` lo pisaría. Solución: `chezmoi re-add`.

### Casos típicos

| Síntoma | Causa / solución |
|---|---|
| `apply` revirtió mis cambios | editaste el $HOME sin `re-add` antes |
| `Permission denied (publickey)` | falta ssh-agent + `ssh-add` |
| "ya existe" / no quiero pisar algo | `chezmoi diff` antes de aplicar; `chezmoi forget` para dejar de gestionar |
| No sé qué gestiona | `chezmoi managed --path-style absolute` |
| Se me rompió el entorno | `git switch main && chezmoi apply` |

### Documentación dentro del repo

Un archivo suelto en el source (p. ej. `README.md`) se interpreta como destino
`~/README.md`. Verificado: hay que ignorarlo explícitamente. El archivo
`.chezmoiignore` en la raíz del source contiene los patrones a ignorar:

```
README.md
CHANGELOG.md
docs/
```

`.chezmoiignore` es un archivo especial: no se copia a ningún lado.

---

## 8. Fase A — comandos exactos (una sola vez)

Objetivo: congelar la era 0, guardar el estado real como era 1 y abrir la rama de trabajo.

```bash
cd "$(chezmoi source-path)"

# 1. Era 0: lo que ya estaba en el repo
git tag -a v0-2026-06-22 -m "Era 0: configuracion base que ya estaba en el repo"

# 2. Era 1: tus ediciones hechas a mano (dest -> repo; no toca $HOME)
chezmoi re-add
chezmoi status          # debe salir vacio
chezmoi diff            # debe salir vacio

git add -A && git commit -m "Snapshot: estado real del entorno antes del pulido (2026-10-27)"
git tag -a v1-2026-10-27 -m "Era 1: configuracion en uso antes del pulido"

# 3. Rama para lo nuevo
git switch -c pulido-entorno

# 4. Verificación
git log --oneline --decorate -3
git tag -n1
```

Publicar (requiere la llave desbloqueada, ver sección 6):

```bash
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"   # si usas el agente
git push -u origin main
git push -u origin pulido-entorno
git push origin --tags
git ls-remote origin          # main, pulido-entorno, v0-2026-06-22, v1-2026-10-27
```

---

## 9. Chuleta

| Quiero... | Comando |
|---|---|
| ver qué está desfasado | `chezmoi status` |
| ver el diff | `chezmoi diff` |
| guardar lo que edité | `chezmoi re-add` |
| versionar algo nuevo | `chezmoi add <ruta>` |
| traer del remoto y aplicar | `chezmoi update` |
| desplegar el repo en $HOME | `chezmoi apply` |
| ir al repo | `chezmoi cd` |
| listar eras | `git tag -n1` |
| usar una era antigua | `git switch --detach <tag>` + `chezmoi apply` |
| volver a la actual | `git switch main` + `chezmoi apply` |
| publicar todo | `git push -u origin main --follow-tags` |
| desbloquear la llave una vez | `ssh-add ~/.ssh/id_ed25519` (con `SSH_AUTH_SOCK` del agente) |
| usar el agente en otro proceso | `SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket git push` |
| ver salud | `chezmoi doctor` |
