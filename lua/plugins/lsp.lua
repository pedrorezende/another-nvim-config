return {
  "neovim/nvim-lspconfig",
  event = "LazyFile",
  dependencies = {
    "mason.nvim",
    { "mason-org/mason-lspconfig.nvim", config = function() end },
  },
  opts = function()
    ---@class PluginLspOpts
    local ret = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false, -- off = fewer renders
        severity_sort = true,
        signs = false, -- off = fewer signcolumn updates
      },
      inlay_hints = { enabled = false }, -- off globally (enable per-server if needed)
      codelens = { enabled = false }, -- keep off
      folds = { enabled = false }, -- LSP folds are slow; use treesitter/manual
      capabilities = {
        textDocument = {
          semanticTokens = { dynamicRegistration = false }, -- don’t advertise tokens
        },
        workspace = {
          didChangeWatchedFiles = { dynamicRegistration = false }, -- avoid server FS watchers
          fileOperations = { didRename = false, willRename = false },
        },
      },
      format = {
        formatting_options = nil,
        timeout_ms = 1500, -- tighter timeout
      },
      servers = {
        stylua = { enabled = false },
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              codeLens = { enable = false },
              completion = { callSnippet = "Replace" },
              hint = { enable = false },
              diagnostics = { disable = { "missing-fields" } }, -- small perf win
            },
          },
          flags = { debounce_text_changes = 150 },
        },
      },
      setup = {
        -- Apply perf trims to every server
        ["*"] = function(server, opts)
          -- cut semantic tokens per-server
          local on_attach = opts.on_attach
          opts.on_attach = function(client, bufnr)
            if client.server_capabilities then
              client.server_capabilities.semanticTokensProvider = nil
              client.server_capabilities.codeLensProvider = nil
              client.server_capabilities.foldingRangeProvider = nil
            end
            if on_attach then
              on_attach(client, bufnr)
            end
          end
          -- conservative debounce for most servers
          opts.flags = vim.tbl_extend("force", { debounce_text_changes = 150 }, opts.flags or {})
          return false
        end,
      },
    }
    return ret
  end,
  ---@param opts PluginLspOpts
  config = vim.schedule_wrap(function(_, opts)
    -- less noise/logging
    vim.lsp.set_log_level("OFF")

    -- formatter stays registered
    LazyVim.format.register(LazyVim.lsp.formatter())

    -- keymaps
    LazyVim.lsp.on_attach(function(client, buffer)
      require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
    end)

    -- disable LazyVim’s automatic inlay/fold hooks (we keep them off globally)
    opts.inlay_hints.enabled = false
    opts.folds.enabled = false

    -- diagnostics config
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    if opts.capabilities then
      vim.lsp.config("*", { capabilities = opts.capabilities })
    end

    local have_mason = LazyVim.has("mason-lspconfig.nvim")
    local mason_all = {}
    if have_mason then
      local ok, mapping = pcall(require, "mason-lspconfig.mappings.server")
      if ok and mapping and mapping.lspconfig_to_package then
        mason_all = vim.tbl_keys(mapping.lspconfig_to_package)
      end
    end
    local mason_exclude = {}

    local function configure(server)
      local sopts = opts.servers[server]
      sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts
      if sopts.enabled == false then
        mason_exclude[#mason_exclude + 1] = server
        return
      end
      local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
      local setup = opts.setup[server] or opts.setup["*"]
      if setup and setup(server, sopts) then
        mason_exclude[#mason_exclude + 1] = server
      else
        vim.lsp.config(server, sopts)
        if not use_mason then
          vim.lsp.enable(server)
        end
      end
      return use_mason
    end

    local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
    if have_mason then
      require("mason-lspconfig").setup({
        ensure_installed = vim.list_extend(install, LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}),
        automatic_enable = { exclude = mason_exclude },
      })
    end

    -- large-file guard: kill heavy features automatically
    vim.api.nvim_create_autocmd("BufReadPre", {
      callback = function(args)
        local ok, stats = pcall(vim.loop.fs_stat, args.file)
        if not ok or not stats then
          return
        end
        if stats.size > 500 * 1024 then -- >500KB
          vim.b[args.buf].large_buf = true
          vim.diagnostic.disable(args.buf)
          -- stop semantic tokens just in case any server slipped through
          for _, c in pairs(vim.lsp.get_clients({ bufnr = args.buf })) do
            c.server_capabilities.semanticTokensProvider = nil
          end
        end
      end,
    })
  end),
}
