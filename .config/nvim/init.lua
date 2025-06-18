-- ~/.config/nvim/init.lua

-- Basic settings (from before)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.signcolumn = "yes" -- Keep signcolumn always visible

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Plugin Manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins Setup
require("lazy").setup({
  -- 1. Theme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = { strings = true, comments = true, operators = false, folds = true },
        strikethrough = true,
        invert_selection = false,
        contrast = "soft",
        palette_overrides = {
          -- For your muted theme, you might soften these further:
          -- bright_green = "#A8A830", -- Example: Softer bright green
          -- bright_blue = "#80A090",  -- Example: Softer bright blue
        },
        overrides = {
             LineNr = { fg = "#665c54" }, -- Muted line numbers
             -- Add more overrides for specific highlight groups if needed
        },
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.cmd.colorscheme "gruvbox"
    end,
  },

  -- 2. Enhanced Syntax Highlighting (Treesitter)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Installs/updates parsers
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "python", "rust", "go", "javascript", "typescript", "html", "css", "json", "yaml", "bash", "markdown", "markdown_inline" }, -- Add languages you use
        sync_install = false, -- install parsers asynchronously
        auto_install = true,  -- automatically install new parsers when needed
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>", -- Start selection one level up
            node_incremental = "<c-space>", -- Increment selection
            scope_incremental = "<c-s>", -- Increment selection by scope
            node_decremental = "<c-backspace>", -- Decrement selection
          },
        },
        textobjects = { -- Enable text objects for Treesitter
          select = {
            enable = true,
            lookahead = true, -- Higher performance for text object selection
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              -- Add more text objects based on your needs / installed parsers
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })
    end
  },
  -- Treesitter textobjects (optional, but recommended for the above config)
  'nvim-treesitter/nvim-treesitter-textobjects',


  -- 3. LSP (Language Server Protocol) Configuration
  {
    "neovim/nvim-lspconfig", -- Core LSP configuration plugin
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      -- {'j-hui/fidget.nvim', tag = "legacy", opts = {}}, -- if using nvim < 0.10.0
      {'j-hui/fidget.nvim', opts = {}}, -- if using nvim >= 0.10.0

      -- Autocompletion
      "hrsh7th/nvim-cmp",         -- Autocompletion plugin
      "hrsh7th/cmp-nvim-lsp",     -- LSP source for nvim-cmp
      "hrsh7th/cmp-buffer",       -- Buffer source for nvim-cmp
      "hrsh7th/cmp-path",         -- Path source for nvim-cmp
      "hrsh7th/cmp-cmdline",      -- Cmdline source for nvim-cmp
      "L3MON4D3/LuaSnip",         -- Snippet engine
      "saadparwaiz1/cmp_luasnip", -- Snippet source for nvim-cmp
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')

      -- Setup mason so it can manage LSP server installations
      require("mason").setup()
      mason_lspconfig.setup({
        -- List of LSPs to automatically install if they're not already installed.
        -- Add servers for languages you use, e.g. "pyright", "rust_analyzer", "gopls", "tsserver", "bashls", "lua_ls"
        ensure_installed = { "lua_ls", "bashls", "rust_analyzer", "pyright" },
      })

      -- Configure LSP servers
      mason_lspconfig.setup_handlers {
        function(server_name) -- Default handler
          lspconfig[server_name].setup {
            capabilities = capabilities,
          }
        end,
        -- Example custom setup for a server:
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = {'vim'} },
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
              }
            }
          }
        end,
      }

      -- nvim-cmp setup
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })

      -- Additional LSP keymaps (place these in on_attach or globally)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<leader>sh', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>fm', function() vim.lsp.buf.format { async = true } end, opts) -- Format code
          -- Diagnostics
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>dl', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, opts)
        end
      })

      -- Optional: Configure diagnostics to show icons etc.
      vim.diagnostic.config({
        virtual_text = true, -- Show errors inline
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          source = "always", -- Or "if_many"
        },
      })
      -- Define diagnostic signs with Nerd Font icons
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end
  },

  -- 4. Other Useful Plugins
  { 'tpope/vim-fugitive' }, -- Git wrapper
  { 'tpope/vim-rhubarb' },  -- GitHub extension for fugitive
  { 'tpope/vim-commentary' }, -- Easy commenting (gcc, gc)
  {
    'nvim-lualine/lualine.nvim', -- Status line
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Icons for lualine
    config = function()
      require('lualine').setup {
        options = {
          theme = 'gruvbox', -- Or 'auto' or a specific lualine gruvbox theme like 'gruvbox-material'
          -- You can customize sections and components here
        },
      }
    end
  },
  { -- Auto pairs for (), [], {} etc.
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- use default options
  },
  { -- Which-key: shows available keybinds when you press leader
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
    }
  },

  -- Telesope (Fuzzy Finder)
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup{
            defaults = {
                -- layout_strategy = 'horizontal',
                -- layout_config = { preview_width = 0.55 },
            },
            -- Add more telescope configurations if needed
        }
        -- Keymaps for Telescope
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find Files" })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live Grep" })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers" })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help Tags" })
    end
  },

}) -- End of require("lazy").setup

-- Ensure Mason's bin path is added to PATH for LSP servers
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
