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
    in
    {
      inherit lib;

      overlays = import ./overlays { inherit inputs outputs; };
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
        # https://discourse.nixos.org/t/nix-flake-check-to-check-for-error-messages/20832/4
        neovim-check-config =
          pkgs.runCommand "neovim-check-config"
            {
              buildInputs = with pkgs; [
                git
                neovim
              ];
            }
            # bash
            ''
              # We *must* create some output, usually contains test logs for
              # checks
              mkdir -p "$out"

              # Probably want to do something to ensure your config file is
              # read, too
              export HOME=$TMPDIR
              ${pkgs.neovim}/bin/nvim --headless -c "q" 2> "$out/nvim.log"

              if [ -n "$(cat "$out/nvim.log")" ]; then
                echo "output: "$(cat "$out/nvim.log")""
                exit 1
              fi
            '';
      });
      devShells = forEachSystem (pkgs: {
        default = import ./shell.nix {
          inherit self pkgs;
        };
      });

      nixosConfigurations = {
        lab = lib.nixosSystem {
          modules = [
            ./configurations/nixos/lab

            home-manager.nixosModules.home-manager
            (import ./configurations/home/module.nix {
              inherit inputs outputs;
              # define the users
              users = {
                # define each user separately
                justinhoang = import ./configurations/home/base.nix {
                  inherit lib;
                  pkgs = pkgsFor.x86_64-linux;
                  username = "justinhoang";
                };
              };
            })
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        legion = lib.nixosSystem {
          modules = [
            ./configurations/nixos/legion

            home-manager.nixosModules.home-manager
            (import ./configurations/home/module.nix {
              inherit inputs outputs;
              # define the users
              users = {
                # define each user separately
                justinhoang = import ./configurations/home/base.nix {
                  inherit lib;
                  pkgs = pkgsFor.x86_64-linux;
                  username = "justinhoang";
                };
              };
            })
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        penguin = lib.nixosSystem {
          modules = [
            ./configurations/nixos/penguin

            home-manager.nixosModules.home-manager
            (import ./configurations/home/module.nix {
              inherit inputs outputs;
              # define the users
              users = {
                # define each user separately
                justinhoang = import ./configurations/home/base.nix {
                  inherit lib;
                  pkgs = pkgsFor.x86_64-linux;
                  username = "justinhoang";
                };
              };
            })
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
        pi = lib.nixosSystem {
          modules = [
            ./configurations/nixos/pi

            home-manager.nixosModules.home-manager
            (import ./configurations/home/module.nix {
              inherit inputs outputs;
              # define the users
              users = {
                # define each user separately
                justinhoang = import ./configurations/home/base.nix {
                  inherit lib;
                  pkgs = pkgsFor.x86_64-linux;
                  username = "justinhoang";
                };
              };
            })
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };
      darwinConfigurations = {
        mbp3 = lib.darwinSystem {
          modules = [
            ./configurations/darwin/mbp3

            home-manager.darwinModules.home-manager
            (import ./configurations/home/module.nix {
              inherit inputs outputs;
              # define the users
              users = {
                # define each user separately
                justinhoang = import ./configurations/home/base.nix {
                  inherit lib;
                  pkgs = pkgsFor.aarch64-darwin;
                  username = "justinhoang";
                };
              };
            })
          ];
          specialArgs = {
            inherit self inputs outputs;
          };
        };
      };
      homeConfigurations = {
        # windows subsystem for linux
        wsl =
          let
            pkgs = pkgsFor.x86_64-linux;
          in
          lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              (import ./configurations/home/base.nix {
                inherit pkgs lib;
                username = "justinhoang";
              })
              ./configurations/home/wsl.nix
            ];
            extraSpecialArgs = {
              inherit inputs outputs;
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
