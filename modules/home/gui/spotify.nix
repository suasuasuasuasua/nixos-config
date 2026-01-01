{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.home.gui.spotify;
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  options.custom.home.gui.spotify = {
    enable = lib.mkEnableOption "Enable spotify (spicetify)";
  };

  config = lib.mkIf cfg.enable {
    programs.spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          shuffle # shuffle+ (special characters are sanitized out of extension names)
          history
          keyboardShortcut # vimium-like navigation
          playlistIcons
        ];
      };
  };
}
