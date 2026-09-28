-- Reload this file with: :lua reloadKeymaps

function reloadKeymaps()
  require("keymaps").reload()
end

local M = {}

-- Marker prefix for descriptions - used to identify our keymaps
local MARKER = "[km] "

-- Old formatter configuration (replaced by LSP-based formatting)
-- local formatters = {
--   ruby = { cmd = 'bundle exec rubocop -A', name = 'RuboCop' },
--   lua = { cmd = 'stylua', name = 'StyLua' },
--   javascript = { cmd = 'prettier --write', name = 'Prettier' },
--   typescript = { cmd = 'prettier --write', name = 'Prettier' },
--   sql = { cmd = 'sql-formatter --fix', name = 'SQL Formatter' },
--   markdown = { cmd = 'prettier --write', name = 'Prettier' },
-- }

-- Old format_file function (replaced by LSP-based formatting)
-- local function format_file()
--   local filetype = vim.bo.filetype
--   local formatter = formatters[filetype]
--
--   if not formatter then
--     print('Formatter not supported for filetype: ' .. filetype)
--     return
--   end
--
--   local file = vim.fn.expand('%')
--   vim.cmd('write')
--   vim.fn.system(formatter.cmd .. ' ' .. vim.fn.shellescape(file))
--   vim.cmd('edit!')
--   print(formatter.name .. ' complete')
-- end

local function format_file()
  local formatting_clients = vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/formatting' })
  if #formatting_clients > 0 then
    vim.lsp.buf.format({ async = false })
    return
  end

  if vim.bo.filetype ~= 'ruby' then
    vim.notify('No formatter available for filetype: ' .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end

  local standardrb = vim.fn.expand('~/.config/rbenv/shims/standardrb')
  local file = vim.fn.expand('%:p')
  vim.cmd('write')
  local output = vim.fn.system({ standardrb, '--fix', file })
  vim.cmd('edit!')
  if vim.v.shell_error > 1 then
    vim.notify('standardrb failed: ' .. output, vim.log.levels.ERROR)
    return
  end
  vim.notify('Formatted with standardrb (project has no LSP formatter)')
end

local function vscode_action(command, opts)
  return function()
    require('vscode').action(command, opts)
  end
end

local function vscode_quick_open(directory)
  return vscode_action('workbench.action.quickOpen', { args = { directory } })
end

local function vscode_toggle_indent_guides()
  local vscode = require('vscode')
  local enabled = vscode.get_config('editor.guides.indentation')
  vscode.update_config('editor.guides.indentation', not enabled, 'global')
end

local common_keymap_defs = {
  -- General
  -- { 'n', '<leader>sc', '<cmd>vsp services/api/db/schema.rb<cr>', 'Open schema' },
  { 'n', '<leader>p', '<cmd>set paste<cr><esc>"*]p<cmd>set nopaste<cr>', 'Paste from clipboard' },
  { 'n', '<leader>b', '<cmd>bprevious<cr>', 'Previous buffer' },
  { 'n', '<leader>n', '<cmd>bnext<cr>', 'Next buffer' },
  { 'n', '<Esc>', '<cmd>noh<cr><Esc>', 'Clear highlights' },
  { 'n', 'Q', '<cmd>q<cr>', 'Quit' },
  { 'v', 'Q', '<cmd>q<cr>', 'Quit' },
  { 'n', ',', '<cmd>w<cr><C-^>', 'Save and switch' },
  { 'n', '<leader>fs', '1z=', 'Fix spelling' },

  -- Projectionist
  { 'n', '<leader>va', '<cmd>AV<cr>', 'Alternate file' },
}

local terminal_keymap_defs = {
  -- Window splits
  { 'n', 'ss', '<cmd>sp<cr>', 'Split horizontal' },
  { 'n', 'vv', '<cmd>vsp<cr>', 'Split vertical' },
  { 'n', '<C-j>', '<C-W><C-J>', 'Window down' },
  { 'n', '<C-k>', '<C-W><C-K>', 'Window up' },
  { 'n', '<C-l>', '<C-W><C-L>', 'Window right' },
  { 'n', '<C-h>', '<C-W><C-H>', 'Window left' },

  -- Terminal
  { 'n', '<C-`>', '<cmd>split | terminal<cr>', 'Open terminal' },
  { 't', '<C-`>', '<cmd>close<cr>', 'Close terminal' },
  { 't', '<Leader><ESC>', '<C-\\><C-n>', 'Exit terminal mode' },
  { 't', '<C-h>', '<C-\\><C-n><C-W>h', 'Terminal window left' },
  { 't', '<C-j>', '<C-\\><C-n><C-W>j', 'Terminal window down' },
  { 't', '<C-k>', '<C-\\><C-n><C-W>k', 'Terminal window up' },
  { 't', '<C-l>', '<C-\\><C-n><C-W>l', 'Terminal window right' },

  -- Diagnostics
  { 'n', '<Leader>d', '<cmd>lua vim.diagnostic.open_float()<cr>', 'Open Float' },

  -- Tabs
  { 'n', 'th', '<cmd>tabfirst<cr>', 'First tab' },
  { 'n', 'tj', '<cmd>tabnext<cr>', 'Next tab' },
  { 'n', 'tk', '<cmd>tabprev<cr>', 'Previous tab' },
  { 'n', 'tl', '<cmd>tablast<cr>', 'Last tab' },
  { 'n', 'tn', '<cmd>tabnext<cr>', 'Next tab' },
  { 'n', 'td', '<cmd>tabclose<cr>', 'Close tab' },
  { 'n', '<C-S-h>', '<cmd>tabprev<cr>', 'Tab left' },
  { 'n', '<C-S-l>', '<cmd>tabnext<cr>', 'Tab right' },

  -- Claude Code
  { 'n', '<leader>k', '<cmd>ClaudeCode<cr>', 'Toggle Claude Code' },
  { 'n', '<leader>K', '<cmd>ClaudeCodeFocus<cr>', 'Focus Claude Code' },
  { 'v', '<leader>y', '<cmd>ClaudeCodeSend<cr>', 'Send selection to Claude' },
  { 'n', '<leader>j', '<cmd>ClaudeCodeAdd %<cr>', 'Add current buffer' },

  -- language server functions
  { 'n', 'gd', vim.lsp.buf.definition, 'Go to definition' },
  { 'n', 'gr', vim.lsp.buf.references, 'Go to references' },
  { 'n', 'gi', vim.lsp.buf.implementation, 'Go to implementation' },
  { 'n', 'K', vim.lsp.buf.hover, 'Hover documentation' },
  { 'n', '<leader>rn', vim.lsp.buf.rename, 'Rename' },
  { 'n', '<leader>f', format_file, 'Format file' },

  -- Telescope
  { 'n', '<leader>t', '<cmd>Telescope find_files<cr>', 'Find files' },
  { 'n', '<leader>tm', '<cmd>Telescope find_files cwd=services/api/app/models<cr>', 'Find models' },
  { 'n', '<leader>tc', '<cmd>Telescope find_files cwd=services/api/app/controllers<cr>', 'Find controllers' },
  { 'n', '<leader>tv', '<cmd>Telescope find_files cwd=services/api/app/views<cr>', 'Find views' },
  { 'n', '<leader>ts', '<cmd>Telescope find_files cwd=services/api/spec<cr>', 'Find specs' },
  { 'n', '<leader>tg', '<cmd>Telescope live_grep<cr>', 'Live grep' },

  -- File tree
  { 'n', '<C-\\>', '<cmd>NvimTreeFindFile<cr>', 'Find file in tree' },

  -- Testing
  { 'n', '<leader>a', '<cmd>TestFile<cr>', 'Test file' },
  { 'n', '<leader>s', '<cmd>TestNearest<cr>', 'Test nearest' },
  { 'n', '<leader>l', '<cmd>TestLast<cr>', 'Test last' },
  { 'n', '<leader>aa', '<cmd>TestSuite<cr>', 'Test suite' },

  -- Indent guides
  { 'n', '<leader>ig', '<cmd>IBLToggle<cr>', 'Toggle indent guides' },

  -- Aerial (code outline)
  { 'n', '<F7>', '<cmd>AerialToggle<cr>', 'Toggle aerial' },

  -- Focus
  { 'n', '<F8>', '<cmd>FocusToggle<cr>', 'Toggle focus' },
  { 'n', '<leader>fm', '<cmd>FocusMaximise<cr>', 'Maximise window' },
  { 'n', '<leader>fe', '<cmd>FocusEqualise<cr>', 'Equalise windows' },
}

local vscode_keymap_defs = {
  -- Window splits
  { 'n', 'ss', vscode_action('workbench.action.splitEditorDown'), 'Split horizontal' },
  { 'n', 'vv', vscode_action('workbench.action.splitEditorRight'), 'Split vertical' },

  -- Diagnostics
  { 'n', '<Leader>d', vscode_action('editor.action.showHover'), 'Open Float' },

  -- Tabs
  { 'n', 'th', vscode_action('workbench.action.firstEditorInGroup'), 'First tab' },
  { 'n', 'tj', vscode_action('workbench.action.nextEditorInGroup'), 'Next tab' },
  { 'n', 'tk', vscode_action('workbench.action.previousEditorInGroup'), 'Previous tab' },
  { 'n', 'tl', vscode_action('workbench.action.lastEditorInGroup'), 'Last tab' },
  { 'n', 'tn', vscode_action('workbench.action.nextEditorInGroup'), 'Next tab' },
  { 'n', 'td', vscode_action('workbench.action.closeActiveEditor'), 'Close tab' },

  -- Claude Code
  { 'n', '<leader>k', vscode_action('claude-vscode.focus'), 'Focus Claude Code' },
  { 'n', '<leader>K', vscode_action('claude-vscode.blur'), 'Blur Claude Code' },
  { 'v', '<leader>y', vscode_action('claude-vscode.insertAtMention'), 'Send selection to Claude' },
  { 'n', '<leader>j', vscode_action('claude-vscode.insertAtMention'), 'Add current buffer' },

  -- language server functions
  { 'n', 'gd', vscode_action('editor.action.revealDefinition'), 'Go to definition' },
  { 'n', 'gr', vscode_action('editor.action.goToReferences'), 'Go to references' },
  { 'n', 'gi', vscode_action('editor.action.goToImplementation'), 'Go to implementation' },
  { 'n', 'K', vscode_action('editor.action.showHover'), 'Hover documentation' },
  { 'n', '<leader>rn', vscode_action('editor.action.rename'), 'Rename' },
  { 'n', '<leader>f', vscode_action('editor.action.formatDocument'), 'Format file' },

  -- Telescope
  { 'n', '<leader>t', vscode_action('workbench.action.quickOpen'), 'Find files' },
  { 'n', '<leader>tm', vscode_quick_open('services/api/app/models/'), 'Find models' },
  { 'n', '<leader>tc', vscode_quick_open('services/api/app/controllers/'), 'Find controllers' },
  { 'n', '<leader>tv', vscode_quick_open('services/api/app/views/'), 'Find views' },
  { 'n', '<leader>ts', vscode_quick_open('services/api/spec/'), 'Find specs' },
  { 'n', '<leader>tg', vscode_action('workbench.action.findInFiles'), 'Live grep' },

  -- Testing
  { 'n', '<leader>a', vscode_action('extension.runFileOnRspec'), 'Test file' },
  { 'n', '<leader>s', vscode_action('extension.runLineOnRspec'), 'Test nearest' },
  { 'n', '<leader>l', vscode_action('extension.runOnLastSpec'), 'Test last' },
  { 'n', '<leader>aa', vscode_action('extension.runAllFilesOnRspec'), 'Test suite' },

  -- Indent guides
  { 'n', '<leader>ig', vscode_toggle_indent_guides, 'Toggle indent guides' },

  -- Focus
  { 'n', '<leader>fm', vscode_action('workbench.action.toggleMaximizeEditorGroup'), 'Maximise window' },
  { 'n', '<leader>fe', vscode_action('workbench.action.evenEditorWidths'), 'Equalise windows' },
}


-- Query Neovim directly for keymaps with our marker, then delete them
local function clear_keymaps()
  for _, mode in ipairs({ 'n', 'v', 't' }) do
    local maps = vim.api.nvim_get_keymap(mode)
    for _, map in ipairs(maps) do
      if map.desc and map.desc:sub(1, #MARKER) == MARKER then
        pcall(vim.keymap.del, mode, map.lhs)
      end
    end
  end
end

function M.setup()
  clear_keymaps()
  local defs = vim.list_extend({}, common_keymap_defs)
  if vim.g.vscode then
    vim.list_extend(defs, vscode_keymap_defs)
  else
    vim.list_extend(defs, terminal_keymap_defs)
  end
  for _, km in ipairs(defs) do
    vim.keymap.set(km[1], km[2], km[3], { desc = MARKER .. km[4] })
  end
end

function M.reload()
  package.loaded["keymaps"] = nil
  require("keymaps").setup()
  print("Keymaps reloaded")
end

return M
