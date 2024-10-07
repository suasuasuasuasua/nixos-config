{pkgs,...}:
{
  environment.systemPackages = with pkgs; [
      # Nix
      nixfmt-rfc-style
  ];
}
