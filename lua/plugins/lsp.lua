return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ts_ls = { autostart = false },
      elixirls = {
        settings = {
          elixirLS = {
            dialyzerEnabled = false,
            fetchDeps = false,
          },
        },
      },
    },
  },
}
