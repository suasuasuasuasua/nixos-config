{
  description = "suasuasuasuasua's nixos configuration";

  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    # packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11"; # head
      # url = "github:LnL7/nix-darwin/master"; # unstable
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11"; # head
      # url = "github:nix-community/home-manager"; # unstable
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # utility
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko.url = "github:nix-community/disko/latest";
    rpi-nix.url = "github:nix-community/raspberry-pi-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    # software inputs
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extras
    catppuccin.url = "github:catppuccin/nix";
    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      # Supported systems for your flake packages, shell, etc.
      systems = [
        # linux
        "aarch64-linux"
        "x86_64-linux"
        # macOS
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      lib = nixpkgs.lib // nix-darwin.lib // home-manager.lib;
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = forEachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      inherit lib;

      overlays = import ./overlays { inherit inputs outputs; };
      formatter = forEachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      checks = (lib.genAttrs systems) (system: {
        formatting =
          let
            pkgs = import nixpkgs { inherit system; };
          in
          treefmtEval.${pkgs.system}.config.build.check self;
        git-hooks-check = inputs.git-hooks-nix.lib.${system}.run {
          src = ./.;
          hooks = {
            # Docs
            markdownlint.enable = true; # format markdown files

            # Git
            commitizen.enable = true; # ensure conventional commits standard
            ripsecrets.enable = true; # remove any hardcoded secrets

            # General
            check-added-large-files.enable = true; # warning about large files (lfs?)
            check-merge-conflicts.enable = true; # don't commit merge conflicts
            end-of-file-fixer.enable = true; # add a line at the end of the file
            trim-trailing-whitespace.enable = true; # trim trailing whitespace

            # Nix
            nixfmt-rfc-style.enable = true; # format nix files to rfc standards
            deadnix.enable = true; # remove any unused variabes and imports
            # https://github.com/determinatesystems/flake-checker/issues/156
            flake-checker.enable = false; # run `flake check`
            statix.enable = true; # check "good practices" for nix
            nil.enable = true; # lsp that also has formatter

            # Shell
            beautysh.enable = true; # format bash files
            shellcheck.enable = true; # static shell script checker
            shfmt.enable = true; # another formatter
          };
        };
      });
      devShells = (lib.genAttrs systems) (system: {
        default =
          let
            pkgs = import nixpkgs {
              inherit system;
            };
          in
          pkgs.mkShell {
            # enable the shell hooks
            inherit (self.checks.${system}.git-hooks-check) shellHook;

            NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
            buildInputs = self.checks.${system}.git-hooks-check.enabledPackages;

            # define the programs available when running `nix develop`
            packages =
              [
                # general nix programs
                # NOTE: for some reason being shadowed by home-manager argument
                pkgs.home-manager
                pkgs.nix
              ]
              ++ (with pkgs; [
                # source control
                git # source control program
                commitizen # templated commits and bumping

                # commands
                just # command runner

                # lsp
                nil # lsp 1 (don't ask)
                nixd # lsp 2 (don't ask)
                nixfmt-rfc-style # nix formatter
                markdownlint-cli # markdown linter

                # cli
                fastfetch # system information
                btop # system monitoring
              ]);
          };
      });

      nixosConfigurations = {
        penguin = lib.nixosSystem {
          modules = [
            ./configurations/nixos/penguin

            home-manager.nixosModules.home-manager
            ./configurations/home/justinhoang.nix
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };

      darwinConfigurations = {
        "mbp3" = lib.darwinSystem {
          modules = [
            ./configurations/darwin/mbp3

            home-manager.darwinModules.home-manager
            ./configurations/home/justinhoang.nix
          ];
          specialArgs = {
            inherit self inputs outputs;
          };
        };
      };
    };

  # use cachix for faster builds in places
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://pre-commit-hooks.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
  };
}
