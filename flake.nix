{
  description = "suasuasuasuasua's nixos configuration";

  inputs = {
    # main inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
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
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add this section to your flake inputs!
    #
    # Note that this assumes you have a flake-input called nixpkgs,
    # which is often the case. If you've named it something else,
    # you'll need to change the `nixpkgs` below.
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # utility
    disko.url = "github:nix-community/disko/latest";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    mac-app-util.url = "github:hraban/mac-app-util";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    # software inputs
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # apps
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim-config.url = "github:suasuasuasuasua/nixvim";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions/";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
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
      mkUsers =
        system: userConfigs:
        let
          # Define packages based on the system architecture
          pkgs = pkgsFor.${system};

          # Inner function to collect the configuration for each user
          mkUser =
            acc:
            # deconstruct each user to find their username
            { username, ... }:
            {
              ${username} = import ./configurations/home/base.nix {
                inherit lib pkgs username;
              };
            }
            // acc;
        in
        # build the attrset
        # https://noogle.dev/f/builtins/foldl'
        builtins.foldl' mkUser { } userConfigs;
      # Helper function for setting up home manager
      mkHomeManagerConfig = system: userConfigs: {
        home-manager = {
          backupFileExtension = "bak";
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs outputs userConfigs;
          };

          users = mkUsers system userConfigs;
        };
      };

      # Helper function for making nixos systems
      mkNixosSystem =
        {
          name,
          system,
          userConfigs,
          enableHomeManager ? true,
        }:
        {
          ${name} = lib.nixosSystem {
            modules =
              [ ./configurations/nixos/${name} ]
              ++ lib.optionals enableHomeManager [
                home-manager.nixosModules.home-manager
                (mkHomeManagerConfig system userConfigs)
              ];
            # Pass these arguments through the modules
            specialArgs = {
              inherit inputs outputs userConfigs;
            };
          };
        };

      # Helper function for making darwin systems
      mkDarwinSystem =
        {
          name,
          system,
          userConfigs,
          enableHomeManager ? true,
        }:
        {
          ${name} = lib.darwinSystem {
            modules =
              [ ./configurations/darwin/${name} ]
              ++ lib.optionals enableHomeManager [
                home-manager.darwinModules.home-manager
                (mkHomeManagerConfig system userConfigs)
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
        };
      # Helper function for making standalone home-manager configurations
      mkHomeConfiguration =
        {
          name,
          system,
          userConfig,
        }:
        let
          inherit (userConfig) username;

          pkgs = pkgsFor.${system};
        in
        {
          ${name} = lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              ./configurations/home/base.nix
              ./configurations/home/${name}.nix
            ];
            extraSpecialArgs = {
              inherit
                inputs
                outputs
                userConfig
                username
                ;
            };
          };
        };

      # Read the users from a file
      users = builtins.fromJSON (builtins.readFile ./data/users.json);
    in
    {
      inherit lib;

      overlays = import ./overlays { inherit inputs; };
      formatter = forEachSystem (
        pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper
      );

      checks = forEachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
        git-hooks-check = inputs.git-hooks-nix.lib.${pkgs.stdenv.hostPlatform.system}.run {
          src = ./.;
          imports = [ ./git-hooks.nix ];
        };
      });
      devShells = forEachSystem (pkgs: {
        default = import ./shell.nix {
          inherit pkgs self;
        };
      });

      nixosConfigurations = lib.mergeAttrsList (
        map mkNixosSystem [
          {
            name = "lab";
            system = "x86_64-linux";
            userConfigs = [ users.justinhoang ];
          }
          {
            name = "legion";
            system = "x86_64-linux";
            userConfigs = [ users.justinhoang ];
          }
          {
            name = "penguin";
            system = "x86_64-linux";
            userConfigs = [ users.justinhoang ];
          }
          {
            name = "optiplex";
            system = "x86_64-linux";
            userConfigs = [ users.admin ];
            enableHomeManager = false;
          }
          {
            name = "pi";
            system = "aarch64-linux";
            userConfigs = [ users.admin ];
            enableHomeManager = false;
          }
        ]
      );
      darwinConfigurations = lib.mergeAttrsList (
        map mkDarwinSystem [
          {
            name = "mbp3";
            system = "aarch64-darwin";
            userConfigs = [ users.justinhoang ];
          }
        ]
      );
      homeConfigurations = lib.mergeAttrsList (
        map mkHomeConfiguration [
          {
            name = "wsl";
            system = "x86_64-linux";
            userConfig = users.justinhoang;
          }
        ]
      );
    };
}
