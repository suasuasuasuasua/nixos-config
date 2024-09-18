{user, ...}: {
  # Define properties for the user
  home = {
    username = "${user.name}";
    homeDirectory = "${user.home}";

    sessionVariables = {
      EDITOR = "${user.editor}";
      VISUAL = "${user.editor}";
      BROWSER = "${user.browser}";
      TERMINAL = "${user.terminal}";
    };
  };
}
