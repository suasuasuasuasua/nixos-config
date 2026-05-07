{
  inputs,
  lib,
  pkgsFor,
  users,
  infra,
}:
let
  inherit (inputs) home-manager stylix;

  mkUsers =
    system: userConfigs:
    let
      pkgs = pkgsFor.${system};
    in
    lib.mergeAttrsList (
      map (
        { username, ... }:
        {
          ${username} = import ../configurations/home/base.nix { inherit lib pkgs username; };
        }
      ) userConfigs
    );

  mkHomeManagerConfig = system: userConfigs: {
    home-manager = {
      backupFileExtension = "bak";
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs userConfigs; };
      users = mkUsers system userConfigs;
    };
  };
in
{
  mkNixosSystem =
    {
      name,
      system,
      userConfigs,
      enableHomeManager ? true,
    }:
    {
      ${name} = lib.nixosSystem {
        modules = [
          ../configurations/nixos/${name}
          stylix.nixosModules.stylix
        ]
        ++ lib.optionals enableHomeManager [
          home-manager.nixosModules.home-manager
          (mkHomeManagerConfig system userConfigs)
        ];
        specialArgs = {
          inherit
            inputs
            userConfigs
            infra
            users
            ;
        };
      };
    };

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
          stylix.homeModules.stylix
          ../configurations/home/base.nix
          ../configurations/home/${name}
        ];
        extraSpecialArgs = {
          inherit inputs userConfig username;
        };
      };
    };
}
