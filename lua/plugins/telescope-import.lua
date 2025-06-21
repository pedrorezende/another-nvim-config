vim.keymap.set("n", "<leader>i", ":Telescope import<CR>")

return {
  "piersolenski/telescope-import.nvim",
  dependencies = "nvim-telescope/telescope.nvim",
  config = function()
    require("telescope").load_extension("import")
  end,
  opts = {
    extensions = {
      import = {
        -- Add imports to the top of the file keeping the cursor in place
        insert_at_top = true,
        -- Support additional languages
        custom_languages = {
          {
            regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
            filetypes = { "typescript", "typescriptreact", "javascript", "react" },
            extensions = { "js", "ts", "jsx", "tsx" },
          },
        },
      },
    },
  },
}
