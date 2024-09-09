{
  home-manager = {
    extraSpecialArgs = {
      inherit inputs outputs;
    };
    users = {
      justin = import ../../home-manager/home.nix;
    };
  };
}
