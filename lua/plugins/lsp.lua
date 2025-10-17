return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = { spacing = 2, source = "if_many" },
      severity_sort = true,
      signs = false,
    },
    inlay_hints = { enabled = false },
    codelens = { enabled = false },
    folds = { enabled = false },
    capabilities = {
      textDocument = { semanticTokens = { dynamicRegistration = false } },
      workspace = { didChangeWatchedFiles = { dynamicRegistration = false } },
    },
    servers = {
      tsserver = false, -- hard off
      vtsls = false, -- if you had vtsls
      denols = false, -- avoid conflicts
      elixirls = {
        settings = {
          elixirLS = {
            dialyzerEnabled = false,
            fetchDeps = false,
          },
        },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            inlayHints = {
              chainingHints = false, -- Show hints for chained method calls
              typeHints = false, -- Show type hints for variables
              parameterHints = false, -- Show parameter name hints
            },
          },
        },
      },
    },
  },
}
