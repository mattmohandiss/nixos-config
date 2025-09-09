{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    
    extraPackages = with pkgs; [
      # Language servers
      lua-language-server
      pyright
      nodePackages.typescript-language-server
      
      # Formatters
      stylua
      black
      nodePackages.prettier
      
      # Tools
      ripgrep
      fd
      unzip
      gzip
    ];

    plugins = with pkgs.vimPlugins; [
      # Core dependencies
      plenary-nvim
      nvim-web-devicons
      
      # Text editing and syntax
      nvim-treesitter.withAllGrammars
      comment-nvim
      nvim-autopairs
      
      # Search and navigation
      telescope-nvim
      wilder-nvim
      
      # Completion system
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      friendly-snippets
      
      # Language server protocol
      nvim-lspconfig
      
      # User interface
      lualine-nvim
      bufferline-nvim
      gitsigns-nvim
      indent-blankline-nvim
      which-key-nvim
    ];

    extraLuaConfig = ''
      dofile("/etc/nixos/mattm/configs/neovim/init.lua")
    '';
  };
}
