# Neovim Cheatsheet - New Setup

**Leader key:** `Space`

---

## 🔍 File Navigation (Telescope)

**Telescope is a fuzzy finder - these commands OPEN Telescope:**

| Key | Action |
|-----|--------|
| `Space + t` | **Open Telescope** - Find files (fuzzy search) |
| `Space + tm` | **Open Telescope** - Find files in `app/models/` |
| `Space + tc` | **Open Telescope** - Find files in `app/controllers/` |
| `Space + tv` | **Open Telescope** - Find files in `app/views/` |
| `Space + ts` | **Open Telescope** - Find files in `spec/` |
| `Space + tg` | **Open Telescope** - Live grep (search content across files) |

**Once Telescope is open:**
- Type to fuzzy search
- `Ctrl+j/k` or arrow keys - Navigate up/down
- `Enter` - Open file
- `Esc` - Close Telescope

---

## 🌳 File Tree (NvimTree)

| Key | Action |
|-----|--------|
| `Ctrl + \` | Find current file in tree |

**Inside NvimTree:**
- `a` - Create new file/folder
- `d` - Delete file/folder
- `r` - Rename
- `x` - Cut
- `c` - Copy
- `p` - Paste
- `R` - Refresh tree
- `h` - See hidden files
- `g?`- help
- `Enter` - Open file
:help nvim-tree-commands

---

## 🧠 LSP (Language Server - Ruby/Lua)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `K` | Hover documentation (show docs) |
| `Space + d` | Show diagnostic float at cursor |
| `Space + rn` | Rename symbol |
| `Space + f` | Format file (LSP) |

**Auto-installed:**
- `ruby-lsp` - Ruby language server
- `lua_ls` - Lua language server
- `bashls` - Bash language server (with shellcheck)

**Commands:**
- `:checkhealth vim.lsp` - Show LSP status (replaced `:LspInfo` in Neovim 0.12)
- `:lsp restart [name]` - Restart LSP clients (all on current buffer if no name given)
- `:lsp stop [name]` - Stop LSP clients
- `:lsp enable [name]` - Activate an LSP config (e.g. `ruby_lsp`)
- `:lsp disable [name]` - Disable an LSP config (stops it if running)
- `:Mason` - Open Mason package manager UI

### Inline Errors (Diagnostics)

Errors and warnings appear as virtual text at the end of the line (dimmed, after your code).
When multiple diagnostics exist on one line, only the most severe shows inline.

| Key | Action |
|-----|--------|
| `Space + d` | Open floating window with full diagnostic details at cursor |
| `[d` | Jump to previous diagnostic |
| `]d` | Jump to next diagnostic |

**Reading the signs column (left gutter):**
- Red icon = Error
- Yellow icon = Warning
- Blue icon = Info/Hint

**To see all diagnostics in the file:**
- `:lua vim.diagnostic.setloclist()` - Send all diagnostics to the location list, then use `[l` / `]l` to navigate

---

## 🤖 Claude Code Integration

| Key | Action |
|-----|--------|
| `Space + k` | Toggle Claude Code terminal |
| `Space + K` | Focus Claude Code window |
| `Space + y` | Send visual selection to Claude (visual mode) |
| `Space + j` | Add current buffer to Claude context |

---

## ✅ Testing (RSpec via vim-test)

| Key | Action |
|-----|--------|
| `Space + a` | Run current test file |
| `Space + s` | Run test nearest to cursor |
| `Space + l` | Re-run last test |
| `Space + aa` | Run entire test suite |

**Async testing (vim-dispatch):**
- `:Dispatch rspec %` - Run current file's tests asynchronously (results in quickfix)
- `:Make` - Run async build, results in quickfix

---

## 📝 Editing & Completion

| Key | Action |
|-----|--------|
| `Tab` | Next completion item (insert mode) |
| `Shift+Tab` | Previous completion item (insert mode) |
| `Enter` | Accept completion |

**Auto-completion sources:**
- LSP (ruby-lsp, lua_ls)
- Buffer text
- File paths
- Snippets

---

## ✍️ Commenting & Surround (vim-commentary, vim-surround)

**vim-commentary:**

| Key | Action |
|-----|--------|
| `gcc` | Toggle comment on current line |
| `gc{motion}` | Comment over motion (e.g., `gcap` = paragraph, `gc3j` = 3 lines) |
| `gc` (visual) | Comment selection |
| `gcu` | Uncomment adjacent commented lines |

**vim-surround:**

| Key | Action |
|-----|--------|
| `cs"'` | Change surrounding `"` to `'` |
| `cs'<q>` | Change `'` to `<q>...</q>` tags |
| `ds"` | Delete surrounding `"` |
| `dst` | Delete surrounding HTML tag |
| `ysiw"` | Surround word with `"` |
| `yss"` | Surround entire line with `"` |
| `S"` (visual) | Surround selection with `"` |

---

## 🎨 Code Formatting & Alignment

| Key | Action |
|-----|--------|
| `Space + ig` | Toggle indent guides |

**Tabular alignment (`:Tabularize`):**
- `:Tabularize /=` - Align on `=`
- `:Tabularize /:\zs` - Align after `:`
- `:Tabularize /|` - Align on `|` (tables)

**Emmet (HTML/CSS expansion):**
- `<C-y>,` - Expand abbreviation (e.g., `div.container>ul>li*3`)
- `<C-y>d` - Select tag inward
- `<C-y>D` - Select tag outward

---

## 📂 File Management

| Key | Action |
|-----|--------|
| `Space + sc` | Open `db/schema.rb` in split |
| `Space + va` | Open alternate file (spec ↔ impl) |

---

## 📋 Clipboard

| Key | Action |
|-----|--------|
| `Space + p` | Paste from system clipboard |

---

## 🪟 Window/Split Management

| Key | Action |
|-----|--------|
| `ss` | Split horizontal |
| `vv` | Split vertical |
| `Ctrl + h` | Move to left window |
| `Ctrl + j` | Move to down window |
| `Ctrl + k` | Move to up window |
| `Ctrl + l` | Move to right window |
| `F8` | Toggle focus mode (auto-resize windows) |
| `Space + fm` | Maximize current window |
| `Space + fe` | Equalize all windows |

**In terminal mode:**
- `Space + Esc` - Exit terminal mode
- `Ctrl + h/j/k/l` - Navigate windows from terminal (auto-exits terminal mode)

**Toggle terminal:**
- `` Ctrl+` `` - Open/close terminal split

**Opening a terminal:**
- `:Term` - Open terminal in bottom split (25% height)
- `:terminal` - Open terminal in current window

---

## 📑 Buffer Navigation

| Key | Action |
|-----|--------|
| `Space + b` | Previous buffer |
| `Space + n` | Next buffer |
| `,` | Save and switch to alternate buffer |

---

## 🔀 Quick Navigation (vim-unimpaired)

Bracket mappings for quick navigation:

| Key | Action |
|-----|--------|
| `[b` / `]b` | Previous/Next buffer |
| `[q` / `]q` | Previous/Next quickfix item |
| `[l` / `]l` | Previous/Next location list item |
| `[<Space>` | Add blank line above cursor |
| `]<Space>` | Add blank line below cursor |
| `[e` / `]e` | Move line up/down (exchange) |
| `[n` / `]n` | Previous/Next conflict marker |
| `[f` / `]f` | Previous/Next file in directory |

---

## 📑 Tab Management

| Key | Action |
|-----|--------|
| `th` | First tab |
| `tj` / `tn` | Next tab |
| `tk` | Previous tab |
| `tl` | Last tab |
| `td` | Close tab |

---

## 🔧 Utility

| Key | Action |
|-----|--------|
| `Esc` (normal) | Clear search highlights |
| `Q` | Quit |
| `Space + fs` | Fix spelling (apply first suggestion) |
| `F7` | Toggle Aerial (code outline) |

**Auto-reload:** Files automatically reload when changed on disk (git checkout, external edits, etc.)

---

## ⚡ Auto-Behaviors

These happen automatically without any keypress:

| Behavior | Trigger | Description |
|----------|---------|-------------|
| Auto-save | Leave insert mode | Modified files save when you press `Esc` |
| Auto-save | Focus lost | All files save when Neovim loses focus |
| Whitespace cleanup | On save | Trailing whitespace removed automatically |
| Cursor restore | Open file | Jumps to last edit position |
| External reload | Focus gained | Detects and reloads external file changes |
| Cheatsheet tab | Startup | Opens this file in a second tab |

---

## 🎯 Git Integration (vim-fugitive + gitsigns + diffview)

**Gitsigns:** Shows git changes in sign column automatically

**vim-fugitive commands:**
- `:Git` or `:G` - Git status
- `:Git blame` - Git blame
- `:Git diff` - Git diff
- `:Gwrite` - Stage current file
- `:Gread` - Checkout current file

**gitsigns commands:**
- `:Gitsigns stage_hunk` - Stage current hunk
- `:Gitsigns reset_hunk` - Reset current hunk
- `:Gitsigns preview_hunk` - Preview hunk changes in float
- `:Gitsigns blame_line` - Show blame for current line

**diffview commands:**
- `:DiffviewOpen` - Open diff view against current index
- `:DiffviewOpen develop` - Diff current branch against develop
- `:DiffviewClose` - Close diff view
- `:DiffviewFileHistory` - Browse file history for all files
- `:DiffviewFileHistory %` - Browse history of current file

---

## 🔌 Plugin Management (lazy.nvim)

| Command | Action |
|---------|--------|
| `:Lazy` | Open lazy.nvim UI |
| `:Lazy update` | Update all plugins |
| `:Lazy sync` | Install missing + update plugins |
| `:Lazy clean` | Remove unused plugins |

---

## 🏥 Diagnostics & Health

| Command | Action |
|---------|--------|
| `:checkhealth` | Check Neovim health |
| `:checkhealth lsp` | Check LSP health |
| `:checkhealth nvim-treesitter` | Check treesitter health |

---

## 🌈 Syntax Highlighting (Treesitter)

**Auto-installed parsers:** Ruby, Lua, Vim, JavaScript, HTML, CSS

**Commands:**
- `:TSUpdate` - Update all parsers
- `:TSInstall <language>` - Install parser for language

---

## 🎨 Color Scheme

**Current:** `gotham`

**Change:**
```vim
:colorscheme gruvbox
:colorscheme codesmell_dark
```

---

## 💡 Rails-Specific (vim-rails)

**Projectionist mappings:**
- `Space + va` - Alternate file (model ↔ spec, controller ↔ spec, etc.)

**vim-rails navigation:**
- `:Emodel` - Go to model
- `:Econtroller` - Go to controller
- `:Eview` - Go to view
- `:Eschema` - Go to schema

**vim-bundler:**
- `:Bundle` - Run bundle commands
- `gf` on gem name in Gemfile - Jump to gem source code

---

## 🔤 Spell Check

**Disabled by default.** Enable with `:set spell`. When enabled, only checks comments (not code).

**Commands:**
- `]s` - Next misspelling
- `[s` - Previous misspelling
- `z=` - Suggest corrections
- `Space + fs` - Apply first correction
- `zg` - Add to dictionary
- `zw` - Mark as misspelling

---

## 🚀 Pro Tips

1. **Fuzzy find everything:** `Space + t` then type any part of filename
2. **Live grep:** `Space + tg` to search content across all files
3. **Search and replace:** `Space + tg` to find, then `:%s/old/new/gc`
4. **Jump to definition:** Cursor on method/class, press `gd`
5. **See all references:** Cursor on symbol, press `gr`
6. **Quick documentation:** Hover over anything, press `K`
7. **Run test under cursor:** `Space + s` (no need to specify line)
8. **Format file:** `Space + f` runs LSP format (RuboCop for Ruby, shfmt for shell, etc.)
9. **Claude integration:** Select code (visual), `Space+y` to send to Claude
10. **Focus mode:** `F8` to toggle auto-resizing windows (gives you more space)

---

## 📚 Learn More

- `:help telescope` - Telescope docs
- `:help lsp` - LSP docs
- `:help lazy.nvim` - Plugin manager docs
- `:Tutor` - Vim basics tutorial

---

## 🛠️ Configuration

| Item | Location |
|------|----------|
| Main config | `~/.config/nvim/init.lua` |
| Keymaps | `~/.config/nvim/lua/keymaps.lua` |
| This cheatsheet | `~/.config/nvim/CHEATSHEET.md` |

**Reload commands:**
- `:source ~/.config/nvim/init.lua` - Reload entire config (or restart)
- `:lua require("keymaps").reload()` - Hot-reload keymaps only (no restart needed)
