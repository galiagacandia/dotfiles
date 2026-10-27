-- =====================================================================
-- Origen: ~/.config/hypr/bindings.conf (197 lineas)
-- Traduccion 1:1 a la API Lua de Hyprland 0.56.2
--
-- 62 binds activos + 50 binds comentados en el original.
-- Las directivas comentadas se traducen a Lua y quedan comentadas,
-- listas para descomentar. Los comentarios de prosa se conservan.
-- El texto original sigue en bindings.conf (intacto).
-- =====================================================================

-- =====================================================================
-- VARIABLES PRINCIPALES
-- =====================================================================
-- Definimos la tecla Windows/Command como modificador principal
local mainMod = "SUPER"

-- =====================================================================
-- APLICACIONES NATIVAS DEL ENTORNO
-- =====================================================================
-- bind = $mainMod, RETURN, exec, kitty       # Super + Enter para lanzar la terminal base
-- hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("ghostty"))       -- Super + Enter para lanzar la terminal base
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))            -- Super + E para el gestor de archivos
-- bind = $mainMod, SPACE, exec, hyprlauncher
-- hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("hyprlauncher"))
-- bind = $mainMod, SPACE, exec, rofi -show drun
-- hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun"))   -- Lanzador de aplicaciones del sistema
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("walker"))         -- Lanzador de aplicaciones del sistema

-- bind = , Print, exec, grim -g "$(slurp)" - | satty --filename - --fullscreen
-- hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | satty --filename - --fullscreen'))
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" -t ppm - | satty --filename - --fullscreen'))

-- =====================================================================
-- GESTIÓN Y ESTADO DE VENTANA
-- =====================================================================
hl.bind(mainMod .. " + Q", hl.dsp.window.close())                 -- Super + Q para cerrar la ventana enfocada
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())            -- Super + F para alternar pantalla completa
-- bind = $mainMod SHIFT, SPACE, togglefloating
-- hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))   -- Super + Shift + Espacio para alternar modo flotante
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())                -- Modo Pseudo para el diseño Dwindle
-- bind = SUPER, J, layoutmsg, orientationnext
-- hl.bind("SUPER + J", hl.dsp.layout("orientationnext"))
-- bind = SUPER, H, layoutmsg, orientationleft
-- hl.bind("SUPER + H", hl.dsp.layout("orientationleft"))
-- bind = SUPER, V, layoutmsg, orientationtop
-- hl.bind("SUPER + V", hl.dsp.layout("orientationtop"))
-- bind = SUPER, H, layoutmsg, orientationleft
-- hl.bind("SUPER + H", hl.dsp.layout("orientationleft"))
-- bind = SUPER, K, layoutmsg, orientationtop
-- hl.bind("SUPER + K", hl.dsp.layout("orientationtop"))
-- bind = SUPER, L, layoutmsg, orientationright
-- hl.bind("SUPER + L", hl.dsp.layout("orientationright"))
-- bind = SUPER, J, layoutmsg, orientationbottom
-- hl.bind("SUPER + J", hl.dsp.layout("orientationbottom"))
-- bind = $mainMod, J, layoutmsg, togglesplit
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))           -- Cambiar la división del espacio (Horizontal/Vertical)
-- bind = $mainMod, J, layoutmsg, swapnext
-- hl.bind(mainMod .. " + J", hl.dsp.layout("swapnext"))
-- bind = $mainMod, J, layoutmsg, orientationcycle next
-- hl.bind(mainMod .. " + J", hl.dsp.layout("orientationcycle next"))

-- =====================================================================
-- NAVEGACIÓN Y FOCO (Estilo Vim / Direccional)
-- =====================================================================
-- Mover el foco entre ventanas usando las teclas estándar de Vim (HJKL)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Alternativa usando las flechas del teclado por comodidad
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- =====================================================================
-- INTERCAMBIO DE VENTANAS (Mover ventanas de posición)
-- =====================================================================
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.layout("swapwithmaster"))

-- =====================================================================
-- GESTIÓN DE GRUPOS (TABS) EN HYPRLAND
-- =====================================================================

-- Crear un grupo o meter una ventana al grupo actual (Equivalente a una nueva pestaña)
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
-- Sacar la ventana del grupo
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ out_of_group = true }))

-- Navegar entre pestañas del grupo
hl.bind(mainMod .. " + TAB", hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.group.prev())

-- Añadir ventana al grupo
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.move({ into_group = "left" }))
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.move({ into_group = "down" }))
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.move({ into_group = "up" }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.move({ into_group = "right" }))

-- Cambiar rápidamente entre los "Nvim" del grupo con ALT + Flechas (Como en Zellij)
-- bind = ALT, left, changegroupactive, b
-- hl.bind("ALT + left", hl.dsp.group.prev())
-- bind = ALT, right, changegroupactive, f
-- hl.bind("ALT + right", hl.dsp.group.next())

-- Alternativa clásica de Vim por si la prefieres en el futuro: ALT + H / L
-- bind = ALT, H, changegroupactive, b
-- hl.bind("ALT + H", hl.dsp.group.prev())
-- bind = ALT, L, changegroupactive, f
-- hl.bind("ALT + L", hl.dsp.group.next())

-- =====================================================================
-- GESTIÓN DE ÁREAS DE TRABAJO (Workspaces)
-- =====================================================================
-- Cambiar de escritorio virtual (Super + [1-9])
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Mover la ventana activa a un escritorio específico (Super + Shift + [1-9])
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- =====================================================================
-- CONTROL GLOBAL DEL ENTORNO
-- =====================================================================
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))   -- Super + Shift + R para forzar recarga manual
-- bind = $mainMod SHIFT, E, exit
-- hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())                     -- Super + Shift + E para cerrar sesión e ir al login
-- Abrir el menú visual de cierre de sesión (Estilo Omarchy / Wayland)
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("wlogout -b 2"))

-- =====================================================================
-- CONTROL CON EL RATÓN (Mouse Binds)
-- =====================================================================
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--======================================================================
-- MOVERSE ENTRE ESCRITORIOS
--======================================================================
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "m+1" }))


-- =====================================================================
-- Atajos de teclado para el control de medios (Teclas Multimedia Especiales)
-- =====================================================================
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"),       { locked = true })

-- =====================================================================
-- Opcional: Control de volumen si también te falla
-- =====================================================================
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- =====================================================================
--
-- =====================================================================
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("google-chrome-stable"), { description = "Browser" })
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("spotify"),              { description = "Music" })

-- Application bindings
-- bindd = SUPER, RETURN, Terminal, exec, uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"
-- hl.bind("SUPER + RETURN", hl.dsp.exec_cmd('uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"'), { description = "Terminal" })
-- bindd = SUPER ALT, RETURN, Tmux, exec, uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" bash -c "tmux attach || tmux new -s Work"
-- hl.bind("SUPER + ALT + RETURN", hl.dsp.exec_cmd('uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" bash -c "tmux attach || tmux new -s Work"'), { description = "Tmux" })
-- bindd = SUPER SHIFT, RETURN, Browser, exec, omarchy-launch-browser
-- hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd("omarchy-launch-browser"), { description = "Browser" })
-- bindd = SUPER SHIFT, F, File manager, exec, uwsm-app -- nautilus --new-window
-- hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("uwsm-app -- nautilus --new-window"), { description = "File manager" })
-- bindd = SUPER ALT SHIFT, F, File manager (cwd), exec, uwsm-app -- nautilus --new-window "$(omarchy-cmd-terminal-cwd)"
-- hl.bind("SUPER + ALT + SHIFT + F", hl.dsp.exec_cmd('uwsm-app -- nautilus --new-window "$(omarchy-cmd-terminal-cwd)"'), { description = "File manager (cwd)" })
-- bindd = SUPER SHIFT, B, Browser, exec, omarchy-launch-browser
-- hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("omarchy-launch-browser"), { description = "Browser" })
-- bindd = SUPER SHIFT ALT, B, Browser (private), exec, omarchy-launch-browser --private
-- hl.bind("SUPER + SHIFT + ALT + B", hl.dsp.exec_cmd("omarchy-launch-browser --private"), { description = "Browser (private)" })
-- bindd = SUPER SHIFT, M, Music, exec, omarchy-launch-or-focus spotify
-- hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("omarchy-launch-or-focus spotify"), { description = "Music" })
-- bindd = SUPER SHIFT ALT, M, Music TUI, exec, omarchy-launch-or-focus-tui cliamp
-- hl.bind("SUPER + SHIFT + ALT + M", hl.dsp.exec_cmd("omarchy-launch-or-focus-tui cliamp"), { description = "Music TUI" })
-- bindd = SUPER SHIFT, N, Editor, exec, omarchy-launch-editor
-- hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("omarchy-launch-editor"), { description = "Editor" })
-- bindd = SUPER SHIFT, D, Docker, exec, omarchy-launch-tui lazydocker
-- hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("omarchy-launch-tui lazydocker"), { description = "Docker" })
-- bindd = SUPER SHIFT, G, Signal, exec, omarchy-launch-or-focus ^signal$ "uwsm-app -- signal-desktop"
-- hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd('omarchy-launch-or-focus ^signal$ "uwsm-app -- signal-desktop"'), { description = "Signal" })
-- bindd = SUPER SHIFT, O, Obsidian, exec, omarchy-launch-or-focus ^obsidian$ "uwsm-app -- obsidian"
-- hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd('omarchy-launch-or-focus ^obsidian$ "uwsm-app -- obsidian"'), { description = "Obsidian" })
-- bindd = SUPER SHIFT, W, Typora, exec, uwsm-app -- typora --enable-wayland-ime
-- hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("uwsm-app -- typora --enable-wayland-ime"), { description = "Typora" })
-- bindd = SUPER SHIFT, SLASH, Passwords, exec, uwsm-app -- 1password
-- hl.bind("SUPER + SHIFT + SLASH", hl.dsp.exec_cmd("uwsm-app -- 1password"), { description = "Passwords" })

-- If your web app url contains #, type it as ## to prevent hyprland treating it as a comment
-- bindd = SUPER SHIFT, A, ChatGPT, exec, omarchy-launch-webapp "https://chatgpt.com"
-- hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd('omarchy-launch-webapp "https://chatgpt.com"'), { description = "ChatGPT" })
-- bindd = SUPER SHIFT ALT, A, Grok, exec, omarchy-launch-webapp "https://grok.com"
-- hl.bind("SUPER + SHIFT + ALT + A", hl.dsp.exec_cmd('omarchy-launch-webapp "https://grok.com"'), { description = "Grok" })
-- bindd = SUPER SHIFT, C, Calendar, exec, omarchy-launch-webapp "https://app.hey.com/calendar/weeks/"
-- hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd('omarchy-launch-webapp "https://app.hey.com/calendar/weeks/"'), { description = "Calendar" })
-- bindd = SUPER SHIFT, E, Email, exec, omarchy-launch-webapp "https://app.hey.com"
-- hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd('omarchy-launch-webapp "https://app.hey.com"'), { description = "Email" })
-- bindd = SUPER SHIFT, Y, YouTube, exec, omarchy-launch-webapp "https://youtube.com/"
-- hl.bind("SUPER + SHIFT + Y", hl.dsp.exec_cmd('omarchy-launch-webapp "https://youtube.com/"'), { description = "YouTube" })
-- bindd = SUPER SHIFT ALT, G, WhatsApp, exec, omarchy-launch-or-focus-webapp WhatsApp "https://web.whatsapp.com/"
-- hl.bind("SUPER + SHIFT + ALT + G", hl.dsp.exec_cmd('omarchy-launch-or-focus-webapp WhatsApp "https://web.whatsapp.com/"'), { description = "WhatsApp" })
-- bindd = SUPER SHIFT CTRL, G, Google Messages, exec, omarchy-launch-or-focus-webapp "Google Messages" "https://messages.google.com/web/conversations"
-- hl.bind("SUPER + SHIFT + CTRL + G", hl.dsp.exec_cmd('omarchy-launch-or-focus-webapp "Google Messages" "https://messages.google.com/web/conversations"'), { description = "Google Messages" })
-- bindd = SUPER SHIFT, P, Google Photos, exec, omarchy-launch-or-focus-webapp "Google Photos" "https://photos.google.com/"
-- hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd('omarchy-launch-or-focus-webapp "Google Photos" "https://photos.google.com/"'), { description = "Google Photos" })
-- bindd = SUPER SHIFT, X, X, exec, omarchy-launch-webapp "https://x.com/"
-- hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd('omarchy-launch-webapp "https://x.com/"'), { description = "X" })
-- bindd = SUPER SHIFT ALT, X, X Post, exec, omarchy-launch-webapp "https://x.com/compose/post"
-- hl.bind("SUPER + SHIFT + ALT + X", hl.dsp.exec_cmd('omarchy-launch-webapp "https://x.com/compose/post"'), { description = "X Post" })

-- Add extra bindings
-- bind = SUPER SHIFT, R, exec, alacritty -e ssh your-server
-- hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("alacritty -e ssh your-server"))

-- Overwrite existing bindings, like putting Omarchy Menu on Super + Space
-- unbind = SUPER, SPACE
-- hl.unbind("SUPER + SPACE")
-- bindd = SUPER, SPACE, Omarchy menu, exec, omarchy-menu
-- hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("omarchy-menu"), { description = "Omarchy menu" })

-- Logitech MX Keys
-- bind = SUPER SHIFT, S, exec, omarchy-capture-screenshot      # Print Screen Button
-- hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("omarchy-capture-screenshot"))
-- bind = SUPER, H, exec, voxtype record toggle                 # Dictation Button
-- hl.bind("SUPER + H", hl.dsp.exec_cmd("voxtype record toggle"))
-- bind = SUPER, PERIOD, exec, omarchy-launch-walker -m symbols # Emoji Button
-- hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("omarchy-launch-walker -m symbols"))
