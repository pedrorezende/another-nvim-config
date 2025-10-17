return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "vim", "rust", "typescript", "tsx", "json", "toml" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
      disable = function(_, buf)
        local ok, st = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        return not ok or not st or st.size > 300 * 1024
      end,
    },
    indent = { enable = false },
  },
}
