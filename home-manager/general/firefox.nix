{
  inputs,
  user,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.${user.name} = {
      extensions = with inputs.firefox-addons.packages.${user.system}; [
        vimium
        ublock-origin
        # adguard  # when is this coming out?
        darkreader
        # betterttv  # allowUnfree isn't working??
        firefox-color
      ];
    };
  };
}
