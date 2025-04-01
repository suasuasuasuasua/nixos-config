{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;

  cfg = config.home.gui.spotify;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  options.home.gui.spotify = {
    enable = lib.mkEnableOption "Enable spotify (spicetify)";
    # TODO: add options for packages for custom config
    # TODO: add options for theme
    colorScheme = lib.mkOption {
      type = lib.types.str;
      default = "mocha";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in
      {
        inherit (cfg) colorScheme;

        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          shuffle # shuffle+ (special characters are sanitized out of extension names)
          history
          keyboardShortcut # vimium-like navigation
          playlistIcons
        ];
        theme = spicePkgs.themes.catppuccin;
      };
  };
}
