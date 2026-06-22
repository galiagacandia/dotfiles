return {
  {
    "lervag/vimtex",
    lazy = false, -- Se recomienda no usar lazy load para VimTeX
    init = function()
      -- Usar latexmk para compilación automática y múltiple
      vim.g.vimtex_compiler_method = "latexmk"

      vim.g.vimtex_compiler_latexmk_engines = {
        _ = "-xelatex",
      }

      -- Configuración de latexmk para que use Biber (necesario para tus citas)
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
      -- Configuración del visor de PDF (Zathura es el mejor para Arch)
      vim.g.vimtex_view_method = "zathura"
      -- Obliga a VimTeX a esperar y reintentar buscar el ID si no lo encuentra a la primera
      vim.g.vimtex_view_zathura_check_interval = 200 -- Espera 200ms entre intentos
      vim.g.vimtex_view_zathura_check_max = 3 -- Intenta hasta 15 veces (3 segundos de margen)
    end,
  },
}
