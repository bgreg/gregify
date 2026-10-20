vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
end

vim.opt.clipboard = "unnamed,unnamedplus"  -- Sync with system clipboard
vim.opt.number = true                       -- Show line numbers
vim.opt.mouse = "a"                         -- Enable mouse in all modes
vim.opt.ignorecase = true                   -- Case-insensitive search
vim.opt.smartcase = true                    -- Searches befome case-sensitive only if uppercase used
vim.opt.hlsearch = true                     -- Highlight search matches
vim.opt.incsearch = true                    -- Show search matches while typing
vim.opt.wrap = false                        -- Don't wrap long lines
vim.opt.linebreak = true                    -- Wrap at word boundaries (if wrap on)
vim.opt.breakindent = true                  -- Indent wrapped lines
vim.opt.tabstop = 2                         -- Tab displays as 2 spaces
vim.opt.shiftwidth = 2                      -- Indent with 2 spaces
vim.opt.expandtab = true                    -- Use spaces instead of tabs
vim.opt.autoindent = true                   -- Copy indent from current line
vim.opt.smartindent = true                  -- Auto-indent after {, etc.
vim.opt.textwidth = 120                     -- Max line width for formatting
vim.opt.termguicolors = true                -- Enable 24-bit RGB colors
vim.opt.signcolumn = "yes"                  -- Always show sign column (gutter)
vim.opt.updatetime = 250                    -- Faster CursorHold events (ms)
vim.opt.timeoutlen = 500                    -- Key sequence timeout (ms)
vim.opt.splitright = true                   -- New vsplits open to the right
vim.opt.splitbelow = true                   -- New splits open below
vim.opt.scrolloff = 8                       -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 15                  -- Keep 15 cols left/right of cursor
vim.opt.undofile = true                     -- Persist undo history to disk
vim.opt.undolevels = 1000                   -- Max undo changes to remember
vim.opt.backup = false                      -- Don't create backup files
vim.opt.swapfile = false                    -- Don't create swap files
vim.opt.spell = false                       -- Spell check off by default
vim.opt.spelllang = "en_us"                 -- Spell check language
vim.opt.showmode = false                    -- Hide mode (lualine shows it)
vim.opt.title = true                        -- Set terminal window title
vim.opt.laststatus = 2                      -- Always show status line
vim.opt.showcmd = true                      -- Show partial command in corner
vim.opt.autoread = true                     -- Reload files changed externally
vim.opt.history = 10000                     -- Command history size
vim.opt.guicursor = "n-v-c:block-blinkon0,i-ci-ve:ver25-blinkon0,r-cr:hor20-blinkon0"  -- Non-blinking cursor

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("plugins"))

require('lualine').setup({
  options = {
    theme = 'auto',
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_x = {
      function()
        local names = {}
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, client.name)
        end
        return #names > 0 and table.concat(names, ',') or 'no lsp'
      end,
      'encoding', 'fileformat', 'filetype',
    },
  },
})

-- to re-source keymaps run  `:luafile ~/.config/nvim/lua/keymaps.lua)`
require("keymaps").setup()

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.cmd("silent! write")
    end
  end,
})

vim.api.nvim_create_autocmd("FocusLost", {
  callback = function()
    vim.cmd("silent! wa")
  end,
})

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    vim.cmd("silent! wa")
  end,
})

local external_reload_group = vim.api.nvim_create_augroup("ExternalFileReload", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = external_reload_group,
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShell", {
  group = external_reload_group,
  callback = function()
    vim.v.fcs_choice = "reload"
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = external_reload_group,
  callback = function()
    local filename = vim.fn.expand("<afile>:t")
    vim.notify(filename .. " reloaded (changed externally)", vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "lua", "vim", "javascript", "python", "sh", "bash", "zsh" },
  callback = function()
    vim.cmd("syntax spell toplevel")
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.g.vscode then return end
    vim.cmd("tabnew ~/.config/nvim/CHEATSHEET.md")
    vim.cmd("tabfirst")
  end,
})

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function()
    if vim.g.vscode then return end
    -- Skip if nvim is already quitting
    if vim.v.exiting ~= vim.NIL then return end

    -- Defer minimally to let window close complete
    vim.schedule(function()
      -- Double-check we're not quitting
      if vim.v.exiting ~= vim.NIL then return end

      local tabs = vim.api.nvim_list_tabpages()
      -- Quick exit if multiple tabs remain
      if #tabs > 2 then return end

      local cheatsheet_tab = nil
      local other_tabs = 0

      for _, tab in ipairs(tabs) do
        local wins = vim.api.nvim_tabpage_list_wins(tab)
        for _, win in ipairs(wins) do
          local buf = vim.api.nvim_win_get_buf(win)
          local bufname = vim.api.nvim_buf_get_name(buf)
          if bufname:match("CHEATSHEET%.md$") then
            cheatsheet_tab = tab
          else
            other_tabs = other_tabs + 1
          end
        end
      end

      if cheatsheet_tab and other_tabs == 0 then
        vim.cmd("quitall")
      end
    end)
  end,
})

if not vim.g.vscode then
  vim.cmd("colorscheme gotham")
end

-- Terminal opens at bottom, 1/4 screen height
vim.api.nvim_create_user_command('Term', function()
  local height = math.floor(vim.o.lines * 0.25)
  vim.cmd('botright ' .. height .. 'split | terminal')
  vim.cmd('startinsert')
end, {})

-- Override :term to use bottom split
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    -- Only reposition if opened via :term (not :ClaudeCode or other plugins)
    local bufname = vim.api.nvim_buf_get_name(0)
    if not bufname:match('claude') then
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
    end
  end,
})

-- Remap :term to use bottom split
vim.cmd([[cabbrev term Term]])
