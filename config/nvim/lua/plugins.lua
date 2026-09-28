local plugins = {
  -- Core LSP configuration. Provides the foundation for connecting to language servers
  -- that give you code intelligence (completions, diagnostics, go-to-definition).
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },

  -- Package manager for LSP servers, formatters, linters, things that get installed outside of vim.
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },

  -- Auto-installs Mason tools on startup. Ensures shellcheck and shfmt are always
  -- available without manual :MasonInstall commands.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "shellcheck",
          "shfmt",
        },
        auto_update = true,
        run_on_start = true,
      })
    end,
  },

  -- Bridges mason.nvim and lspconfig. Automatically configures LSP servers
  -- installed by Mason so you don't have to manually wire them up.
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "bashls", "ts_ls" },
      })

      vim.lsp.config('ruby_lsp', {
        cmd = { vim.fn.expand('~/.config/rbenv/shims/ruby-lsp') },
        filetypes = { 'ruby' },
        root_dir = function(bufnr, on_dir)
          local root = vim.fs.root(vim.api.nvim_buf_get_name(bufnr), { 'Gemfile', '.git', '.ruby-version' })
          if root and root ~= vim.env.HOME then
            on_dir(root)
          end
        end,
      })

      vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.git' },
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      })

      vim.lsp.config('bashls', {
        cmd = { 'bash-language-server', 'start' },
        filetypes = { 'sh', 'bash', 'zsh' },
        root_markers = { '.git' },
        settings = {
          bashIde = {
            shellcheckPath = vim.fn.stdpath("data") .. "/mason/bin/shellcheck",
          },
        },
      })

      vim.lsp.config('ts_ls', {
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/typescript-language-server", '--stdio' },
        filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
        root_markers = { 'tsconfig.json', 'package.json', '.git' },
      })

      vim.lsp.enable({ 'ruby_lsp', 'lua_ls', 'bashls', 'ts_ls' })
    end,
  },

  -- Autocompletion engine. Shows popup menus with completions from LSP, snippets,
  -- buffer words, and file paths. Tab/Shift-Tab to navigate, Enter to confirm.
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
      })
    end,
  },

  -- Fuzzy finder for files, buffers, grep results, and more. The go-to tool for
  -- quickly navigating your project. <leader>ff for files, <leader>fg for grep.
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('telescope').setup({
        defaults = {
          layout_config = {
            horizontal = { height = 0.4 },
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob", "*",
            "--glob", "!.git/",
            "--glob", "!node_modules/",
            "--glob", "!log/",
            "--glob", "!tmp/",
            "--glob", "!**/coverage/",
            "--glob", "!**/.*/**"
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "--glob", "*", "--glob", "!.git/", "--glob", "!node_modules/", "--glob", "!log/", "--glob", "!tmp/", "--glob", "!**/coverage/" },
          },
        },
      })
    end,
  },

  -- File explorer sidebar. Toggle with <leader>e or :NvimTreeToggle.
  -- Shows project structure with git status indicators.
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { side = "left", width = 30 },
        renderer = { group_empty = true },
        filters = {
          dotfiles = false,
          git_ignored = false,
          custom = { "coverage" },
        },
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
      })
    end,
  },

  -- Status line at the bottom of the screen. Shows mode, file, git branch,
  -- diagnostics, and cursor position in a clean, minimal format.
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          component_separators = '|',
          section_separators = '',
        },
      })
    end,
  },

  -- Syntax highlighting and code parsing using tree-sitter grammars. Much more
  -- accurate than regex-based highlighting. Also enables better indentation.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      local parsers = { "ruby", "lua", "vim", "vimdoc", "javascript", "typescript", "tsx", "html", "css", "bash" }
      ts.install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "ruby", "lua", "vim", "help", "javascript", "typescript", "typescriptreact", "html", "css", "sh", "bash", "zsh" },
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- Connects external formatters to the LSP interface. Runs shfmt for shell
  -- script formatting. Shellcheck diagnostics come from bashls.
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "williamboman/mason.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.shfmt.with({
            command = mason_bin .. "/shfmt",
            extra_args = { "-i", "2", "-bn", "-ci", "-sr" },
            filetypes = { "sh", "zsh" },
          }),
        },
      })
    end,
  },

  -- Git wrapper. :Git (or :G) for git status, :Git blame, :Git diff, :Git log.
  -- The most powerful git integration for vim.
  { "tpope/vim-fugitive" },

  -- Side-by-side diff viewer for git. :DiffviewOpen develop shows all changes
  -- vs a branch. Much easier than reading raw diffs.
  { "sindrets/diffview.nvim" },

  -- Rails navigation and commands. :A for alternate file (test<->implementation),
  -- :R for related, gf on partials, and :Rails commands.
  { "tpope/vim-rails" },

  -- Bundler integration. :Bundle, gf on gem names in Gemfile to jump to source.
  { "tpope/vim-bundler" },

  -- Auto-adds end after if, do, def in Ruby and other languages. Saves keystrokes.
  { "tpope/vim-endwise" },

  -- Makes . (repeat) work with plugin mappings. Essential for surround, commentary.
  { "tpope/vim-repeat" },

  -- Bracket mappings for next/prev navigation. [q ]q for quickfix, [b ]b for buffers,
  -- [<Space> ]<Space> to add blank lines, and many more.
  { "tpope/vim-unimpaired" },

  -- Async build/test runner. :Make runs in background, populates quickfix.
  -- :Dispatch rspec % runs current file's tests asynchronously.
  { "tpope/vim-dispatch" },

  -- Comment/uncomment with gc. gcc for current line, gc in visual mode for selection.
  { "tpope/vim-commentary" },

  -- Surround text objects. cs"' changes "text" to 'text'. ds" deletes quotes.
  -- ysiw) surrounds word with parens. Works with tags, brackets, quotes.
  { "tpope/vim-surround" },

  -- Test runner integration. :TestNearest, :TestFile, :TestSuite, :TestLast.
  -- Configured here to run RSpec in a vertical split terminal.
  {
    "vim-test/vim-test",
    config = function()
      vim.g['test#strategy'] = 'neovim'
      vim.g['test#neovim#term_position'] = 'vertical botright'
      vim.g['test#ruby#rspec#executable'] = 'bundle exec rspec'
    end,
  },

  -- Git signs in the gutter (added/changed/deleted lines). Also provides
  -- :Gitsigns blame_line, stage_hunk, preview_hunk, and more.
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup()
    end,
  },

  -- Indent guides (vertical lines showing indentation levels). Currently disabled
  -- but available via :IBLEnable when you want visual indent markers.
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        enabled = false
      })
    end,
  },

  -- Code outline/symbol browser. :AerialToggle shows functions, classes, methods
  -- in a sidebar for quick navigation in large files.
  {
    "stevearc/aerial.nvim",
    config = function()
      require("aerial").setup()
    end,
  },

  -- Color schemes. codesmell_dark, gruvbox, and gotham (currently active).
  { "whatsthatsmell/codesmell_dark.vim" },
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  { "whatyouhide/vim-gotham", commit = "747ee82960b4a7ed75ac133bb84bfc02b5ac9e27" },

  -- Emmet for HTML/CSS expansion. Type div.container>ul>li*3 then <C-y>, to expand.
  { "mattn/emmet-vim" },

  -- Text alignment. :Tabularize /= aligns on equals signs. :Tabularize /: for colons.
  { "godlygeek/tabular" },

  -- Project-specific alternate file mappings. Define relationships in .projections.json
  -- like test<->implementation, controller<->view, etc. :A jumps to alternate.
  {
    "tpope/vim-projectionist",
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "ProjectionistDetect",
        callback = function()
          local projections_file = vim.fn.getcwd() .. '/.projections.json'
          if vim.fn.filereadable(projections_file) == 1 then
            local json_content = table.concat(vim.fn.readfile(projections_file), "\n")
            local projections = vim.fn.json_decode(json_content)
            vim.fn['projectionist#append'](vim.fn.getcwd(), projections)
          end
        end,
      })
    end,
  },

  -- Collection of small utilities by folke. Used here as a dependency for claudecode.nvim.
  -- Features are disabled since we only need it for the terminal management.
  {
    "folke/snacks.nvim",
    lazy = true,
    opts = {
      bigfile = { enabled = false },
      notifier = { enabled = false },
      quickfile = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
    },
  },

  -- Claude Code integration. Opens Claude CLI in a right-side terminal split.
  -- :ClaudeCode to toggle, or use your keybinding.
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    lazy = false,
    config = function()
      require("claudecode").setup({
        terminal_cmd = os.getenv("HOME") .. "/.config/nvim/scripts/claude-wrapper.sh",
        terminal = {
          split_side = "right",
          split_width_percentage = 0.30,
          snacks_win_opts = {
            position = "bottom",
            height = 0.3,
          },
        },
      })
    end,
  },

  -- -- Local plugin for browsing Claude conversation history.
  -- {
  --   dir = "~/Personal/claude-explorer.nvim",
  --   config = function()
  --     require("claude-explorer").setup()
  --   end,
  -- },

  -- Auto-resizes splits using golden ratio. The focused window gets more space,
  -- unfocused windows shrink but stay readable. Makes split navigation fluid.
  {
    "nvim-focus/focus.nvim",
    version = false,
    lazy = false,
    config = function()
      require("focus").setup({
        enable = true,
        autoresize = {
          enable = true,
          width = 120,
          height = 40,
          minwidth = 10,
          minheight = 5,
          height_quickfix = 10,
        },
        split = {
          bufnew = false,
          tmux = false,
        },
        ui = {
          number = false,
          relativenumber = false,
          hybridnumber = false,
          absolutenumber_unfocussed = false,
          cursorline = true,
          cursorcolumn = false,
          colorcolumn = {
            enable = false,
            list = '+1',
          },
          signcolumn = true,
          winhighlight = false,
        },
      })

      local resizer = require("focus.modules.resizer")
      local original_split_resizer = resizer.split_resizer
      resizer.split_resizer = function(config, goal)
        local saved_states = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_is_valid(win) then
            saved_states[win] = vim.wo[win].diff
            vim.wo[win].diff = false
          end
        end

        local ok, result = pcall(original_split_resizer, config, goal)

        for win, state in pairs(saved_states) do
          if vim.api.nvim_win_is_valid(win) then
            vim.wo[win].diff = state
          end
        end

        if not ok then error(result) end
        return result
      end
    end,
  },
}

if vim.g.vscode then
  local vscode_allowlist = {
    ["tpope/vim-repeat"] = true,
    ["tpope/vim-surround"] = true,
    ["tpope/vim-commentary"] = true,
    ["tpope/vim-unimpaired"] = true,
    ["tpope/vim-endwise"] = true,
    ["godlygeek/tabular"] = true,
    ["tpope/vim-rails"] = true,
    ["tpope/vim-bundler"] = true,
    ["tpope/vim-projectionist"] = true,
  }

  return vim.tbl_filter(function(spec)
    return vscode_allowlist[spec[1]] == true
  end, plugins)
end

return plugins
