{user,...}:
{
  # Define properties for the user
  home = {
    username = "${user.name}";
    homeDirectory = "${user.home}";

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "firefox";
      TERMINAL = "alacritty";
    };
  };
}
