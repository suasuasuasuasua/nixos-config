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
        {
          user,
          enableHomeManager ? true,
        }:
        lib.optionalAttrs enableHomeManager {
          ${user.username} = import ../configurations/home/base.nix {
            inherit lib pkgs;
            inherit (user) username;
          };
        }
      ) userConfigs
    );

  mkHomeManagerConfig = system: userConfigs: {
    home-manager = {
      backupFileExtension = "bak";
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs users; };
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
    }:
    {
      ${name} = lib.nixosSystem {
        modules = [
          ../configurations/nixos/${name}
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          (mkHomeManagerConfig system userConfigs)
        ];
        specialArgs = {
          inherit
            inputs
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
          inherit inputs username users;
        };
      };
    };
}
