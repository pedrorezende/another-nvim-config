return {
  "puremourning/vimspector",
  cmd = { "VimspectorInstall", "VimspectorUpdate", "VimspectorLaunch", "VimspectorReset" },
  keys = {
    { "<leader>dd", "<cmd>VimspectorLaunch<cr>" },
    { "<leader>dQ", "<cmd>VimspectorReset<cr>" },
  },
  init = function()
    vim.g.vimspector_enable_mappings = "HUMAN"
  end,
}
