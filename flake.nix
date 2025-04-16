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
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
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
      pkgsFor = lib.genAttrs systems (system: nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = forEachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

      # Helper function for making nixos and darwin user configurations
      defineUsers =
        acc:
        { username, system }:
        let
          pkgs = pkgsFor.${system};
        in
        {
          ${username} =
            import ./configurations/home/base.nix {
              inherit lib pkgs username;
            }
            // acc;
        };
      # Helper function for making nixos systems
      defineNixosSystem =
        name: usernames:
        lib.nixosSystem {
          modules = [
            ./configurations/nixos/${name}
            home-manager.nixosModules.home-manager
            (import ./configurations/home/module.nix {
              inherit inputs outputs;
              # build the attrset
              # https://noogle.dev/f/builtins/foldl'
              users = builtins.foldl' defineUsers { } usernames;
            })
          ];
          # Pass these arguments through the modules
          specialArgs = {
            inherit inputs outputs;
          };
        };
      # Helper function for making darwin systems
      defineDarwinSystem =
        name: usernames:
        lib.darwinSystem {
          modules = [
            ./configurations/darwin/${name}
            home-manager.darwinModules.home-manager
            (import ./configurations/home/module.nix {
              inherit inputs outputs;
              # build the attrset
              # https://noogle.dev/f/builtins/foldl'
              users = builtins.foldl' defineUsers { } usernames;
            })
          ];
          # Pass these arguments through the modules
          specialArgs = {
            inherit self inputs outputs;
          };
        };
      # Helper function for making standalone home-manager configurations
      defineHomeConfiguration =
        {
          username,
          system,
          profile,
        }:
        let
          pkgs = pkgsFor.${system};
        in
        lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            (import ./configurations/home/base.nix {
              inherit pkgs lib username;
            })
            ./configurations/home/${profile}.nix
          ];
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
    in
    {
      inherit lib;

      overlays = import ./overlays { inherit inputs; };
      formatter = forEachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      checks = forEachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
        git-hooks-check = inputs.git-hooks-nix.lib.${pkgs.system}.run {
          src = ./.;
          imports = [
            (import ./git-hooks.nix {
              inherit pkgs;
            })
          ];
        };
      });
      devShells = forEachSystem (pkgs: {
        default = import ./shell.nix {
          inherit self pkgs;
        };
      });

      nixosConfigurations = {
        lab = defineNixosSystem "lab" [
          {
            username = "justinhoang";
            system = "x86_64-linux";
          }
        ];
        legion = defineNixosSystem "legion" [
          {
            username = "justinhoang";
            system = "x86_64-linux";
          }
        ];
        penguin = defineNixosSystem "penguin" [
          {
            username = "justinhoang";
            system = "x86_64-linux";
          }
        ];
        pi = defineNixosSystem "pi" [
          {
            username = "justinhoang";
            system = "aarch64-linux";
          }
        ];
      };
      darwinConfigurations = {
        mbp3 = defineDarwinSystem "mbp3" [
          {
            username = "justinhoang";
            system = "aarch64-darwin";
          }
        ];
      };
      homeConfigurations = {
        # windows subsystem for linux
        wsl = defineHomeConfiguration {
          username = "justinhoang";
          system = "x86_64-linux";
          profile = "wsl";
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
