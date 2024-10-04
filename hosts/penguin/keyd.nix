{
  pkgs,
  ...
}: {
  # Ref:
  # https://github.com/ChocolateLoverRaj/nixos-system-config/blob/main/keyd.nix
  environment = {
    systemPackages = with pkgs; [
      keyd
    ];
    etc = {
      "libinput/local-overrides.quirks".text = ''
        [keyd virtual keyboard]
        MatchName=keyd virtual keyboard
        AttrKeyboardIntegration=internal
      '';
    };
  };
  services.keyd = {
    enable = true;
    keyboards.internal = {
      ids = [
        "k:0001:0001"
        "k:18d1:5044"
        "k:18d1:5052"
        "k:0000:0000"
        "k:18d1:5050"
        "k:18d1:504c"
        "k:18d1:503c"
        "k:18d1:5030"
        "k:18d1:503d"
        "k:18d1:505b"
        "k:18d1:5057"
        "k:18d1:502b"
        "k:18d1:5061"
      ];
      settings = {
        main = {
          sleep = "delete";
          zoom = "f11";
        };
        meta = {
          back = "f1";
          refresh = "f2";
          zoom = "f3";
          scale = "f4";
          # For some reason the "print" key (with the camera icon) is sysrq
          sysrq = "f5";
          brightnessdown = "f6";
          brightnessup = "f7";
          kbdillumtoggle = "f8";
          volumedown = "f10";
          volumeup = "f10";
          sleep = "f11";
        };
        alt = {
          backspace = "delete";
          meta = "capslock";
          brightnessdown = "kbdillumdown";
          brightnessup = "kbdillumup";
        };
        control = {
          scale = "print";
        };
      };
    };
  };
}
