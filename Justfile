host := `uname -a`

os:
  nh os switch .

home:
  nh home switch .

fmt:
  nix fmt
