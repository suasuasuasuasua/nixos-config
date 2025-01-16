{ flake
, pkgs
, ...
}:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
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
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
}
