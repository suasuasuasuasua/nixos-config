{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nix user repository
    nurpkgs.url = "github:nix-community/NUR";

    # Home manager
    home-manager = {
      # url = "github:nix-community/home-manager/release-24.05";
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spotify customization
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO:use disko eventually
    # disko = {
    #   url = "github:nix-community/disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Theming
    catppuccin.url = "github:catppuccin/nix";

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
    systems = nixosSystems;

    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;

    # Define the user
    name = "justin";
    user = {
      name = "${name}";
      fullName = "Justin Hoang";
      home = "/home/${name}";
      email = "j124.dev@gmail.com";
      browser = "firefox";
      editor = "nvim";
      terminal = "alacritty";
      system = "x86_64-linux";
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
          inherit inputs outputs user;
        };
        # > Our main nixos configuration file <
        modules = [
          ./hosts/dell/configuration.nix
        ];
      };
      # Acer Spin 713-3w Chromebook
      "penguin" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          hostname = "penguin";
          inherit inputs outputs user;
        };
        # > Our main nixos configuration file <
        modules = [
          ./hosts/nixos/configuration.nix
        ];
      };
      # ...
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager switch --flake .#your-username@your-hostname'
    homeConfigurations = {
      # Define the users
      "${user.name}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {
          inherit inputs outputs user;
        };
        # > Our main home-manager configuration file <
        modules = [
          ./home-manager/home.nix
        ];
      };

      # ...
    };
  };
}
