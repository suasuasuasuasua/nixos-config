{pkgs, ...}:
# Ref
# https://discourse.nixos.org/t/help-with-avoiding-50gb-worth-of-rebuils/41655/15?u=chocolateloverraj
let
  cml-ucm-conf = pkgs.alsa-ucm-conf.overrideAttrs {
    wttsrc = pkgs.fetchurl {
      url = "https://github.com/WeirdTreeThing/chromebook-ucm-conf/archive/1328e46bfca6db2c609df9c68d37bb418e6fe279.tar.gz";
      hash = "sha256-eTP++vdS7cKtc8Mq4qCzzKtTRM/gsLme4PLkN0ZWveo=";
    };
    unpackPhase =
      /*
      bash
      */
      ''
        runHook preUnpack
        tar xf "$src"
        tar xf "$wttsrc
        runHook postUnpack
      '';
    installPhase =
      /*
      bash
      */
      ''
        runHook preInstall
        mkdir -p $out/share/alsa
        cp -r alsa-ucm*/{ucm,ucm2} $out/share/alsa
        cp -r chromebook-ucm*/common $out/share/alsa/ucm2
        cp -r chromebook-ucm*/adl/* $out/share/alsa/ucm2/conf.d
        runHook postInstall
      '';
  };
in {
  boot = {
    extraModprobeConfig =
      /*
      bash
      */
      ''
        options snd-intel-dspcfg dsp_driver=3
      '';
  };

  environment = {
    systemPackages = with pkgs; [
      maliit-keyboard
      sof-firmware
    ];
    sessionVariables.ALSA_CONFIG_UCM2 = "${cml-ucm-conf}/share/alsa/ucm2";
  };

  system.replaceRuntimeDependencies = [
    {
      original = pkgs.alsa-ucm-conf;
      replacement = cml-ucm-conf;
    }
  ];
}
