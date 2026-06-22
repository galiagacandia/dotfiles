return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      -- 🛠️ LA MAGIA PARA JAVA:
      -- Contrae automáticamente las carpetas vacías consecutivas (ej. com/DigitalHarbor/Yoodle)
      -- collapse_nested_folders = true,
      group_empty_dirs = true,

      -- Opciones extra muy útiles:
      filtered_items = {
        visible = true, -- Cambia a true si quieres ver archivos ocultos siempre
        hide_dotfiles = false,
        hide_gitignored = false, -- Muestra carpetas aunque estén en el .gitignore
      },
    },
    window = {
      width = 30, -- Ancho de la barra lateral
      mappings = {
        -- Atajos útiles dentro del árbol:
        -- ["l"] = "open",  -- Con la 'l' abres carpetas o archivos
        -- ["h"] = "close_node", -- Con la 'h' cierras carpetas
      },
    },
  },
}
