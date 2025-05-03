{
  description = "suasuasuasuasua's nixos configuration";

  inputs = {
    # main inputs
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
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11"; # head
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager"; # unstable
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # utility
    disko.url = "github:nix-community/disko/latest";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    mac-app-util.url = "github:hraban/mac-app-util";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    rpi-nix.url = "github:nix-community/raspberry-pi-nix";
    systems.url = "github:nix-systems/default";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    # software inputs
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # apps
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions/";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      systems,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      lib = nixpkgs.lib // nix-darwin.lib // home-manager.lib;
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (system: nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = forEachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

      # Helper function for making nixos and darwin user configurations
      defineUsers =
        let
          # Inner function to collect the configuration for each user
          defineUser =
            acc:
            # deconstruct each user to find their username and system
            { username, system }:
            let
              pkgs = pkgsFor.${system};
            in
            {
              ${username} = import ./configurations/home/base.nix {
                inherit lib pkgs username;
              };
            }
            // acc;
        in
        # build the attrset
        # https://noogle.dev/f/builtins/foldl'
        userConfigs: builtins.foldl' defineUser { } userConfigs;
      # Helper function for making nixos systems
      defineNixosSystem =
        name: userConfigs:
        lib.nixosSystem {
          modules = [
            ./configurations/nixos/${name}
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                backupFileExtension = "bak";
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs outputs;
                };

                users = defineUsers userConfigs;
              };
            }
          ];
          # Pass these arguments through the modules
          specialArgs = {
            inherit inputs outputs userConfigs;
          };
        };
      # Helper function for making darwin systems
      defineDarwinSystem =
        name: userConfigs:
        lib.darwinSystem {
          modules = [
            ./configurations/darwin/${name}
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                backupFileExtension = "bak";
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs outputs;
                };

                users = defineUsers userConfigs;
              };
            }
          ];
          # Pass these arguments through the modules
          specialArgs = {
            inherit
              self
              inputs
              outputs
              userConfigs
              ;
          };
        };
      # Helper function for making standalone home-manager configurations
      defineHomeConfiguration =
        {
          username,
          system,
          profile,
        }@userConfig:
        let
          pkgs = pkgsFor.${system};
          # NOTE: home/default.nix expects a list of userConfigs to add to the
          # trustedUsers. The reasoning is that a NixOS or macOS system may have
          # multiple users, but the home-manager doesn't
          # This is a bit hacky but meh
          userConfigs = [
            userConfig
          ];
        in
        lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./configurations/home/base.nix
            ./configurations/home/${profile}.nix
          ];
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              username
              userConfigs
              ;
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
          profile = "wsl";
          username = "justinhoang";
          system = "x86_64-linux";
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
