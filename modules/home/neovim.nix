{ pkgs, ... }:

# Neovim with Rosé Pine + essential plugins, all managed by Nix.
# Plugin configs use the per-plugin `config` attribute so each setup()
# call runs after the plugin is in neovim's runtimepath.
{
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;
    withRuby      = false;
    withPython3   = false;

    plugins = with pkgs.vimPlugins; [

      # ── Theme ───────────────────────────────────────────────────────────────
      rose-pine
      nvim-web-devicons   # icons (used by nvim-tree, lualine, telescope)

      # ── File tree ───────────────────────────────────────────────────────────
      {
        plugin = nvim-tree-lua;
        type   = "lua";
        config = ''require("nvim-tree").setup()'';
      }

      # ── Status line ─────────────────────────────────────────────────────────
      {
        plugin = lualine-nvim;
        type   = "lua";
        config = ''require("lualine").setup({ options = { theme = "rose-pine" } })'';
      }

      # ── Fuzzy finder ────────────────────────────────────────────────────────
      telescope-fzf-native-nvim
      {
        plugin = telescope-nvim;
        type   = "lua";
        config = ''require("telescope").setup()'';
      }

      # ── Syntax highlighting ─────────────────────────────────────────────────
      {
        plugin = nvim-treesitter.withAllGrammars;
        type   = "lua";
        config = ''
          require("nvim-treesitter.configs").setup({
            highlight = { enable = true },
            indent    = { enable = true },
          })
        '';
      }

      # ── Editing helpers ─────────────────────────────────────────────────────
      {
        plugin = nvim-autopairs;
        type   = "lua";
        config = ''require("nvim-autopairs").setup()'';
      }
      {
        plugin = nvim-surround;
        type   = "lua";
        config = ''require("nvim-surround").setup()'';
      }
      {
        plugin = comment-nvim;
        type   = "lua";
        config = ''require("Comment").setup()'';
      }

      # ── Git ─────────────────────────────────────────────────────────────────
      {
        plugin = gitsigns-nvim;
        type   = "lua";
        config = ''require("gitsigns").setup()'';
      }

      # ── Keybinding hints ────────────────────────────────────────────────────
      {
        plugin = which-key-nvim;
        type   = "lua";
        config = ''require("which-key").setup()'';
      }
    ];

    # ── Core options, theme, and keymaps ─────────────────────────────────────
    # Only pure vim options here — no plugin `require()` calls.
    # Plugin setup lives in each plugin's `config` block above.
    initLua = ''
      -- ── Options ─────────────────────────────────────────────────────────────
      local opt = vim.opt
      opt.number         = true
      opt.relativenumber = true
      opt.cursorline     = true
      opt.signcolumn     = "yes"
      opt.tabstop        = 2
      opt.shiftwidth     = 2
      opt.expandtab      = true
      opt.smartindent    = true
      opt.wrap           = false
      opt.scrolloff      = 8
      opt.sidescrolloff  = 8
      opt.termguicolors  = true
      opt.clipboard      = "unnamedplus"
      opt.ignorecase     = true
      opt.smartcase      = true
      opt.updatetime     = 250
      opt.splitright     = true
      opt.splitbelow     = true

      -- ── Theme ────────────────────────────────────────────────────────────────
      require("rose-pine").setup({ variant = "main" })
      vim.cmd("colorscheme rose-pine")

      -- ── Leader key ───────────────────────────────────────────────────────────
      vim.g.mapleader      = " "
      vim.g.maplocalleader = "\\"

      -- ── Keymaps ──────────────────────────────────────────────────────────────
      local map = vim.keymap.set
      map("i", "jk", "<Esc>",    { desc = "Escape insert mode" })
      map("n", "<C-h>", "<C-w>h")
      map("n", "<C-j>", "<C-w>j")
      map("n", "<C-k>", "<C-w>k")
      map("n", "<C-l>", "<C-w>l")
      map("v", "J", ":m '>+1<CR>gv=gv")
      map("v", "K", ":m '<-2<CR>gv=gv")
      map("n", "<C-d>", "<C-d>zz")
      map("n", "<C-u>", "<C-u>zz")
      map("n", "<Esc>", ":noh<CR>")
      -- File tree
      map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })
      -- Telescope
      local tel = require("telescope.builtin")
      map("n", "<C-p>",      tel.find_files, { desc = "Find files" })
      map("n", "<C-f>",      tel.live_grep,  { desc = "Search in files" })
      map("n", "<leader>fb", tel.buffers,    { desc = "Find buffers" })
      map("n", "<leader>fh", tel.help_tags,  { desc = "Help tags" })
    '';
  };
}
