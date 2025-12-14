{
  nix.settings = {
    trusted-users = [
      "justinhoang" # allow for remote builds
      "@users"
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
