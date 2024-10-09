{
  description = "suasuasuasuasua's nixos and nix-darwin config";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO:use disko eventually
    # disko = {
    #   url = "github:nix-community/disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Theming
    catppuccin.url = "github:catppuccin/nix";

    # Spotify customization
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nvim through Nix
    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-24.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Firefox
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    # nix-homebrew,
    # TODO: uncomment when I get around to using
    # disko,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Supported systems for your flake packages, shell, etc.
    nixosSystems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
    ];

    darwinSystems = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    systems = nixosSystems ++ darwinSystems;

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # Define the user
    name = "justinhoang";
    user = {
      name = "${name}";
      fullName = "Justin Hoang";
      home = "/Users/${name}";
      email = "j124.dev@proton.me";
      browser = "firefox";
      editor = "nvim";
      terminal = "alacritty";
    };
  in {
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild switch --flake .#your-hostname'
    nixosConfigurations = {
      # Define the different NixOS systems

      # HP Optiplex 5060 Micro PC
      "dell" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          hostname = "dell";
          system = "x86_64-linux";
          inherit inputs outputs user;
        };
        modules = [
          # > Our main nixos configuration file <
          ./hosts/dell/configuration.nix
        ];
      };
      # Acer Spin 713-3w Chromebook
      "penguin" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          hostname = "penguin";
          system = "x86_64-linux";
          inherit inputs outputs user;
        };
        modules = [
          # > Our main nixos configuration file <
          ./hosts/penguin/configuration.nix
        ];
      };
      # ...
    };

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .
    darwinConfigurations = {
      # Macbook M3 Max
      "mbp" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          hostname = "mbp";
          system = "aarch64-darwin";
          inherit inputs outputs user;
        };
        modules = [
          # > Our main nix darwin configuration file <
          ./hosts/mbp/configuration.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager switch --flake .#your-username@your-hostname'
    homeConfigurations = {
      # Define the users
      "nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          system = "x86_64-linux";
          inherit inputs outputs user;
        };
        # > Our main home-manager configuration file <
        modules = [
          ./home-manager/nixos-home.nix
        ];
      };

      "darwin" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          system = "aarch64-darwin";
          inherit inputs outputs user;
        };
        # > Our main home-manager configuration file <
        modules = [
          ./home-manager/darwin-home.nix
        ];
      };

      # ...
    };
  };
}
