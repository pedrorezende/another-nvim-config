return {
  "mrcjkb/rustaceanvim",
  opts = {
    server = {
      default_settings = {
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
}
