return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = { "Neotree" },
  -- drop image preview; it’s slow
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- disable icons for speed; re-enable if you want them
    -- "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>e",
      function()
        vim.cmd([[Neotree reveal]])
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "Buffer Explorer",
    },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    -- lazy-load only when starting with a directory
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        end
        local stats = (vim.uv or vim.loop).fs_stat(vim.fn.argv(0))
        if stats and stats.type == "directory" then
          require("neo-tree")
        end
      end,
    })
  end,
  opts = {
    -- keep only the fast sources
    sources = { "filesystem", "buffers" }, -- remove "git_status" and "document_symbols" by default
    enable_git_status = false, -- huge win; open git view on demand via <leader>ge
    enable_diagnostics = false, -- avoid LSP spam in tree

    -- filesystem perf
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = false }, -- avoids constant refresh
      use_libuv_file_watcher = true, -- native watcher
      -- shallow scan = faster listing (v3 supports this)
      scan_mode = "shallow",
      filtered_items = {
        show_hidden_count = false,
        hide_by_name = { ".git", ".DS_Store", "thumbs.db", "node_modules", "dist" },
      },
      hijack_netrw_behavior = "open_default",
      group_empty_dirs = true,
    },

    buffers = {
      follow_current_file = { enabled = false },
      show_unloaded = false,
    },

    window = {
      -- floating is heavier; docked left is faster
      position = "float",
      width = 28,
      mappings = {
        ["<space>"] = "none",
        ["O"] = {
          function(state)
            require("lazy.util").open(state.tree:get_node().path, { system = true })
          end,
          desc = "Open with System Application",
        },
      },
    },

    default_component_configs = {
      icon = { enabled = false }, -- skip devicons
      name = { use_git_status_colors = false },
      modified = { symbol = "" }, -- no modified marker
      git_status = { symbols = {} }, -- no git glyphs
      indent = {
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      diagnostics = { symbols = {} },
    },

    -- renderer trims
    renderers = {
      directory = { { "indent" }, { "current_filter" }, { "name" } },
      file = { { "indent" }, { "name" } },
    },

    -- misc perf
    event_handlers = {
      -- stop expensive auto-refresh storms
      {
        event = "file_opened",
        handler = function()
          require("neo-tree.command").execute({ action = "close" })
        end,
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- optional: enable git source only when requested
    vim.api.nvim_create_user_command("NeoGitOn", function()
      require("neo-tree.command").execute({ source = "git_status", toggle = true })
    end, {})

    -- optional: refresh git view after lazygit closes if you enable git_status
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit",
      callback = function()
        local ok, git = pcall(require, "neo-tree.sources.git_status")
        if ok then
          git.refresh()
        end
      end,
    })
  end,
}
