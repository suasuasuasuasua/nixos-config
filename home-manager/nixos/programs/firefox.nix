{
  inputs,
  pkgs,
  lib,
  user,
  ...
}: {
  programs.firefox = {
    enable = true;
    # profiles.${user.name} = {
      # TODO: why is it error on this?
      #        Did you mean one of nrr, nurl, nut, nuv or nux?
      # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      #   vimium
      #   ublock-origin
      #   darkreader
      #   betterttv
      #   firefox-color
      # ];
    # };
  };
}
