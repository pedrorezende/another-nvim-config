local keymaps = vim.keymap

-- Increment / Decrement
keymaps.set("n", "+", "<C-a>")
keymaps.set("n", "-", "<C-x>")

-- Select all
keymaps.set("n", "<C-a>", "gg<S-v>G")

-- Close buffer
keymaps.set("n", "<C+w>d", ":bd<CR>")

-- Leave insert mode
keymaps.set("i", "kk", "<Esc>")
keymaps.set("i", "jj", "<Esc>")

-- Adding line without leaving normal mode
keymaps.set("n", "zo", "o<Esc>k")
keymaps.set("n", "zO", "O<Esc>j")

keymaps.set("n", "ss", "<leader>/")
keymaps.set("n", "<s-left><s-right>", "<leader>/")

keymaps.set("i", "<C-h>", "<C-o>B")

-- Move cursor left one word
keymaps.set("i", "<M-h>", "<C-o>1b", { noremap = true, silent = true })
keymaps.set("i", "<M-H>", "<C-o>1B", { noremap = true, silent = true })

-- Move cursor right one word
keymaps.set("i", "<M-j>", "<C-o>j", { noremap = true, silent = true })
keymaps.set("i", "<M-J>", "<C-o>}", { noremap = true, silent = true })

-- Move cursor top one line or one paragraph
keymaps.set("i", "<M-k>", "<C-o>k", { noremap = true, silent = true })
keymaps.set("i", "<M-K>", "<C-o>{", { noremap = true, silent = true })

-- Move cursor bottom one line or one paragraph
keymaps.set("i", "<M-l>", "<C-o>1e", { noremap = true, silent = true })
keymaps.set("i", "<M-L>", "<C-o>1E", { noremap = true, silent = true })

-- Add new line
keymaps.set("i", "<M-o>", "<C-o>o", { noremap = true, silent = true })
keymaps.set("i", "<M-O>", "<C-o>O", { noremap = true, silent = true })

-- Delete char
keymaps.set("i", "<M-x>", "<C-o>x", { noremap = true, silent = true })
keymaps.set("i", "<M-X>", "<C-o>X", { noremap = true, silent = true })

-- Move to the beginning of the line
keymaps.set("i", "<M-a>", "<C-o>^", { noremap = true, silent = true })

-- Move to the end of the line
keymaps.set("i", "<M-e>", "<C-o>$", { noremap = true, silent = true })

-- Delete the previous word
keymaps.set("i", "<M-w>", "<C-o>db", { noremap = true, silent = true })
keymaps.set("i", "<M-W>", "<C-o>dB", { noremap = true, silent = true })

-- Undo the last change
keymaps.set("i", "<M-u>", "<Esc>ui", { noremap = true, silent = true })

-- Leave insert mode
keymaps.set("i", "kk", "<Esc>")
keymaps.set("i", "jj", "<Esc>")

-- Redo the last undone change
keymaps.set("i", "<M-r>", "<Esc><C-r>i", { noremap = true, silent = true })

-- Increment / Decrement
keymaps.set("n", "+", "<C-a>")
keymaps.set("n", "-", "<C-x>")

-- Adding line without leaving normal mode
keymaps.set("n", "zo", "o<Esc>k")
keymaps.set("n", "zO", "O<Esc>j")
keymaps.set("n", "<leader>w", ":w<CR>", { desc = "Quick save" })

-- Select all
keymaps.set("n", "<C-a>", "gg<S-v>G")

-- Diagnostic keymaps
keymaps.set("n", "[e", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
keymaps.set("n", "]e", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })

-- Keybinds to make split navigation easier.
keymaps.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymaps.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymaps.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymaps.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Expanding or jumping to the next snippet position
keymaps.set("i", "<C-Tab>", function()
  local ls = require("luasnip")
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { noremap = true, silent = true })

-- Jumping to the previous snippet position
keymaps.set("i", "<S-Tab>", function()
  local ls = require("luasnip")
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { noremap = true, silent = true })
