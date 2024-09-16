{
  inputs,
  pkgs,
  lib,
  user,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.${user.name} = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        vimium
        ublock-origin
        darkreader
        betterttv
        firefox-color
      ];
    };
  };
}
