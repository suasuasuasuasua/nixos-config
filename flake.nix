{
  description = "sua's nixos configuration";

  inputs = {
    disko.url = "github:nix-community/disko/latest";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixgl.url = "github:nix-community/nixGL";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixvim-config.url = "git+https://gitea.sua.dev/sua/nixvim";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      systems,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib // home-manager.lib;
      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (system: nixpkgs.legacyPackages.${system});
      treefmtEval = forEachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

      users = import ./lib/users.nix;
      infra = import ./lib/infra.nix;

      inherit
        (import ./lib/mk.nix {
          inherit
            inputs
            lib
            pkgsFor
            users
            infra
            ;
        })
        mkNixosSystem
        mkHomeConfiguration
        ;
    in
    {
      inherit lib;

      formatter = lib.mapAttrs (_: eval: eval.config.build.wrapper) treefmtEval;

      checks = lib.mapAttrs (system: eval: {
        formatting = eval.config.build.check self;
        git-hooks-check = inputs.git-hooks-nix.lib.${system}.run {
          src = ./.;
          imports = [ ./git-hooks.nix ];
        };
      }) treefmtEval;

      devShells = forEachSystem (pkgs: {
        default = import ./shell.nix { inherit pkgs self; };
        ci = import ./shell-ci.nix { inherit pkgs self; };
      });

      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forEachSystem (pkgs: import ./pkgs pkgs);
      overlays = import ./overlays { inherit inputs lib; };
      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;
      homeManagerModules = import ./modules/home;
      sharedModules = import ./modules/shared;

      nixosConfigurations = lib.mergeAttrsList (
        map mkNixosSystem [
          {
            name = "lab";
            system = "x86_64-linux";
            userConfigs = [ users.justinhoang ];
          }
          {
            name = "pi";
            system = "aarch64-linux";
            userConfigs = [ users.admin ];
          }
          {
            name = "hp-optiplex0";
            system = "x86_64-linux";
            userConfigs = [ users.admin ];
            enableHomeManager = false;
          }
          {
            name = "hetzner-cloud-vps0";
            system = "x86_64-linux";
            userConfigs = [ users.admin ];
            enableHomeManager = false;
          }
        ]
      );

      homeConfigurations = lib.mergeAttrsList (
        map mkHomeConfiguration [
          {
            name = "ilmgf";
            system = "x86_64-linux";
            userConfig = users.justinhoang;
          }
          {
            name = "mbp3";
            system = "aarch64-darwin";
            userConfig = users.justinhoang;
          }
          {
            name = "penguin";
            system = "x86_64-linux";
            userConfig = users.justinhoang;
          }
        ]
      );
    };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://suasuasuasuasua.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "suasuasuasuasua.cachix.org-1:JAh0OWpJOvPHGS4zyK13xV+RBxgucR7TUwIAcr4j8KM="
    ];
  };
}
