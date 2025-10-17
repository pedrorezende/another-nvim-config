return {
  -- 1) TypeScript LSP wrapper (faster/more robust than raw tsserver)
  "pmizio/typescript-tools.nvim",
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    return {
      on_attach = function(client, _)
        -- hard-disable semantic tokens = big perf win with no feature loss
        client.server_capabilities.semanticTokensProvider = nil
      end,
      settings = {
        -- split diags path to a helper process = smoother typing
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insertLeave",
        tsserver_max_memory = 2048,
        jsx_close_tag = { enable = false },
        tsserver_file_preferences = {
          includeCompletionsForModuleExports = true, -- auto-imports
          includeCompletionsWithInsertTextCompletions = true,
          includeAutomaticOptionalChainCompletions = true,
          includeInlayParameterNameHints = "none",
          quotePreference = "auto",
          importModuleSpecifierPreference = "non-relative",
          providePrefixAndSuffixTextForRename = true,
          -- for JS diagnostics you still need // @ts-check or tsconfig checkJs=true
        },
        tsserver_format_options = { insertSpaceAfterCommaDelimiter = true },
      },
      -- keep diagnostics ON, just don’t spam while typing
      handlers = {
        ["textDocument/publishDiagnostics"] = require("typescript-tools.api").filter_diagnostics({}),
      },
    }
  end,
}
