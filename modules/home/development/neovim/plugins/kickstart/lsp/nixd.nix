{
  lib,
  config,
  ...
}:
let
  name = "nixd";
  cfg = config.home.development.neovim.lsp.${name};
in
{
  options.home.development.neovim.lsp.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} LSP for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins.lsp.servers.nixd = {
      enable = true;
      # NOTE: add options as I need
      settings = {
        nixpkgs = {
          # For flake.
          # "expr": "import (builtins.getFlake \"/home/lyc/workspace/CS/OS/NixOS/flakes\").inputs.nixpkgs { }   "

          # This expression will be interpreted as "nixpkgs" toplevel
          # Nixd provides package, lib completion/information from it.
          #
          # Resource Usage: Entries are lazily evaluated, entire nixpkgs takes 200~300MB for just "names".
          #                Package documentation, versions, are evaluated by-need.
          expr = "import <nixpkgs> { }";
        };
        # TODO: figure out how to include nixos and home configurations
        # completion :(
        # Tell the language server your desired option set, for completion
        # This is lazily evaluated.
        options = {
          # Map of eval information
          # If this is omitted, default search path (<nixpkgs>) will be used.
          nixos = {
            # This name "nixos" could be arbitrary.
            # The expression to eval, interpret it as option declarations.

            expr = ''
              (builtins.getFlake ("git+file://" + toString /home/justinhoang/nixos-config)).nixosConfigurations."penguin".options;
            '';
          };

          darwin = {
            # This name "nixos" could be arbitrary.
            # The expression to eval, interpret it as option declarations.

            expr = ''
              (builtins.getFlake ("git+file://" + toString /Users/justinhoang/nixos-config)).darwinConfigurations."mbp3".options;
            '';
          };

          # TODO: implement standalone home manager configuration first
          # # By default there is no home-manager options completion, thus you can
          # # add this entry.
          home-manager = {
            expr = ''
              (builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."wsl".options;
            '';
          };
        };
      };
    };
  };
}
